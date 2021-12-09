import strutils, algorithm, sets

let lines = readFile("input9.txt").splitLines
var heightmap: seq[seq[int]] = @[]

for l in lines:
    heightmap.add(@[])
    for i in l:
        heightmap[heightmap.len - 1].add(i.int - '0'.int)


template yieldIfExists(heightmap: seq[seq[int]] ,x: int, y: int) =
    if x >= 0 and y >= 0 and x < heightmap.len and y < heightmap[x].len and heightmap[x][y] != 9:
        yield (x,y)

iterator neighbours(heightmap: seq[seq[int]] ,x: int, y: int): tuple[x,y: int] =
    yieldIfExists(heightmap,x+1,y)
    yieldIfExists(heightmap,x-1,y)
    yieldIfExists(heightmap,x,y+1)
    yieldIfExists(heightmap,x,y-1)

proc floodFill(heightmap: var seq[seq[int]], x: int, y: int): int =
    var visited = initHashSet[tuple[x,y: int]]()
    visited.incl((x,y))
    var visitStack: seq[tuple[x,y: int]] = @[(x,y)]

    while visitStack.len > 0:
        let pt = visitStack.pop()
        for n in heightmap.neighbours(pt.x,pt.y):
            if n notin visited:
                heightmap[n.x][n.y] = 9 # delete thing
                visitStack.add(n)
                visited.incl(n)

    return visited.len

# Fill everything with 9s.
var basinSizes: seq[int] = @[]
basinSizes.add(heightmap.floodFill(0,0))

for _ in 1..2: # Perform 2 passes.
    for i in 0..<heightmap.len:
        for j in 0..<heightmap[i].len:
            if heightmap[i][j] != 9:
                basinSizes.add(heightmap.floodFill(i,j))

basinSizes.sort(Descending)

echo basinSizes[0]*basinSizes[1]*basinSizes[2]