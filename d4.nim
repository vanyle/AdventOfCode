import strutils, sequtils

let lines = readFile("input4.txt").splitLines

let bingoSeq = lines[0].split(",").map(parseInt)

var bingoBoards: seq[seq[int]] = @[]

var lidx = 2

while lidx+1 < lines.len:
    var tmpSeq: seq[int] = @[]
    for i in 1..5:
        let l = lines[lidx].split(" ").filter(proc (x: string): bool= x.len > 0).map(parseInt)
        tmpSeq &= l
        lidx += 1
    assert tmpSeq.len == 5 * 5 # Check that a full bingo board was parsed.
    bingoBoards.add(tmpSeq)
    lidx += 1

proc isBingo(b: seq[bool]): bool =
    ## Check if there are trues in a line/col in the 5x5 list provided.
    # Lines:
    for i in 0..4:
        var andSum = true
        for j in 0..4:
            andSum = andSum and b[i * 5 + j] 
        if andSum: return true
    # Cols:
    for i in 0..4:
        var andSum = true
        for j in 0..4:
            andSum = andSum and b[j * 5 + i] 
        if andSum: return true
    return false

proc computeWin(board: seq[int], bingoSeq: seq[int], isScore: bool = false): int =
    ## Given a board and a sequence of number, return at what index a bingo occured.
    ## Return bingoSeq.len if a win never occurs
    var matches: seq[bool] = board.map(proc (x:int): bool = false)
    var winningI = 0
    block outerloop:
        for i,v in bingoSeq.pairs():
            for j,nbr in board.pairs():
                if nbr == v:
                    matches[j] = true
                        
                    if matches.isBingo():
                        if not isScore: return i
                        winningI = i
                        break outerloop
    if isScore:
        var score = 0
        for j,nbr in board.pairs():
            if not matches[j]: score += nbr
        score *= bingoSeq[winningI]
        return score
    return bingoSeq.len


var minIndex = 0
var minVal = computeWin(bingoBoards[0], bingoSeq)
for i in 1..<bingoBoards.len:
    var winIndex = computeWin(bingoBoards[i], bingoSeq)
    if winIndex < minVal:
        minVal = winIndex
        minIndex = i

echo computeWin(bingoBoards[minIndex],bingoSeq,true)