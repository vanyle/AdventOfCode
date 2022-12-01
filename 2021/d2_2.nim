import strutils

let lines = readFile("input2.txt").splitLines

var depth = 0
var fwd = 0
var aim = 0

for l in lines:
    var t = l.split(" ")
    var amount = parseInt(t[1])

    if t[0] == "forward":
        fwd += amount
        depth += aim * amount
    elif t[0] == "down":
        aim += amount
    elif t[0] == "up":
        aim -= amount

echo depth * fwd