include "%limits"

type pervasive point: record
	y: int
	x: int
end record

var file: nat
var line: string

var points: array 1..1000000 of point
var cnt: nat := 0

var w, h: nat := 0

open :file, 1, get
loop
	exit when eof(file)
	get :file, line: *
	h += 1
	
	w := length(line)
	for x : 1..w
		if line(x) = "#" then
			cnt += 1
			points(cnt).y := h
			points(cnt).x := x
		end if
	end for
end loop
close :file

% put cnt
% put w
 %put h

procedure distances(expansion: nat)

	var rows : array 0..h of nat
	var cols : array 0..w of nat

	rows(0) := 0
	for i : 1..h
		rows(i) := expansion
	end for

	cols(0) := 0
	for i : 1..w
		cols(i) := expansion
	end for

	for i : 1..cnt
		rows(points(i).y) := 1
		cols(points(i).x) := 1
	end for

	for i : 1..h
		rows(i) += rows(i-1)
	end for

	for i : 1..w
		cols(i) += cols(i-1)
	end for

	var sum: real := 0
	for i : 1..cnt
		for j : i+1..cnt
			var dy: nat := abs(rows(points(i).y) - rows(points(j).y))
			var dx: nat := abs(cols(points(i).x) - cols(points(j).x))
			% put dy + dx
			sum += dy + dx
			% put sum :0 :0
		end for
	end for

	put sum :0 :0

end distances

% put numdigits

distances(2)
% distances(10)
% distances(100)
distances(1000000)
