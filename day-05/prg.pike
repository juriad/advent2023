class seed {
	int frm;
	int cnt;
	int prt;
	int rnd;
	
	void create(int f, int c, int p, int r) {
		frm = f;
		cnt = c;
		prt = p;
		rnd = r;
	}
	
	string _sprintf(int conversion_type, mapping(string:int)|void params) {
		return "<" + frm + ":" + cnt + "#" + prt + "@" + rnd + ">";
	}
}

class step {
	array(seed) seeds;
	int cont;
	
	void create(array(seed) ss, int c) {
		seeds = ss;
		cont = c;
	}
}

int parse_int(string s) {
	return (int) s;
}

step transform(array(seed) old_seeds, int rnd) {
	Stdio.stdin.gets();
	
	array(seed) seeds = old_seeds + ({ });
	
	string r;
	while(1) {
		r = Stdio.stdin.gets();
		if (r == 0 || sizeof(r) == 0) {
			break;
		}
		
		array(int) recipe = map(r / " ", parse_int);
		int dst = recipe[0];
		int src = recipe[1];
		int len = recipe[2];
		
		for (int i = 0; i < sizeof(seeds); i++) {
			seed s = seeds[i];
			if (s->rnd >= rnd) {
				continue;
			}
			
			if (s.frm >= src + len || s->frm + s->cnt - 1 < src) {
				// no intersection
				continue;
			}
			
			int first_common = max(s->frm, src);
			int past_common = min(s->frm + s->cnt, src + len);
			
			// before
			
			if (s->frm < first_common) {
				seeds += ({ seed(s->frm, first_common - s->frm, s->prt, s->rnd) });
			}
			
			// after
			
			if (s->frm + s->cnt > past_common) {
				seeds += ({ seed(past_common, (s->frm + s->cnt) - past_common, s->prt, s->rnd) });
			}
			
			// overlap
			
			seeds[i] = seed(first_common + (dst - src), past_common - first_common, s->prt, s->rnd + 1);
		}
	}
	
	for (int i = 0; i < sizeof(seeds); i++) {
		seed s = seeds[i];
		if (s->rnd < rnd) {
			s->rnd += 1;
		}
	}
	
	return step(seeds, r != 0);
}

int main() {
	string seeds_line = Stdio.stdin.gets();
	array(int) int_seeds = map((seeds_line / " ") - ({"seeds:"}), parse_int);
	
	array(seed) seeds1 = map(int_seeds, lambda(int s) { return seed(s, 1, 1, 0); });
	array(seed) seeds2 = map(int_seeds / 2, lambda(array(int) s) { return seed(s[0], s[1], 2, 0); });
	
	Stdio.stdin.gets();
	
	array(seed) seeds = seeds1 + seeds2;
	
	for(int i = 1; i >= 0; i++) {
		step stp = transform(seeds, i);
		
		// write("%O\n", stp->seeds);
		
		seeds = stp->seeds;
		if (stp->cont == 0) {
			break;
		}
	}
	
	int p1 = Array.reduce(min, map(filter(seeds, lambda(seed s) { return s->prt == 1; }), lambda(seed s) { return s->frm; }));
	write("%d\n", p1);
	int p2 = Array.reduce(min, map(filter(seeds, lambda(seed s) { return s->prt == 2; }), lambda(seed s) { return s->frm; }));
	write("%d\n", p2);
}
