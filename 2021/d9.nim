import strutils

let lines = readFile("input9.txt").splitLines
var heightmap: seq[seq[int]] = @[]

for l in lines:
    heightmap.add(@[])
    for i in l:
        heightmap[heightmap.len - 1].add(i.int - '0'.int)


template yieldIfExists(heightmap: seq[seq[int]] ,x: int, y: int) =
    if x >= 0 and y >= 0 and x < heightmap.len and y < heightmap[x].len:
        yield (x,y)

iterator neighbours(heightmap: seq[seq[int]] ,x: int, y: int): tuple[x,y: int] =
    yieldIfExists(heightmap,x+1,y)
    yieldIfExists(heightmap,x-1,y)
    yieldIfExists(heightmap,x,y+1)
    yieldIfExists(heightmap,x,y-1)

var riskSum = 0

for i in 0..<heightmap.len:
    for j in 0..<heightmap[i].len:
        var isLow: bool = true
        for n in neighbours(heightmap,i,j):
            if heightmap[n.x][n.y] <= heightmap[i][j]:
                isLow = false
                break
        if isLow:
            riskSum += 1 + heightmap[i][j]

echo riskSum