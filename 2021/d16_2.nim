#? replace(sub = "\t", by = "  ")
import strutils, sequtils

let msg = readFile("input16.txt")

var binstr = ""

for i in msg:
	binstr &= fromHex[int]($i).toBin(4)

type Packet = object
	version: int
	typeId: int
	lit: int
	opMode: bool
	subPackCount: int
	subLenCount: int
	childrens: seq[Packet]

proc parsePacket(bStr: string): tuple[p: Packet,i: int] =
	## Return a packet and it's length in bits.
	var pack: Packet
	pack.childrens = @[]
	pack.version = parseBinInt(bStr[0..2])
	pack.typeId = parseBinInt(bStr[3..5])
	
	if pack.typeId == 4:
		var litVal = ""
		var litI = 7
		while true:
			litVal &= bStr[litI..litI+3]
			litI += 5
			if bStr[litI-1 - 5] == '0':
				break
		pack.lit = parseBinInt(litVal)
		return (p: pack,i: litI - 1)
	else:
		var i = 7
		pack.opMode = parseBinInt($bStr[6]) == 1
		if pack.opMode:
			pack.subPackCount = parseBinInt(bStr[7..(7 + 11 - 1)])
			i = 7 + 11
			# Parse the subpackets:
			var s = bStr[(7 + 11)..<bStr.len]
			for pcount in 0..<pack.subPackCount:
				var pp = parsePacket(s)
				s = s[(pp.i)..<s.len] # but the end of the string.
				i += pp.i
				pack.childrens.add(pp.p)
		else:
			pack.subLenCount = parseBinInt(bStr[7..(7 + 15 - 1)])
			i = 7 + 15
			var s2 = bStr[i..<(i + pack.subLenCount)]
			var s = s2
			# For there to be a new packet to parse, there needs to be 6 more bytes, otherwise,
			# its just padding.
			while i-7-15 < s2.len:
				var pp = parsePacket(s)
				if pp.i != s.len:
					s = s[(pp.i)..<s.len]
				pack.childrens.add(pp.p)
				i += pp.i
			# assert i == 7 + 15 + pack.subLenCount
			i = 7 + 15 + pack.subLenCount

		return (pack,i)

let pack = parsePacket(binstr)

proc evalPacket(p: Packet): int =
	if p.typeId == 4: return p.lit
	let vals: seq[int] = p.childrens.map(evalPacket)
	if p.typeId == 0:
		var s = 0
		for v in vals: s += v
		return s
	if p.typeId == 1:
		var s = 1
		for v in vals: s *= v
		return s
	if p.typeId == 2:
		return min(vals)
	if p.typeId == 3:
		return max(vals)
	if p.typeId == 5:
		return if vals[0] > vals[1]: 1 else: 0
	if p.typeId == 6:
		return if vals[0] < vals[1]: 1 else: 0
	if p.typeId == 7:
		return if vals[0] == vals[1]: 1 else: 0
	return 0

echo "Result: ",evalPacket(pack.p)