import strutils, sugar, sequtils, tables
let stable = {"A": 1,"X": 1, "B": 2, "Y": 2, "C": 3, "Z": 3}.toTable


proc setScore(score: var int, moveLeft: int, moveRight: int) =
    if moveLeft == moveRight:
        score += 3
        return
    if moveLeft == 1 and moveRight == 3: return
    if moveLeft == 2 and moveRight == 1: return
    if moveLeft == 3 and moveRight == 2: return
    score += 6


let lines = readFile("input2.txt").strip().splitLines().map((x) => x.split(" "))

var score = 0
for l in lines:
    let m0 = stable[l[0]]
    let m1 = stable[l[1]]
    score += m1
    score.setScore(m0, m1)

echo score
