import strscans, strutils, sets, tables
import astar


let lines = readFile("input16.txt").strip.splitLines

type ValveName = array[2, char]
var valves: Table[ValveName, (int, seq[ValveName])]
var interestingValves: HashSet[ValveName]

proc `$`(n: ValveName): string = n[0] & n[1]

proc skipS(input: string, start: int): int =
    if input[start] == 's':
        return 1
    return 0

for line in lines:
    var valveName: string
    var flowRate: int
    var tunnelsStr: string
    discard scanf(line, "Valve $* has flow rate=$i; tunnel$[skipS] lead$[skipS] to valve$[skipS] $*", valveName, flowRate, tunnelsStr)
    var tunnels = tunnelsStr.split(", ")
    var name: ValveName = [valveName[0],valveName[1]]
    var connections: seq[ValveName] = @[]
    for i in tunnels:
        connections.add([i[0],i[1]])
    # optimization: sort the connections by flowrate.
    valves[name] = (flowRate, connections)
    if flowRate > 0:
        interestingValves.incl(name)

iterator neighbors*( grid: Table[ValveName, (int, seq[ValveName])], point: ValveName): ValveName =
    for v,k in grid[point][1]:
        yield k
proc cost*(grid: Table[ValveName, (int, seq[ValveName])], a, b: ValveName): int = 1
proc heuristic*( grid: Table[ValveName, (int, seq[ValveName])], node, goal: ValveName): int = 1
# a* might be overkill ...

proc dist(a,b: ValveName): int =
    result = 0
    for point in path[Table[ValveName, (int, seq[ValveName])], ValveName, int](valves, a, b):
        inc result
    dec result

# same as "valves" but only contains the valves with non-zero flow rate.
var compressedNetwork: Table[ValveName, (int, seq[(int, ValveName)])]
let interestingValvesPlusStart = interestingValves + [['A','A']].toHashSet

for v1 in interestingValvesPlusStart:
    compressedNetwork[v1] = (valves[v1][0], @[])

    for v2 in interestingValves:
        if v2 != v1:
            # Compute distance between v1 and v2.
            compressedNetwork[v1][1].add((dist(v1,v2), v2))


var bestScore = 0

proc computeScore(
        time: int,
        currentScore: int,
        position: ValveName,
        opened: HashSet[ValveName]
    ): int =
    # computeScore is pure.
    if time >= 30:
        return currentScore
    
    var futureScore = currentScore

    # Compute score based on the actions possible and return the max.
    # If the current position is not opened, opening the valve is *always* the best option,
    # because otherwise, why go there? (except for the special case of the starting position of course.)

    if currentScore > bestScore:
        echo "Best:", bestScore
        bestScore = currentScore

    if position != ['A','A'] and position notin opened:
        # echo "Opening!"
        var newOpened = opened
        newOpened.incl(position)
        futureScore += compressedNetwork[position][0] * (30 - time - 1)

        futureScore = computeScore(time + 1, futureScore, position, newOpened)
    else:
        for neighbours in compressedNetwork[position][1]:
            if neighbours[1] != position and neighbours[1] notin opened:
                # echo "Trying: ",position," -> ",neighbours[1], " - ",time, " - ",newScore
                futureScore = max(
                    futureScore, computeScore(time + neighbours[0], currentScore, neighbours[1], opened) 
                )

    return futureScore

echo compressedNetwork
echo "Network compressed. Computing score."

echo computeScore(0, 0, ['A','A'], initHashSet[ValveName]())
