import sequtils, sugar, strutils

let lines = readFile("input1.txt").split("\n\n")
    .map((x) => x.strip().splitLines().map((y) => parseInt(y)))

proc sum(x: seq[int]): int = x.foldl(a + b, 0)
echo max(lines.map((x) => sum(x)))