import strutils, sequtils

let lines = readFile("input1.txt").splitLines.map(parseInt)

var result = 0

var windowValue = lines[0] + lines[1] + lines[2]

for i in 3..<len(lines):
    var newWindowValue = windowValue - lines[i - 3] + lines[i]
    if newWindowValue > windowValue:
        result += 1
    windowValue = newWindowValue
echo result