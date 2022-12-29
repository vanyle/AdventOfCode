import strutils, tables, sets

let input = readFile("input23.txt").strip().splitLines
var elfTable: HashSet[(int,int)]
for y in 0..<input.len:
    for x in 0..<input[y].len:
        if input[y][x] == '#':
            elfTable.incl((x,y))

proc moveNS(elfx,elfy: int, elfTable: HashSet[(int,int)], elfMoveTransactions: var Table[(int,int),(int,int)], delta: int): bool =
    if (elfx-1, elfy+delta) notin elfTable and (elfx, elfy+delta) notin elfTable and (elfx+1, elfy+delta) notin elfTable:
        elfMoveTransactions[(elfx,elfy)] = (elfx, elfy+delta)
        return true
    return false

proc moveWE(elfx,elfy: int, elfTable: HashSet[(int,int)], elfMoveTransactions: var Table[(int,int),(int,int)], delta: int): bool =
    if ((elfx+delta, elfy+1) notin elfTable) and ((elfx+delta, elfy) notin elfTable) and ((elfx+delta, elfy-1) notin elfTable):
        elfMoveTransactions[(elfx,elfy)] = (elfx+delta, elfy)
        return true
    return false

proc simulateRound(elfTable: var HashSet[(int,int)], rcount: int): bool =
    var processedElves: seq[(int,int)] = @[]
    for elf in elfTable:
        # Check if there are elfs nearby
        let (elfx,elfy) = elf

        if (elfx+1, elfy) in elfTable or
            (elfx-1, elfy) in elfTable or
            (elfx+1, elfy+1) in elfTable or
            (elfx, elfy+1) in elfTable or
            (elfx-1, elfy+1) in elfTable or
            (elfx+1, elfy-1) in elfTable or
            (elfx, elfy-1) in elfTable or
            (elfx-1, elfy-1) in elfTable:
            processedElves.add(elf)

    var elfMoveTransactions: Table[(int,int), (int,int)]
    let order = ['N','S','W','E']
    let rc = rcount mod order.len

    for elf in processedElves:
        let (elfx,elfy) = elf
        for i in rc..<rc+order.len:
            let action = order[i mod order.len]
            if action == 'N':
                if moveNS(elfx, elfy, elfTable, elfMoveTransactions, -1): break
            if action == 'S':
                if moveNS(elfx, elfy, elfTable, elfMoveTransactions,  1): break
            if action == 'W':
                if moveWE(elfx, elfy, elfTable, elfMoveTransactions, -1): break
            if action == 'E':
                if moveWE(elfx, elfy, elfTable, elfMoveTransactions,  1): break

    # Drop duplicated destination transactions
    var elfReverseTransaction: Table[(int,int), seq[(int,int)]]
    for elfStart, elfDest in elfMoveTransactions:
        if elfDest in elfReverseTransaction:
            elfReverseTransaction[elfDest].add(elfStart)
        else:
            elfReverseTransaction[elfDest] = @[elfStart]
    
    var moveCount = 0
    # Apply the transactions
    for elfStart, elfDest in elfMoveTransactions:
        if elfReverseTransaction[elfDest].len == 1:
            elfTable.excl(elfStart)
            elfTable.incl(elfDest)
            inc moveCount

    return moveCount > 0

proc draw(elfTable: HashSet[(int,int)]) =
    var xmax = 0
    var ymax = 0
    var xmin = 999999
    var ymin = 999999
    for elf in elfTable:
        xmax = max(elf[0], xmax)
        xmin = min(elf[0], xmin)
        ymax = max(elf[1], ymax)
        ymin = min(elf[1], ymin)

    for y in ymin..ymax:
        for x in xmin..xmax:
            if (x,y) in elfTable:
                stdout.write '#'
            else:
                stdout.write '.'
        stdout.write '\n'
    stdout.write '\n'


proc emptyTiles(elfTable: HashSet[(int,int)]): int =
    # Step 1: find bounds:
    var xmax = 0
    var ymax = 0
    var xmin = 999999
    var ymin = 999999
    for elf in elfTable:
        xmax = max(elf[0], xmax)
        xmin = min(elf[0], xmin)
        ymax = max(elf[1], ymax)
        ymin = min(elf[1], ymin)

    let totalArea = (ymax - ymin + 1) * (xmax - xmin + 1)
    return totalArea - elfTable.len


var workTable = elfTable

for i in 0..<10:
    discard simulateRound(workTable, i)

echo "Part 1: ",emptyTiles(workTable)

workTable = elfTable

var i = 0
while simulateRound(workTable, i):
    inc i
    if i mod 100 == 0:
        echo i," <= result "

# 1057

echo "Part 2: ",(i+1)