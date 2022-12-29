import tables, strutils, sets, math, deques

let input = readFile("input24.txt").strip().splitLines
let width = input[0].len - 2
let height = input.len - 2

var blizz: Table[(int,int),char]
var blizzTypes = ['^','>','<','v'].toHashSet

for y in 0..<input.len:
    for x in 0..<input[y].len:
        if input[y][x] in blizzTypes:
            blizz[(x-1,y-1)] = input[y][x]


proc canMove(x,y,t: int): bool =
    # entrance and exit can always be reached, no matter the time
    if x == 0 and y == -1: return true
    if x == width-1 and y == height: return true
    # the walls are always unreachable.
    if x < 0: return false
    if x >= width: return false
    if y < 0: return false
    if y >= height: return false
    # Movement in the rest of the grid depends on the future position
    # of the blizzards, which we can quickly compute.
    for px in 0..<width:
        if (px, y) in blizz:
             # check where that blizzard will be in the future:
            let c = blizz[(px, y)]
            if c == '<' or c == '>':
                let cmod = if c == '<': -1 else: 1
                let futureX = euclMod(px + t * cmod, width)
                if futureX == x: return false 

    for py in 0..<height:
        if (x, py) in blizz:
            let c = blizz[(x, py)]
            if c == 'v' or c == '^':
                let cmod = if c == '^': -1 else: 1
                let futureY = euclMod(py + t * cmod, height)
                if futureY == y: return false 
    return true

proc neighbours(x,y,t: int): seq[(int,int,int)] =
    if canMove(x,y,t+1): result.add((x,y,t+1))
    if canMove(x+1,y,t+1): result.add((x+1,y,t+1))
    if canMove(x,y+1,t+1): result.add((x,y+1,t+1))
    
    if canMove(x-1,y,t+1): result.add((x-1,y,t+1))
    if canMove(x,y-1,t+1): result.add((x,y-1,t+1))

proc pathFind(sx,sy,st: int, gx,gy: int): int =
    var front = @[(sx,sy,st)].toDeque 
    var reachable: HashSet[(int,int,int)]

    while front.len > 0:
        var current = front.popFirst()
        var neighboursList = neighbours(current[0],current[1],current[2])
        for n in neighboursList:
            if n notin reachable:
                reachable.incl(n)
                front.addLast(n)
            if n[0] == gx and n[1] == gy:
                # Goal is reached!
                return n[2]

    return st - 1 # unreachable.

# Trip 1: goal -> start
var time1 = pathFind(0, -1, 0, width - 1, height)
echo "Part 1: ",time1

var time2 = pathFind(width - 1, height, time1, 0, -1)
echo "Time for goal -> start: ",time2
var time3 = pathFind(0, -1, time2, width - 1, height)
echo "Part 2: ",time3