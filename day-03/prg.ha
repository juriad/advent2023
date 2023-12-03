use ascii;
use bufio;
use fmt;
use io;
use os;
use sort;
use strconv;
use strings;

fn count_operators_around(grid: [][]rune, y: int, x: int, l: int, n: int, gears: *[]gear) int = {
	let cnt: int = 0;
	for (let dy: int = y - 1; dy <= y + 1; dy += 1) {
		for (let dx: int = x - 1; dx <= x + l; dx += 1) {
			if (dy < 0 || dy >= len(grid):int || dx < 0 || dx >= len(grid[0]):int) {
				continue;
			};
			const r = grid[dy][dx];
			if (r == '.' || ascii::isdigit(r)) {
				continue;
			};
			if (r == '*') {
				append(gears, gear {y = dy, x = dx, n = n});
			};
			cnt += 1;
		};
	};
	return cnt;
};

type gear = struct {
	y: int,
	x: int,
	n: int
};

fn cmp(a: const *gear, b: const *gear) int = {
	if (a.y < b.y) {
		return -1;
	};
	if (a.y > b.y) {
		return 1;
	};
	if (a.x < b.x) {
		return -1;
	};
	if (a.x > b.x) {
		return 1;
	};
	return 0;
};

export fn main() void = {
	let grid: [][]rune = [];
	let gears: []gear = [];
	// TODO free

	for (true) {
		const line = match (bufio::read_line(os::stdin)!) {
		case let line: []u8 =>
			yield line;
		case io::EOF =>
			break;
		};
		append(grid, strings::torunes(strings::trim(strings::fromutf8(line)!)));
	};
	
	const height: int = len(grid) : int;
	const width: int = len(grid[0]) : int;
	
	let sum: int = 0;

	for (let y: int = 0; y < height; y += 1) {
		for (let x: int = 0; x < width; x += 1) {
			let num: []rune = [];
			for(x < width && ascii::isdigit(grid[y][x]); x += 1) {
				const r = grid[y][x];
				append(num, r);
			};
			if (len(num) > 0) {
				const s = strings::fromrunes(num);
				const n = strconv::stoi(s)!;
				const ops = count_operators_around(grid, y, x - len(s):int, len(s):int, n, &gears);
				
				// fmt::printfln("Number {} has {} ops", s, ops)!;
				if (ops > 0) {
					sum += n;
				};
			};
		};
	};
	
	fmt::printfln("{}", sum)!;
	
	sort::sort(gears, size(gear), (&cmp):*sort::cmpfunc);
	
	let sum2: int = 0;
	let same: size = 1;
	
	for (let i = 0z; i < len(gears); i += same) {
		const g = gears[i];
		let prod: int = 1;
		same = 0;
		
		for (let j = i; j < len(gears) && gears[j].y == g.y && gears[j].x == g.x; j += 1) {
			same += 1;
			prod *= gears[j].n;
		};
		
		if (same == 2) {
			sum2 += prod;
		};
	
		// fmt::printfln("gear {} {} = {} (same {})", gears[i].y, gears[i].x, gears[i].n, same)!;
	};
	
	fmt::printfln("{}", sum2)!;
};

