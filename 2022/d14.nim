import strutils, sequtils, sugar, tables

let lines = readFile("input14.txt").strip().split("\n").map((x) => x.split(" -> ").map((y) => y.split(",").map(parseInt)))

var grid: Table[(int,int),int]

for line in lines:
    for idx in 1..<line.len:
        let fromDot = line[idx-1]
        let toDot = line[idx]
        for i in min(fromDot[0],toDot[0])..max(fromDot[0],toDot[0]):
            for j in min(fromDot[1], toDot[1])..max(fromDot[1], toDot[1]):
                grid[(i, j)] = 2
var (maxx, maxy) = (500, 0)
var (minx, miny) = (500, 0)
for p, _ in grid:
    maxx = max(maxx, p[0])
    maxy = max(maxy, p[1])
    minx = min(minx, p[0])
    miny = min(miny, p[1])

# used to avoid quadratic complexity when computing how the sand falls
var sandPath: seq[(int,int)] = @[(500,0)]

iterator neighbours(x,y: int): (int,int) =
    yield (x, y + 1)
    yield (x - 1, y + 1)
    yield (x + 1, y + 1)

proc computeSandPath(cave: var Table[(int,int), int], stopHeuristic: proc(): bool, isFilled: proc(p:(int,int)): bool) =
    # BFS sorta, but sandy
    while stopHeuristic():
        var ne: seq[(int,int)] = @[]
        for n in neighbours(sandPath[sandPath.len-1][0],sandPath[sandPath.len-1][1]):
            if isFilled(n):
                ne.add(n)
        if ne.len > 0:
            sandPath.add(ne[0])
        else:
            let s = sandPath.pop()
            cave[s] = 1

proc isFilled1(p: (int,int)): bool = p notin grid
proc isFilled2(p: (int,int)): bool = p notin grid and p[1] != maxy + 2
proc isInside(x, y: int): bool = return minx <= x and x <= maxx and miny <= y and y <= maxy            

computeSandPath(grid, proc(): bool = isInside(sandPath[sandPath.len-1][0],sandPath[sandPath.len-1][1]), isFilled1)

var result = 0
for pos, val in grid:
    if val == 1: inc result 
echo "Part1: ",result

result = 0
computeSandPath(grid, proc(): bool = sandPath.len != 0, isFilled2)
for pos, val in grid:
    if val == 1: inc result
echo "Part2: ",result