type dir =
	| Right
	| Down
	| Left
	| Up;

let bit = dir =>
	switch(dir) {
	| Right => 1
	| Down => 2
	| Left => 4
	| Up => 8
	};

let readInput = fileName => {
	let content = In_channel.with_open_text(fileName, a =>
		In_channel.input_all(a));
	let lines = Str.split(Str.regexp("[\n]"), String.trim(content));
	Array.of_list(List.map(a => 
		Array.of_seq(String.to_seq(a)), lines));
}

let goRight = (y, x) => (y, x+1, Right);
let goDown = (y, x) => (y+1, x, Down);
let goLeft = (y, x) => (y, x-1, Left);
let goUp = (y, x) => (y-1, x, Up);

let straight = (y, x, d) =>
	switch (d) {
	| Right => [goRight(y, x)]
	| Down => [goDown(y, x)]
	| Left => [goLeft(y, x)]
	| Up => [goUp(y, x)]
	};

let turn = (y, x, d, c) =>
	switch (d, c) {
	| (Right, '/')
	| (Left, '\\') => [goUp(y, x)]
	| (Right, '\\')
	| (Left, '/') => [goDown(y, x)]
	| (Up, '/')
	| (Down, '\\') => [goRight(y, x)]
	| (Up, '\\')
	| (Down, '/') => [goLeft(y, x)]
	| (_, _) => []
	};
	
let split = (y, x, d, c) =>
	switch (d, c) {
	| (Up, '-')
	| (Down, '-') => [goLeft(y, x), goRight(y, x)]
	| (Left, '|')
	| (Right, '|') => [goUp(y, x), goDown(y, x)]
	| _ => straight(y, x, d)
	};
	
let shine = (y, x, d, c) =>
	switch(c) {
	| '.' => straight(y, x, d)
	| '/'
	| '\\' => turn(y, x, d, c)
	| '|'
	| '-' => split(y, x, d, c)
	| _ => []
	};
	
let inRange = (arr, y, x) =>
	y >= 0 && y < Array.length(arr) 
		&& x >= 0 && x < Array.length(Array.get(arr, y));

let apply = (arr, beams, y, x, d) => {
	let c = Array.get(Array.get(arr, y), x);
	let bs = Array.get(Array.get(beams, y), x);
	let b = bit(d);
	if ((bs land b) == 0) {
		Array.set(Array.get(beams, y), x, bs lor b);
		let cand = shine(y, x, d, c);
		List.filter(((y, x, _),) => inRange(arr, y, x), cand);
	} else {
		[]
	}
};

let rec mark = (arr, beams, queue) =>
	switch (queue) {
	| [] => ()
	| [(y, x, d), ...tail] => 
		let q = apply(arr, beams, y, x, d) @ tail;
		mark(arr, beams, q);
	};

let count = (beams) =>
	Array.fold_left((a, b) => 
		a + Array.fold_left((a, b) => 
			a + (b > 0 ? 1 : 0), 0, b), 0, beams);

let _print = (beams) =>
	Array.iter(r => {
		Array.iter(c => {
			print_char(c > 0 ? '#' : '.');
		}, r);
		print_newline();
	}, beams);

let flood = (grid, start) => {
	let beams = Array.map(r => Array.map(_ => 0, r), grid);
	let arr = Array.map(r => Array.copy(r), grid);
	mark(arr, beams, [start]);
	count(beams);
};

let allStarts = arr => {
	let h = Array.length(arr);
	let w = Array.length(Array.get(arr, 0));
	let horiz = List.mapi((y, _) => 
		[(y, 0, Right), (y, w-1, Left)], 
		Array.to_list(arr))
	let vert = List.mapi((x, _) => 
		[(0, x, Down), (h-1, x, Up)], 
		Array.to_list(Array.get(arr, 0)))
	List.flatten(vert @ horiz);
};

let main = () => {
	let fileName = Array.get(Sys.argv, 1);
	let arr = readInput(fileName);
	let start = (0, 0, Right);
	
	let cnt = flood(arr, start);
	print_int(cnt);
	print_newline();
	
	let start = allStarts(arr);
	let cnts = List.map(st => flood(arr, st), start);
	let maxCnt = List.fold_left(Int.max, 0, cnts);
	
	print_int(maxCnt);
	print_newline();
};

main();


