import strutils, sugar, sequtils, tables
let stable = {"A": 1,"X": 1, "B": 2, "Y": 2, "C": 3, "Z": 3}.toTable
# X = lose, Y = draw, Z = win

proc getWinner(against: int): int =
    if against == 1: return 2 # paper beats rock
    if against == 2: return 3 # scissor beats paper
    return 1 # rock beats scissor
proc getLoser(against: int): int =
    if against == 2: return 1
    if against == 3: return 2
    return 3

proc setScore(score: var int, moveLeft: int, outcome: int) =
    if outcome == 2: # draw: moveLeft == moveRight
        score += moveLeft
    elif outcome == 3: # win.
        score += getWinner(moveLeft)
    else: # lose.
        score += getLoser(moveLeft)

let lines = readFile("input2.txt").strip().splitLines().map((x) => x.split(" "))

var score = 0
for l in lines:
    let m0 = stable[l[0]]
    let m1 = stable[l[1]]
    score += (m1-1) * 3
    score.setScore(m0, m1)

echo score
