#? replace(sub = "\t", by = "  ")
import strutils, tables, astar

let lines = readFile("input15.txt").splitLines
var numbers: seq[seq[int]] = @[]

for i in lines:
	var tmp: seq[int] = @[]
	for j in i:
		tmp.add(($j).parseInt)
	numbers.add(tmp)

var goalx = numbers.len*5-1
var goaly = numbers[0].len*5-1


# Using astar, too lazy to implement it so using the "astar" library

type
    Grid = seq[seq[int]]
    Point = tuple[x, y: int]

proc val(p: Point): int =
	let x = p.x mod numbers.len
	let y = p.y mod numbers[x].len

	let bx = p.x div numbers.len
	let by = p.y div numbers[x].len

	return (numbers[x][y] + bx + by - 1) mod 9 + 1


template yieldIfExists( grid: Grid, point: Point ) =
    let exists =
        point.y >= 0 and point.y < grid.len*5 and
        point.x >= 0 and point.x < grid[0].len*5
    if exists:
        yield point

iterator neighbors*( grid: Grid, point: Point ): Point =
    yieldIfExists( grid, (x: point.x - 1, y: point.y) )
    yieldIfExists( grid, (x: point.x + 1, y: point.y) )
    yieldIfExists( grid, (x: point.x, y: point.y - 1) )
    yieldIfExists( grid, (x: point.x, y: point.y + 1) )

proc cost*(grid: Grid, a, b: Point): float = float(val(b))

proc heuristic*( grid: Grid, node, goal: Point ): float =
    return (abs(node.x - goal.x) + abs(node.y - goal.y)).float

let start: Point = (x: 0,y: 0)
let goal: Point = (x: goalx, y: goaly)
var res: seq[Point] = @[]

for point in path[seq[seq[int]], Point, float](numbers, start, goal):
    res.add(point)

var minRisk = 0
for i in 1..<res.len:
	minRisk += val(res[i])
echo "Result: ",minRisk
