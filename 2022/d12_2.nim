import astar, strutils, sequtils, sugar, hashes

let grid = readFile("input12.txt").strip().splitLines().map((x) => x.items.toSeq)
var goal: (int,int)

for y in 0..<grid.len:
    for x in 0..<grid[y].len:
        if grid[y][x] == 'E':
            goal = (x,y)


proc elevation( grid: seq[seq[char]], point: (int,int) ): int {.inline.} =
    if point[1] >= 0 and point[1] < grid.len and
        point[0] >= 0 and point[0] < grid[point[1]].len:
        if grid[point[1]][point[0]] == 'E':
            return 25
        if grid[point[1]][point[0]] == 'S':
            return 0
        return grid[point[1]][point[0]].int - 'a'.int
    else: return -1

iterator neighbors*( grid: seq[seq[char]], point: (int,int)): (int,int) =
    ## An iterator that yields the neighbors of a given point
    let curr = elevation(grid, (point[0],point[1]))
    var val = -1

    val = elevation( grid, (point[0] + 1, point[1]) )
    if val != -1 and val <= curr+1:
        yield (point[0] + 1, point[1])

    val = elevation( grid, (point[0] - 1, point[1]) )
    if val != -1 and val <= curr+1:
        yield (point[0] - 1, point[1])

    val = elevation( grid, (point[0], point[1] + 1) )
    if val != -1 and val <= curr+1:
        yield (point[0], point[1] + 1)

    val = elevation( grid, (point[0], point[1] - 1) )
    if val != -1 and val <= curr+1:
        yield (point[0], point[1] - 1)

proc cost*(grid: seq[seq[char]], a, b: (int,int)): float = 1
proc heuristic*( grid: seq[seq[char]], node, goal: (int,int)): float =
    return (abs(node[0] - goal[0]) + abs(node[1] - goal[1])).float


var bestStepCount = grid.len * grid[0].len

# Performance is bad. A better approach would be to go from E to
# other places and stop at the first 'a' found.
# However, computers are fast, so for this grid size this does not matter.
for y in 0..<grid.len:
    for x in 0..<grid[y].len:
        if grid[y][x] == 'a':
            var start = (x,y)

            var stepCount = 0
            for point in path[seq[seq[char]], (int,int), float](grid, start, goal):
                inc stepCount
            if stepCount == 0: continue

            if stepCount - 1 < bestStepCount:
                bestStepCount = stepCount - 1 

echo bestStepCount