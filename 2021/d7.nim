import strutils, sequtils, algorithm

# Compute median
var s = readFile("input7.txt").split(",").map(parseInt)
s.sort()

proc moveCost(pos: int, crabPos: seq[int]): int =
    return crabPos.map(proc(i:int):int = abs(i-pos)).foldl(a+b)

let v = s[s.len div 2]
echo "Result: ",moveCost(v,s)