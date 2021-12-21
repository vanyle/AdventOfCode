#? replace(sub = "\t", by = "  ")

import strutils, sequtils, sugar

let content = readFile("input20.txt").split("\n\n")
let iea = content[0] # Image enhancement algorithm
let img = content[1].strip.splitLines
# The following line has a lot of sugar in it.
let idata = img.map(s => toSeq(s.items).map(i => i == '#'))

type InfinImage = object
	data: seq[seq[bool]]
	infinity: bool # color of the pixel at infinity. true = #

proc get(img: InfinImage,x,y: int): bool =
	if x >= 0 and y >= 0 and x < img.data.len and y < img.data[0].len:
		return img.data[y][x]
	else:
		return img.infinity

proc enhance(img: InfinImage): InfinImage =
	result.data = @[]
	const infIndex: int = 511
	result.infinity = iea[img.infinity.int * infIndex] == '#'

	for y in -1..img.data.len:
		var tmp: seq[bool] = @[]
		for x in -1..img.data[0].len:
			var b: seq[bool] = @[
				img.get(x-1,y-1),
				img.get(x,  y-1),
				img.get(x+1,y-1),
				img.get(x-1,y),
				img.get(x,  y),
				img.get(x+1,y),
				img.get(x-1,y+1),
				img.get(x,  y+1),
				img.get(x+1,y+1)
			]
			var bs: int = b.map(s => s.int).foldl(a & ($b),"").parseBinInt
			tmp.add(iea[bs] == '#')
		result.data.add(tmp)


var iimg1 = InfinImage(data: idata, infinity: false)
var iimg2 = InfinImage(data: idata, infinity: false)

for i in 1..2:
	iimg1 = enhance(iimg1)

for i in 1..50:
	iimg2 = enhance(iimg2)


# Count the lit pixels:
if iimg1.infinity:
	echo "Error: infinitly many pixels are lit"
else:
	var s = 0
	for i in iimg1.data:
		for j in i:
			if j: s += 1
	echo "Result: ", s

# Count the lit pixels:
if iimg2.infinity:
	echo "Error: infinitly many pixels are lit"
else:
	var s = 0
	for i in iimg2.data:
		for j in i:
			if j: s += 1
	echo "Result2: ", s