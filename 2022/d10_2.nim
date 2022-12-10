import strutils

let lines = readFile("input10.txt").strip().splitLines()

var X = 1
var cycles = 0

proc cycleHook(cycleCount: int) =
    if abs(X - ((cycleCount-1) mod 40)) <= 1:
        stdout.write('#')
    else:
        stdout.write(' ')
    if cycleCount mod 40 == 0:
        stdout.write('\n')

for instruction in lines:
    if instruction == "noop":
        cycles += 1
        cycleHook(cycles)
    else:
        let parts = instruction.split(" ",1)
        let c = parts[1].parseInt
        cycles += 1
        cycleHook(cycles)
        cycles += 1
        cycleHook(cycles)
        X += c