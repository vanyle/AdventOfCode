import strutils, sequtils

var s = readFile("input7.txt").split(",").map(parseInt)

proc moveCost(pos: int, crabPos: seq[int]): int =
    return crabPos.map(
        proc(i:int):int = (let d = abs(i-pos); return d*(d+1) div 2)
    ).foldl(a+b)

let min_pos = min(s)
let max_pos = max(s)

var min_cost = moveCost(min_pos,s)

for i in min_pos+1..max_pos:
    let c = moveCost(i,s)
    if c < min_cost:
        min_cost = c

echo "Result: ",min_cost