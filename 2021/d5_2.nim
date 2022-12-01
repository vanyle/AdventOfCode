import strutils, sequtils, tables, math

type pos = tuple[x: int,y: int]

let lines = readFile("input5.txt").splitLines


# coordLines is a list of lists of 4 elements: x1,y1,x2,y2
var coordsLines = lines.map(
    proc (s: string): seq[int] =
        var v = s.split(" -> ")
        var startp = v[0].split(",").map(parseInt)
        var endp = v[1].split(",").map(parseInt)
        return startp & endp
)



var intersections = initCountTable[pos]()

for line in coordsLines:
    # add the line positions to the count table
    let diffx = sgn(line[2] - line[0])
    let diffy = sgn(line[3] - line[1])
    var xpos = line[0]
    var ypos = line[1]
    # Highly inefficient but it works
    while xpos != line[2] or ypos != line[3]:
        intersections.inc (xpos,ypos)
        xpos += diffx
        ypos += diffy
    intersections.inc (xpos,ypos)

var r = 0
for k,v in intersections.mpairs():
    if v >= 2: r += 1

echo "Result: ",r