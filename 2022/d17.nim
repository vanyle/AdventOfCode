import strutils, sequtils, tables

let jetpatterns = readFile("input17.txt").strip()

let rockTypes = @[
    @[
        "  xxxx "
    ],
    @[
        "   x   ",
        "  xxx  ",
        "   x   "
    ],
    @[
        "    x  ",
        "    x  ",
        "  xxx  "
    ],
    @[
        "  x    ",
        "  x    ",
        "  x    ",
        "  x    "
    ],
    @[
        "  xx   ",
        "  xx   "
    ]
]

proc getBoard(board: seq[array[7, char]], x,y: int64): char =
    if y < 0: return '-'
    if x < 0 or x >= board[y].len: return '|'
    if y >= board.len: return ' '
    return board[y][x]

proc collide(pattern: seq[array[7,char]], posX: int64, posY: int64, board: seq[array[7, char]]): bool =
    for py in 0..<pattern.len:
        # flip the pattern when computing the thing: y <- flip(py)
        let y = pattern.len - py - 1 
        for x in 0..<pattern[py].len:
            let c = pattern.getBoard(x, py)
            let c2 = board.getBoard(x + posX, y + posY)
            if c == 'x' and c2 != ' ':
                return true
    return false


proc computeResult(maxRock: int64): int64 =

    var board: seq[array[7, char]] = @[] # [y][x] y++ => up
    var rockCount: int64 = 0
    var timeStep: int64 = 0
    var rockSettled = true
    var floorLevel: int64 = -1 # used to know where to spawn the rock.

    proc setBoard(board: var seq[array[7, char]], x,y: int64, val: char) =
        # Set a thing on the board, no matter y. Will expand the board as needed.
        # 0 <= x < 7, 0 < y.
        while y >= board.len:
            board.add([' ',' ',' ',' ',' ',' ',' '])
        if val != ' ':
            floorLevel = max(floorLevel, y)
        board[y][x] = val

    proc merge(pattern: seq[array[7,char]], posX: int64, posY: int64, board: var seq[array[7, char]]) =
        for py in 0..<pattern.len:
            # flip the pattern when computing the thing: y <- flip(py)
            let y = pattern.len - py - 1 
            for x in 0..<pattern[py].len:
                let c = pattern.getBoard(x, py)
                let c2 = board.getBoard(x + posX, y + posY)
                if c == 'x' and c2 == ' ':
                    board.setBoard(x + posX, y + posY, c)

    proc toArray(s: string): array[7, char] =
        for i in 0..<s.len: result[i] = s[i]

    var rockPositionY: int64 = 0
    var rockPositionX: int64 = 0
    var currentRock: seq[array[7,char]]
    var periodChecker: Table[(int64,int64), seq[(int64,int64)]]

    var floorCompensation: int64 # magic number to add to the response.
    var leapPerformed = false

    while rockCount <= maxRock:
        if rockSettled:
            # spawn a new rock
            currentRock = rockTypes[rockCount mod rockTypes.len].map(toArray)
            inc rockCount
            let p1 = rockCount mod rockTypes.len
            let p2 = timeStep mod jetpatterns.len
            if not leapPerformed:
                if (p1,p2) in periodChecker:
                    periodChecker[(p1,p2)].add((floorLevel+1, rockCount))

                    if periodChecker[(p1,p2)].len > 4:
                        # that's a pattern !
                        let e1 = periodChecker[(p1,p2)][2][0] - periodChecker[(p1,p2)][1][0]
                        let e2 = periodChecker[(p1,p2)][3][0] - periodChecker[(p1,p2)][2][0]
                        let e3 = periodChecker[(p1,p2)][4][0] - periodChecker[(p1,p2)][3][0]

                        let t1 = periodChecker[(p1,p2)][2][1] - periodChecker[(p1,p2)][1][1]
                        let t2 = periodChecker[(p1,p2)][3][1] - periodChecker[(p1,p2)][2][1]
                        let t3 = periodChecker[(p1,p2)][4][1] - periodChecker[(p1,p2)][3][1]

                        if e1 == e2 and e2 == e3 and t1 == t2 and t2 == t3:
                            let remainingRocks = maxRock - rockCount
                            # We perform a simulation leap in time of size t1 * k
                            let k = remainingRocks div t1
                            floorCompensation = k * e1
                            let rocksToSimulate = remainingRocks - k * t1
                            rockCount = maxRock - rocksToSimulate
                            leapPerformed = true

                else:
                    periodChecker[(p1,p2)] = @[(floorLevel+1, rockCount)]
            #echo "Period status: ", p1,p2
            rockSettled = false
            rockPositionY = floorLevel + 4.int64
            rockPositionX = 0 

        let jet = jetpatterns[timeStep mod jetpatterns.len]
        if jet == '>':
            inc rockPositionX
            if currentRock.collide(rockPositionX, rockPositionY, board):
                dec rockPositionX
        elif jet == '<':
            dec rockPositionX
            if currentRock.collide(rockPositionX, rockPositionY, board):
                inc rockPositionX

        dec rockPositionY
        if currentRock.collide(rockPositionX, rockPositionY, board):
            inc rockPositionY
            # rock comes to rest.
            currentRock.merge(rockPositionX, rockPositionY, board)
            rockSettled = true

        inc timeStep
    return floorLevel + 1 + floorCompensation


echo "Part 1 = ",computeResult(2022)
echo "Part 2 = ",computeResult(1_000_000_000_000)
