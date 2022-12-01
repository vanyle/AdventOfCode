import sequtils, sugar, strutils, algorithm

proc sum(x: seq[int]): int = x.foldl(a + b, 0)
var lines = readFile("input1.txt").split("\n\n")
    .map((x) => x.strip().splitLines().map((y) => parseInt(y))).map((x) => sum(x))
lines.sort(cmp, Descending)

echo sum(lines[0..2])