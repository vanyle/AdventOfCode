import strutils, strscans, sugar, sequtils, algorithm

type Monkey = ref object # ref type not needed by the syntax is nicer with them.
    itemsHeld: seq[int]
    optime: bool # true = +, false = *
    operand: string
    divTest: int
    gotoTrue: int
    gotoFalse: int
    inspectionCount: int

var monkeys: seq[Monkey]
let lines = readFile("input11.txt").strip().splitLines()

# A monkey is described with 7 lines of text.
for i in countup(0, lines.len-1, 7):
    var m: Monkey = new(Monkey)
    var x: string
    assert scanf(lines[i+1], "  Starting items: $*", x)
    m.itemsHeld = x.split(",").map((x) => x.strip().parseInt())
    
    var operation: char
    assert scanf(lines[i+2],"  Operation: new = old $c $*", operation, m.operand)
    m.optime = (operation == '+')

    assert scanf(lines[i+3],"  Test: divisible by $i", m.divTest)
    assert scanf(lines[i+4],"    If true: throw to monkey $i", m.gotoTrue)
    assert scanf(lines[i+5],"    If false: throw to monkey $i", m.gotoFalse)
    monkeys.add(m)
# Compute least common multiple of the test values (which are primes...)
# It's as if somebody is trying to implement a [register machine](https://en.wikipedia.org/wiki/Register_machine)...
var globalLcm = 1
for m in monkeys:
    globalLcm *= m.divTest

# Let's run the simulation !
for round in 0..<10000:
    for m in monkeys:
        while m.itemsHeld.len > 0:
            var item = m.itemsHeld.pop()
            let opint: int = if m.operand == "old": item else: m.operand.parseInt
            if m.optime: # '+'
                item += opint
            else:
                item *= opint
            # Apply lcm mod to keep everything at a manageable size.
            item = item mod globalLcm
            if item mod m.divTest == 0:
                monkeys[m.gotoTrue].itemsHeld.add(item)
            else:
                monkeys[m.gotoFalse].itemsHeld.add(item)
            inc m.inspectionCount # end of item inspection!

monkeys.sort do (x, y: Monkey) -> int: cmp(y.inspectionCount, x.inspectionCount)
echo monkeys[0].inspectionCount * monkeys[1].inspectionCount