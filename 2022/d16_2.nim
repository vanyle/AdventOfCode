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
    # add 1 to the real distance to take into account the time
    # to open the destination valve.

# same as "valves" but only contains the valves with non-zero flow rate.
var compressedNetwork: Table[ValveName, (int, seq[(int, ValveName)])]
let interestingValvesPlusStart = interestingValves + [['A','A']].toHashSet

for v1 in interestingValvesPlusStart:
    compressedNetwork[v1] = (valves[v1][0], @[])

    for v2 in interestingValves:
        if v2 != v1:
            # Compute distance between v1 and v2.
            compressedNetwork[v1][1].add((dist(v1,v2), v2))



var opened = initHashSet[ValveName]()
var bestScore = 0
proc computeScore(
        time: int,
        currentScore: int,
        position1: ValveName,
        position2: ValveName,

        moveTimer1: int,
        moveTimer2: int,
    ): int =
    # computeScore is almost pure (opened, looking at you)
    if time <= 0:
        return currentScore
    
    if moveTimer1 > 0 and moveTimer2 > 0:
        return computeScore(
            time - 1, currentScore, position1, position2,
            moveTimer1 - 1,
            moveTimer2 - 1)
    var futureScore = currentScore
    # After moving somewhere, the action you will take will always
    # be to open that valve, so might as well compute that right now.
    # Handle the actions first and compute the time changes when everybody
    # is moving.

    if futureScore > bestScore:
        echo "Best: ", futureScore
        bestScore = futureScore

    if moveTimer1 == 0:
        var found = false
        for (dist, dest) in compressedNetwork[position1][1]:
            if dist < time and dest notin opened:
                found = true
                opened.incl(dest)
                futureScore = max(futureScore, computeScore(
                    time,
                    currentScore + (time - dist) * compressedNetwork[dest][0],
                    dest,
                    position2,
                    dist,
                    moveTimer2
                ))
                opened.excl(dest)
        if found: 
            return futureScore

    if moveTimer2 == 0:
        for (dist, dest) in compressedNetwork[position2][1]:
            if dist < time and dest notin opened:
                opened.incl(dest)
                futureScore = max(futureScore, computeScore(
                    time,
                    currentScore + (time - dist) * compressedNetwork[dest][0],
                    position1,
                    dest,
                    moveTimer1,
                    dist,
                ))
                opened.excl(dest)

    return futureScore


echo compressedNetwork
echo "Network compressed. Computing score."
echo computeScore(26, 0, ['A','A'], ['A','A'], 0, 0)
