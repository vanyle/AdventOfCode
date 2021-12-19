#? replace(sub = "\t", by = "    ")
import strutils, sequtils, sets

let sections = readFile("input19.txt").strip.split("\n\n")
type pos = tuple[x,y,z: int]

func process(s: string): HashSet[pos] = 
	var r = s.splitLines();
	r = r[1..<r.len]
	result = initHashSet[pos]()
	for i in 0..<r.len:
		var tmp = r[i].split(",").map(parseInt)
		result.incl((tmp[0], tmp[1], tmp[2]))

var scanners = sections.map(process)

proc rotate(x, y, z: int, ori: seq[int]): pos =
	var r = [0, 0, 0]
	var axis = @[0, 1, 2]
	r[axis[ori[1]]] = x * ori[0]
	axis.delete(ori[1])
	r[axis[ori[3]]] = y * ori[2]
	axis.delete(ori[3])
	r[axis[0]] = z * ori[4]
	result.x = r[0]
	result.y = r[1]
	result.z = r[2]

proc unrotate(x, y, z: int, ori: seq[int]): pos =
    var ins = @[x, y, z]
    var axis = @[0, 1, 2]
    result = (0,0,0)
    result[0] = ins[axis[ori[1]]] * ori[0]
    axis.delete(ori[1])
    result[1] = ins[axis[ori[3]]] * ori[2]
    axis.delete(ori[3])
    result[2] = ins[axis[0]] * ori[4]

var orientations: seq[seq[int]] = @[]
for xneg in [-1,1]:
	for xaxis in [0,1,2]:
		for yneg in [-1,1]:
			for yaxis in [0,1]:
				for zneg in [-1,1]:
					orientations.add(@[
						xneg,xaxis,yneg,yaxis,zneg
					])	

var diffTable: seq[seq[HashSet[int]]] = @[]
for sc in scanners:
	var a: seq[HashSet[int]] = @[]
	for b1 in sc:
		for b2 in sc:
			if b1 != b2:
				let dp = @[abs(b1[0] - b2[0]), abs(b1[1] - b2[1]), abs(b1[2] - b2[2])]
				a.add(dp.toHashSet)
	diffTable.add(a)

proc match(i,j: int): tuple[s: HashSet[pos], b: pos] =
	let scanA = scanners[i]
	let scanB = scanners[j]
	var mayMatchCount = 0
	for e in diffTable[i]:
		for f in diffTable[j]:
			if mayMatchCount >= 11*11:
				break
			if e == f:
				mayMatchCount += 1
		if mayMatchCount >= 11*11:
			break
	if mayMatchCount < 11*11:
		# There cannot be any beacon in common no matter the orientation considered
		return (s: initHashSet[pos](), b: (0,0,0))

	for ori in orientations:
		for v1 in scanA:
			for v2 in scanB:
				var match_count = 0
				var i = 0
				for v3 in scanA:
					if v1 == v3: continue
					let dori = rotate(v3[0] - v1[0], v3[1] - v1[1], v3[2] - v1[2], ori)
					if (v2[0] + dori[0], v2[1] + dori[1], v2[2] + dori[2]) in scanB:
						match_count += 1
					
					if scanA.len - i < 11-match_count: break

					if match_count >= 11:
						var v4 = rotate(v1[0], v1[1], v1[2], ori)
						let dx = v4[0] - v2[0]
						let dy = v4[1] - v2[1]
						let dz = v4[2] - v2[2]
						var rev0: HashSet[pos] = initHashSet[pos]()
						for posB in scanB:
							rev0.incl(
								unrotate(posB.x + dx,posB.y + dy, posB.z + dz, ori)
							)
						let rev1 = unrotate(dx, dy, dz, ori)
						return (s: rev0, b: rev1)
					i += 1

	return (s: initHashSet[pos](), b: (0,0,0))


var tomatch = @[0]
var matched: HashSet[int] = toHashSet(@[0])

var beacons = scanners[0]
var scanners_pos: HashSet[pos] = @[(x: 0, y: 0, z: 0)].toHashSet


while tomatch.len > 0:
	var newtomatch: seq[int] = @[]
	echo tomatch
	for sidx in tomatch:
		for i,scanner in scanners.pairs():
			if i in matched: continue
			var res = match(sidx, i)
			if res.s.len > 0:
				newtomatch.add(i)
				matched.incl(i)
				scanners[i] = res.s
				scanners_pos.incl(res.b)
				for b in res.s:
					beacons.incl(b)
	tomatch = newtomatch

echo "Result: ",len(beacons)

var maxdist = 0
for p1 in scanners_pos:
	for p2 in scanners_pos:
		let d = abs(p1.x - p2.x) + abs(p1.y - p2.y) + abs(p1.z - p2.z)
		if d > maxdist: maxdist = d

echo "Result2: ", maxdist