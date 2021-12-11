#? replace(sub = "\t", by = "  ")

import strutils, sequtils

let lines = readFile("input11.txt").splitLines

# squids are octopuses.
var squidmap: seq[seq[int]] = @[]

for l in lines:
	squidmap.add(@[])
	for i in l:
		squidmap[squidmap.len - 1].add(i.int - '0'.int)

template yieldIfExists(squidmap: seq[seq[int]] ,x: int, y: int) =
	if x >= 0 and y >= 0 and x < squidmap.len and y < squidmap[x].len:
		yield (x,y)

iterator neighbours(squidmap: seq[seq[int]] ,x: int, y: int): tuple[x,y: int] =
	yieldIfExists(squidmap,x+1,y)
	yieldIfExists(squidmap,x-1,y)
	yieldIfExists(squidmap,x,y+1)
	yieldIfExists(squidmap,x,y-1)

	yieldIfExists(squidmap,x+1,y-1)
	yieldIfExists(squidmap,x+1,y+1)
	yieldIfExists(squidmap,x-1,y-1)
	yieldIfExists(squidmap,x-1,y+1)
	

var step = 0

while true:
	step += 1
	for x in 0..<squidmap.len:
		for y in 0..<squidmap[x].len:
			squidmap[x][y] += 1
	
	var energyIncreased = true
	while energyIncreased:
		energyIncreased = false
		for x in 0..<squidmap.len:
			for y in 0..<squidmap[x].len:
				if squidmap[x][y] > 9:
					squidmap[x][y] = -1 # mark as already flashed
					for n in squidmap.neighbours(x,y):
						if squidmap[n.x][n.y] != -1:
							squidmap[n.x][n.y] += 1
							energyIncreased = true
	# Clean up: -1 -> 0
	var sync = true
	for x in 0..<squidmap.len:
		for y in 0..<squidmap[x].len:
			if squidmap[x][y] == -1:
				squidmap[x][y] = 0
			else:
				sync = false
	if sync:
		break


echo "Result: ",step