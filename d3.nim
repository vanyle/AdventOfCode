import strutils

let lines = readFile("input3.txt").splitLines

let bitlength = lines[0].len
var bittable: seq[int] = @[]
for i in 0..<bitlength:
    bittable.add(0)

for line in lines:
    for j in 0..<line.len:
        if line[j] == '1':
            bittable[j] += 1

var epsilon = 0
var gamma = 0

for i in 0..<bitlength:
    epsilon *= 2
    gamma *= 2
    if bittable[i] > lines.len div 2:
        epsilon += 1
    else:
        gamma += 1

echo gamma
echo epsilon

echo epsilon * gamma