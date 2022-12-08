import strutils, sugar, sequtils


let forest = readFile("input8.txt").strip().splitLines().map((x) => x.toSeq().map((y) => parseInt($y)))

proc isVisible(x: int, y: int): bool =
    # Check the 4 directions. We don't do any fancy optimizations.
    # We could exploit the fact that the not visible area is convex but we don't.
    let height = forest[y][x]
    var notVisibleFromDirection = false
    
    # left
    for i in 0..<x:
        if forest[y][i] >= height:
            notVisibleFromDirection = true
            break
    if not notVisibleFromDirection: return true
    notVisibleFromDirection = false

    # top
    for i in 0..<y:
        if forest[i][x] >= height:
            notVisibleFromDirection = true
            break
    if not notVisibleFromDirection: return true
    notVisibleFromDirection = false

    # right
    for i in countdown(forest[y].len - 1, x+1):
        if forest[y][i] >= height:
            notVisibleFromDirection = true
            break
    if not notVisibleFromDirection: return true
    notVisibleFromDirection = false

    # bottom
    for i in countdown(forest.len - 1, y+1):
        if forest[i][x] >= height:
            notVisibleFromDirection = true
            break
    if not notVisibleFromDirection: return true

    # A tree not visible from any of the 4 directions is invisible.
    return false


var visibleCounter = 0
for y in 0..<forest.len:
    for x in 0..<forest[y].len:
        if isVisible(x,y): inc visibleCounter

echo visibleCounter