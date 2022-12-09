import strutils, sugar, sequtils, sets

let lines = readFile("input9.txt").strip().splitLines().map((x) => x.split(" ",1))

let instructions = lines.map((x) => (x[0], x[1].parseInt))

var visitedPositions: HashSet[(int,int)]
var headPos = (0,0)
var tailPos = (0,0)
visitedPositions.incl(tailPos)

proc isFar*(a,b: (int,int)): bool = abs(a[0] - b[0]) > 1 or abs(a[1] - b[1]) > 1

for move in instructions:
    let mcount = move[1]
    for i in 0..<mcount:
        let previous = headPos
        if move[0] == "U": dec headPos[1]
        if move[0] == "D": inc headPos[1]
        if move[0] == "R": inc headPos[0]
        if move[0] == "L": dec headPos[0]
        if isFar(headPos, tailPos):
            tailPos = previous
            visitedPositions.incl(tailPos)

echo visitedPositions.len