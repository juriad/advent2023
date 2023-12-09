fs = require 'fs'

parseInput = (fn) ->
	fileContent = fs.readFileSync fn, 'utf8'
	lines = fileContent.trim().split "\n"
	((parseInt n for n in line.split(" ")) for line in lines)

diff = (line) ->
	(e - line[i-1] for e, i in line when i > 0)
	
diffs = (line) ->
	ds = [line]
	while line.length > 0
		d = diff line
		ds.push d
		line = d
	ds

extrapolate = (ds, combine) ->
	ds.reverse()
	ds[0].push 0
	for d, i in ds when i > 0
		up = ds[i-1][ds[i-1].length-1]
		left = d[d.length-1]
		d.push combine up, left
		
sum2 = (a, b) -> a + b

sum = (input) ->
	lasts = (i[i.length-1] for i in input)
	lasts.reduce sum2, 0
	
task = (fn, adjust) ->
	input = parseInput fn
	adjust i for i in input
	extrapolate (diffs i), sum2 for i in input
	console.log sum input
	
task process.argv[2], ->
task process.argv[2], (a) -> a.reverse()

