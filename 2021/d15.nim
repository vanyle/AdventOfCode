#? replace(sub = "\t", by = "  ")
import strutils, tables, astar

let lines = readFile("input15.txt").splitLines
var numbers: seq[seq[int]] = @[]

for i in lines:
	var tmp: seq[int] = @[]
	for j in i:
		tmp.add(($j).parseInt)
	numbers.add(tmp)

var goalx = numbers.len-1
var goaly = numbers[goalx].len-1


## Using astar

type
    Grid = seq[seq[int]]
        ## A matrix of nodes. Each cell is the cost of moving to that node

    Point = tuple[x, y: int]
        ## A point within that grid

template yieldIfExists( grid: Grid, point: Point ) =
    ## Checks if a point exists within a grid, then calls yield it if it does
    let exists =
        point.y >= 0 and point.y < grid.len and
        point.x >= 0 and point.x < grid[point.y].len
    if exists:
        yield point

iterator neighbors*( grid: Grid, point: Point ): Point =
    ## An iterator that yields the neighbors of a given point
    yieldIfExists( grid, (x: point.x - 1, y: point.y) )
    yieldIfExists( grid, (x: point.x + 1, y: point.y) )
    yieldIfExists( grid, (x: point.x, y: point.y - 1) )
    yieldIfExists( grid, (x: point.x, y: point.y + 1) )

proc cost*(grid: Grid, a, b: Point): float =
    ## Returns the cost of moving from point `a` to point `b`
    float(grid[b.x][b.y])

proc heuristic*( grid: Grid, node, goal: Point ): float =
    ## Returns the priority of inspecting the given node
    return (abs(node.x - goal.x) + abs(node.y - goal.y)).float

let start: Point = (x: 0,y: 0)
let goal: Point = (x: goalx, y: goaly)
var res: seq[Point] = @[]

for point in path[seq[seq[int]], Point, float](numbers, start, goal):
    res.add(point)

var minRisk = 0
for i in 1..<res.len:
	minRisk += numbers[res[i].x][res[i].y]
echo "Result: ",minRisk
