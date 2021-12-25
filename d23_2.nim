#? replace(sub = "\t", by = "  ")
import tables, sets, strutils, deques, astar

# Data is a point in the state graph
type Data = tuple[map: Table[(int,int), char], amphipodPoints: HashSet[(int,int)]]
type Move = tuple[startPoint, endPoint: (int,int), cost: int, settled: bool]

const energyMap = {'A': 1, 'B': 10, 'C': 100, 'D': 1000}.toTable
const targetX = {'A': 3, 'B': 5, 'C': 7, 'D': 9}.toTable


proc toData(lines: seq[string]): Data =
	for y, line in lines:
		for x, character in line:
			result.map[(x, y)] = character
			if character in {'A' .. 'D'}:
				if y == lines.high - 1 and x == targetX[character]:
					continue
				result.amphipodPoints.incl((x, y))

let goalStr = """
#############
#...........#
###A#B#C#D###
	#A#B#C#D#
	#A#B#C#D#
	#A#B#C#D#
	#########""".splitLines

var goal: Data = goalStr.toData
goal.amphipodPoints.clear() # in the goal state, everybody is in the correct place


iterator moves(data: Data, startPoint: (int,int)): Move =
	var dfs = @[(startPoint, 0)].toDeque()
	var visited = [startPoint].toHashSet()

	let amphipodKind = data.map[startPoint]

	while dfs.len > 0:
		let (point, steps) = dfs.popFirst()
		visited.incl(point)

		for step in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
			let endPt = (point[0] + step[0], point[1] + step[1])
			let newSteps = steps + 1

			if endPt in visited:
				continue
			if data.map[endPt] != '.':
				continue
			# could be optimized faster dfs here (don't attempt to explore dead branches)
			dfs.addLast((endPt, newSteps))

			if (endPt in [(3,1),(5,1),(7,1),(9,1)]) or (endPt[0] != targetX[amphipodKind] and endPt[1] > 1):
				continue
			if endPt[1] == 1 and startPoint[1] != 1:
				yield ((startPoint, endPt, newSteps * energyMap[amphipodKind], false))

			if endPt[1] == 2:
				var onlySame = true
				var extraY = 0
				var y = endPt[1]

				while true:
					y += 1
					let current = data.map[(endPt[0], y)]
					if current == '.':
						extraY += 1
						continue
					if current == '#':
						break
					if current != amphipodKind:
						onlySame = false
						break

				if onlySame:
					let newEndpoint: (int,int) = (endPt[0], endPt[1] + extraY)
					yield ((startPoint, newEndpoint, (newSteps + extraY) * energyMap[amphipodKind], true))

iterator neighbors_cost*(grid: bool,data: Data): (int,Data) =
	for startPoint in data.amphipodPoints:
		for m in data.moves(startPoint):
			var newData = data.deepCopy()
			let (startPoint, endPoint, cost, settled) = m
			let amphipodKind = newData.map[startPoint]
			newData.amphipodPoints.excl(startPoint)
			newData.map[endPoint] = amphipodKind

			if not settled:
				newData.amphipodPoints.incl(endPoint)

			newData.map[startPoint] = '.'
			yield (cost,newData)

iterator neighbors*(grid: bool, data: Data): Data =
	for _,n in neighbors_cost(grid, data):
		yield n

proc cost*(grid: bool, a, b: Data): int =
		# No cache because they take too much space in memory
		# if (a,b) in costCache: return costCache[(a,b)]
		
		for c,n in neighbors_cost(false, a):
			if n == b: return c
				# costCache[(a,n)] = c
		# if (a,b) in costCache: return costCache[(a,b)]
		return 9999999

proc heuristic*( grid: bool, node, goal: Data ): int =
	# Move well placed amphipod = closer to the goal
	return 9999 - node.amphipodPoints.len

var lines = readFile("input23.txt").strip.splitLines()
lines = lines[0..2] & @["  #D#C#B#A#", "  #D#B#A#C#"] & lines[3..<lines.len]
var data: Data = lines.toData

var res: seq[Data] = @[]
for pt in path[bool, Data, int](false, data, goal):
		res.add(pt)

# Compute cost of path
var c = 0
for i in 1..<res.len:
	c += cost(false, res[i-1], res[i])
echo "Result: ",c