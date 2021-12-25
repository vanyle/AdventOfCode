#? replace(sub = "\t", by = "  ")

import strutils

var state = readFile("input25.txt").strip.splitLines


proc get(cucu: seq[string], x: int, y: int): char =
	let my = y mod cucu.len
	let mx = x mod cucu[my].len
	return cucu[my][mx]
proc set(cucu: var seq[string], x: int, y: int, val: char) =
	let my = y mod cucu.len
	let mx = x mod cucu[my].len
	cucu[my][mx] = val

proc step(cucu: var seq[string]): bool =
	# east
	var isMove = false
	var cp = cucu.deepcopy()
	for y in 0..<cucu.len:
		for x in 0..<cucu[y].len:
			if cucu.get(x,y) == '>' and cucu.get(x+1,y) == '.':
				cp.set(x,y,'.')
				cp.set(x+1,y,'>')
				isMove = true

	cucu = cp
	cp = cucu.deepcopy()
	for y in 0..<cucu.len:
		for x in 0..<cucu[y].len:
			if cucu.get(x,y) == 'v' and cucu.get(x,y+1) == '.':
				cp.set(x,y,'.')
				cp.set(x,y+1,'v')
				isMove = true

	cucu = cp
	return isMove

var isChange = true
var counter = 0
while isChange:
	isChange = step(state)
	counter += 1
echo "Result: ",counter