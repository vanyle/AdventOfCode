import strutils

let lines = readFile("input10.txt").strip().splitLines()

var X = 1
var cycles = 0
var result = 0

var noticableCycles = @[20, 60, 100, 140, 180, 220]

proc cycleHook(cycleCount: int) = # Called during the cycle
    if cycleCount in noticableCycles:
        result += cycleCount * X

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
        X += c # end of instruction after 2 cycles.

echo result