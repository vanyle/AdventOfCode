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

for l in lines:
    let llen = l.len div 2
    let w1 = l[0..<llen].toSet()
    let w2 = l[llen..<l.len].toSet()
    # Find intersection between w1 and w2
    let inter = w1.intersection(w2)
    var c: char
    for i in inter:
        c = i
        break
    score += charScore(c)

echo score
