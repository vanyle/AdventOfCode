import strutils, sugar, sequtils


let forest = readFile("input8.txt").strip().splitLines().map((x) => x.toSeq().map((y) => parseInt($y)))

proc scenicScore(x: int, y: int): int =
    # Check the 4 directions. We don't do any fancy optimizations.
    # We could exploit the fact that the not visible area is convex but we don't.
    let height = forest[y][x]
    var distance = 0
    result = 1
    
    # right
    for i in (x+1)..<forest[y].len:
        inc distance
        if forest[y][i] >= height:
            break
    result *= distance
    distance = 0

    # bottom
    for i in (y+1)..<forest.len:
        inc distance
        if forest[i][x] >= height:
            break
    result *= distance
    distance = 0

    # left
    for i in countdown(x-1, 0):
        inc distance
        if forest[y][i] >= height:
            break
    result *= distance
    distance = 0

    # top
    for i in countdown(y-1, 0):
        inc distance
        if forest[i][x] >= height:
            break
    result *= distance


var maxScenicScore = 0
for y in 0..<forest.len:
    for x in 0..<forest[y].len:
        let ss = scenicScore(x,y)
        if ss > maxScenicScore:
            maxScenicScore = ss

echo maxScenicScore