import strutils

let lines = readFile("input2.txt").splitLines

var depth = 0
var fwd = 0

for l in lines:
    var t = l.split(" ")
    var amount = parseInt(t[1])

    if t[0] == "forward":
        fwd += amount
    elif t[0] == "down":
        depth += amount
    elif t[0] == "up":
        depth -= amount

echo depth * fwd