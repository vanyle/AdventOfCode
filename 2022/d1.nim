import sequtils, sugar, strutils

proc sum(x: seq[int]): int = x.foldl(a + b, 0)
echo readFile("input1.txt").split("\n\n")
    .map((x) => x.strip().splitLines().map(parseInt))
    .map(sum).max()
