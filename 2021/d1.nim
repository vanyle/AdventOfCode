import strutils

let content = readFile("input1.txt")
let lines = strutils.splitLines(content)

var result = 0
var prev = 9999

for l in lines:
    var lc = l.strip()
    if len(lc) <= 0: continue
    let i: int = parseInt(lc)
    if i > prev:
        result += 1
    prev = i
echo result