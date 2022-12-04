import strutils, sugar, sequtils

let lines = readFile("input4.txt").strip().splitLines().map(
    (x) => x.split(",").map((y) => y.split("-").map(parseInt))
)
var overlapCounter = 0

for l in lines:
    let range1 = l[0]
    let range2 = l[1]
    if range1[0] <= range2[0] and range2[1] <= range1[1]:
        inc overlapCounter
    elif range2[0] <= range1[0] and range1[1] <= range2[1]:
        inc overlapCounter

echo overlapCounter