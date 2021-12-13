#? replace(sub = "\t", by = " ")

import strutils, sequtils, sets

type pos = object
	x,y: int

let lines = readFile("input13.txt").splitLines
var dots: seq[pos] = @[]
var folds: seq[tuple[x: int, dir: bool]] = @[]

var i = 0

while i<lines.len:
	let l = lines[i]
	if l.len == 0: break
	let p = l.split(",").map(parseInt)
	dots.add(pos(x: p[0],y: p[1]))
	i += 1

i += 1
while i<lines.len:
	let l = lines[i]
	var n = l[13..<l.len].parseInt
	var dir = 'x' in l
	folds.add((x: n, dir: dir))
	i += 1

proc fold(p: int, dir: bool, dots: var seq[pos]) =
	for i in 0..<dots.len:
		if dir: # x fold -> left
			if dots[i].x > p:
				dots[i].x = 2*p - dots[i].x
		else:
			if dots[i].y > p:
				dots[i].y = 2*p - dots[i].y

fold(folds[0].x, folds[0].dir, dots)

# Count dots
var dotset = initHashSet[pos]()
for i in dots:
	dotset.incl(i)

echo "Result: ",dotset.len
