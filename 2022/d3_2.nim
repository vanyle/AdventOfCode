import strutils, sets

let lines = readFile("input3.txt").strip().splitLines()

proc charScore(c: char): int =
    if c >= 'a' and c <= 'z':
        return (c.int - 'a'.int + 1)
    else:
        return (c.int - 'A'.int + 27)

proc toSet(s: string): HashSet[char] = 
    for i in s:
        result.incl(i)

var score = 0

for i in 0..<(lines.len div 3):
    let l1 = lines[i*3 + 0].toSet()
    let l2 = lines[i*3 + 1].toSet()
    let l3 = lines[i*3 + 2].toSet()
    # Find intersection between w1 and w2
    let inter = l1.intersection(l2).intersection(l3)
    var c: char
    for i in inter:
        c = i
        break
    score += charScore(c)

echo score
