type dist {
	int d;
	int c;
}

(dist d) countUntil (string[][] grid, int y, int x, int dy, int dx) {
	if (y < 0 || x < 0 || y >= length(grid)) { 
		d.d = 0;
		d.c = 0;
	} else if (x >= length(grid[y])) {
		d.d = 0;
		d.c = 0;
	} else if (grid[y][x] == "#") {
		d.d = 0;
		d.c = 0;
	} else {
		dist d2 = countUntil(grid, y + dy, x + dx, dy, dx);
		d.d = d2.d + 1;
		
		if (grid[y][x] == "O") {
			d.c = d2.c + 1;
		} else {
			d.c = d2.c;
		}
	}
}

(string[][] tilted) tilt (string[][] grid, int dy, int dx) {
	foreach row, y in grid {
		foreach c, x in row {
			string n;
			if (grid[y][x] == "#") {
				 n = "#";
			} else {
				dist dn = countUntil(grid, y, x, dy, dx);
				dist ds = countUntil(grid, y - dy, x - dx, -dy, -dx);
				if (dn.c + ds.c >= dn.d) {
					n = "O";
				} else {
					n = ".";
				}
			}
			tilted[y][x] = n;
		}
	}
}

(int s) sumRow (string[] row, int w, int x) {
	if (x >= length(row)) {
		s = 0;
	} else if (row[x] == "O") {
		s = w + sumRow(row, w, x + 1);
	} else {
		s = sumRow(row, w, x + 1);
	}
}

(int s) sum (string[][] grid, int y) {
	if (y >= length(grid)) {
		s = 0;
	} else {
		int ss = sumRow(grid[y], length(grid) - y, 0);
		// tracef("Line %d: %d\n", y, ss);
		s = sum(grid, y + 1) + ss;
	}
}

(string s) serialize (string[][] grid) {
	string[] lines;
	foreach row, y in grid {
		lines[y] = strjoin(row, "");
	}
	s = strjoin(lines, "\n");
}

(string[][] grid) loadFromFile (string fileName) {
	string lines[] = readData(fileName);
	foreach line, y in lines {
		foreach c, x in strsplit(line, "") {
			grid[y][x] = c;
			// tracef("Line %d %d: %s\n", y, x, c);
		}
	}
}

(string[][] cycled) cycle(string[][] grid) {
	string[][] n;
	if (length(grid) > 0) {
		n = tilt(grid, -1, 0);
	} else {
		n[0][0] = "";
	}
	string[][] w;
	if (length(n) > 0) {
		w = tilt(n, 0, -1);
	} else {
		w[0][0] = "";
	}
	string[][] s;
	if (length(w) > 0) {
		s = tilt(w, 1, 0);
	} else {
		s[0][0] = "";
	}
	string[][] e;
	if (length(s) > 0) {
		e = tilt(s, 0, 1);
	} else {
		e[0][0] = "";
	}
	cycled = e;
}

cycling (string[][] grid, int step) {
	int s = sum(grid, 0);
	tracef("Step\t%d\t%d\n", step, s);
	
	//if (step < 100) {
		string[][] cycled = cycle(grid);
		
		// tracef("%s\n\n", serialize(cycled));
		
		cycling(cycled, step + 1);
	//}
}

main () {
	string[][] grid = loadFromFile(arg("input"));

	//string[][] tilted = tilt(grid, -1, 0);

	//tracef("Tilted: %q\n", tilted);

	//int t1 = sum(tilted, 0);

	//tracef("Sum: %d\n", t1);
	
	//tracef("%s\n\n", serialize(grid));
	
	
	cycling(grid, 0);
}

main();
