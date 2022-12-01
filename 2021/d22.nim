#? replace(sub = "\t", by = "  ")
# Let's do some unicode shitpost
# Don't forget to compile with --experimental:unicodeOperators
import strutils, sequtils, sugar, tables

let lines = readFile("input22.txt").strip.splitLines

type Cuboid = object
	x1: int
	x2: int
	y1: int
	y2: int
	z1: int
	z2: int

type Instruction = object
	c: Cuboid
	val: bool

var instructions: seq[Instruction] = @[]

for line in lines:
	var ins = Instruction()
	var rline = ""
	if line.startsWith("on"):
		ins.val = true
		rline = line[3..<line.len]
	else:
		ins.val = false
		rline = line[4..<line.len]
	let coords = rline.split(",").map(y => y[2..<y.len].split("..").map(parseInt))
	ins.c.x1 = coords[0][0]
	ins.c.x2 = coords[0][1]
	ins.c.y1 = coords[1][0]
	ins.c.y2 = coords[1][1]
	ins.c.z1 = coords[2][0]
	ins.c.z2 = coords[2][1]

	instructions.add(ins)

proc `∩`(a,b: Cuboid): Cuboid =
	return Cuboid(
		x1: max(a.x1,b.x1),
		y1: max(a.y1,b.y1),
		z1: max(a.z1,b.z1),
		x2: min(a.x2,b.x2),
		y2: min(a.y2,b.y2),
		z2: min(a.z2,b.z2)
	)
proc `?`(a: Cuboid): bool =
	return a.x1 <= a.x2 and a.y1 <= a.y2 and a.z1 <= a.z2 

proc sumtables[T](a,b: Table[T,int]): Table[T,int] = 
	for i,v in a.pairs():
		if i in result:
			result[i] = result[i] + v
		else:
			result[i] = v
	for i,v in b.pairs():
		if i in result:
			result[i] = result[i] + v
		else:
			result[i] = v


proc solve(zone: Cuboid): int =
	var ctable: Table[Cuboid,int]
	var oncube = 0
	for i in instructions:
		var cc = zone ∩ i.c
		if not ?(cc): continue
		var tmp: Table[Cuboid,int]
		for cuboid,count in ctable:
			let i = cuboid ∩ cc
			if ?(i):
				if i notin tmp: tmp[i] = 0
				tmp[i] -= count
		ctable = sumtables(ctable, tmp)
		if i.val:
			if cc notin ctable: ctable[cc] = 0
			ctable[cc] += 1

	for cb, count in ctable:
		oncube += count * (cb.x2 - cb.x1 + 1) * (cb.z2 - cb.z1 + 1) * (cb.y2 - cb.y1 + 1)
	return oncube

echo "Result1: ",solve(Cuboid(x1: -50,y1: -50,z1: -50,x2: 50,y2: 50,z2: 50))
echo "Result2: ",solve(Cuboid(x1: -999999,y1: -999999,z1: -999999,x2: 999999,y2: 999999,z2: 999999))
