import strutils, tables, math, algorithm

let decTable = {'2': 2, '1': 1, '0': 0, '-': -1, '=': -2}.toTable
let decTable2 = @['0','1','2','=','-']
let decTable3 = @[0,1,2,-2,-1]

let input = readFile("input25.txt").strip().splitLines

proc parseDigit(s: string): int =
    for i in s:
        result += decTable[i]
        result *= 5
    result = result div 5

proc toString(str: seq[char]): string =
  result = newStringOfCap(len(str))
  for ch in str:
    add(result, ch)

proc toSNAFU(i: int): string =
    if i <= 0: return "0"
    var mm = 5
    var i = i
    while i != 0:
        let m = euclMod(i,mm)
        let m2 = (m * 5) div mm
        result.add(decTable2[m2])
        i -= (mm div 5) * decTable3[m2]
        mm *= 5
    return result.reversed().toString()

var s = 0
for l in input:
    s += parseDigit(l)
echo "Part 1: ",toSNAFU(s)

