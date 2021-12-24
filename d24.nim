import strutils, sequtils, sugar

# Emulates a cycle of the verification step
#[
proc transform(inptz: int, w: int, coef1: int, coef2: int, coef3: int): int =
    assert coef1 == 1 or coef1 == 26
    var z = inptz
    var x = (z mod 26) + coef2
    
    z = z div coef1

    x = if x == w: 0 else: 1
    var y = 25 * x + 1
    z *= y # y = 26 or 1
    y = (w + coef3) * x
    z += y
    return z
]#

let lines = readFile("input24.txt").strip.splitLines
let instructions = lines.map(x => x.split)

# 3 numbers change for every 14 block
# div 26 or 1
# add x ...
# add y ...
var coefs: seq[seq[int]]


let groupSize = instructions.len div 14

for i in 0..<14:
    let i1 = instructions[i*groupSize + 4][2].parseInt
    let i2 = instructions[i*groupSize + 5][2].parseInt
    let i3 = instructions[i*groupSize + 15][2].parseInt
    coefs.add(@[i1,i2,i3])

var allowed: seq[(int,int)] = newSeq[(int,int)](14)
var stack: seq[int]

for i,coef in coefs:
    if coef[0] == 1:
        stack.add(i)
    else:
        var j = stack.pop
        var diff = coefs[j][2]+coef[1]
        if diff < 0:
            allowed[j] = (1-diff,9)
            allowed[i] = (1,9+diff)
        else:
            allowed[j] = (1,9-diff)
            allowed[i] = (1+diff,9)


echo "Result1: ",allowed.map(x => x[1]).join
echo "Result2: ",allowed.map(x => x[0]).join