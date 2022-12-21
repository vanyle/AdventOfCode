import strutils, sequtils, tables

type Monkey = object
    name: string
    case isOperation: bool # is operation
    of true:
        lMonkey: string
        rMonkey: string
        op: char
    of false:
        value: float64


var input = readFile("input21.txt").strip().splitLines
var monkeys: Table[string, Monkey]

for l in input:
    let components = l.split(":",1)
    let name = components[0]
    try:
        let value = parseInt(components[1].strip())
        monkeys[name] = Monkey(
            name: name,
            isOperation: false,
            value: value.float64
        )
        continue
    except:
        discard

    let operationComponents = components[1].strip().split(" ", 2)
    monkeys[name] = Monkey(
        name: name,
        isOperation: true,
        lMonkey: operationComponents[0],
        op: operationComponents[1][0],
        rMonkey: operationComponents[2]
    )

var monkeyValueCache: Table[string, float64]


proc evalMonkey(name: string): float64 =
    if name in monkeyValueCache:
        return monkeyValueCache[name]

    if not monkeys[name].isOperation:
        monkeyValueCache[name] = monkeys[name].value
        return monkeys[name].value
    else:
        var v: float64 = 0
        if monkeys[name].op == '+':
            v = evalMonkey(monkeys[name].lMonkey) + evalMonkey(monkeys[name].rMonkey)
        elif monkeys[name].op == '-':
            v = evalMonkey(monkeys[name].lMonkey) - evalMonkey(monkeys[name].rMonkey)
        elif monkeys[name].op == '*':
            v = evalMonkey(monkeys[name].lMonkey) * evalMonkey(monkeys[name].rMonkey)
        elif monkeys[name].op == '/':
            v = evalMonkey(monkeys[name].lMonkey) / evalMonkey(monkeys[name].rMonkey)
        monkeyValueCache[name] = v
        return v
proc cleanEval(name: string): float64 =
    monkeyValueCache.clear()
    return evalMonkey(name)

echo "Part 1: ",cleanEval("root")

let m1 = monkeys["root"].lMonkey
let m2 = monkeys["root"].rMonkey
proc monkeyFunc(n: float64): float64 =
    monkeys["humn"].value = n
    return cleanEval(m1) - cleanEval(m2)

# monkeys["humn"]

let toMatch = cleanEval(m2) # This value does not depend on humn.
# monkeys["humn"].value = 3
echo "Expected value: ",toMatch
# 54426117311903
# 114076334077499

# 16966946581028

# Monkey func is monotonic (decreasing), so, we'll use that.
# Might not work on all inputs.
var testVal = 10.float64
var lowerBound = 0.float64
var upperBound = 5442611731190.float64

assert monkeyFunc(upperBound) < toMatch
assert monkeyFunc(lowerBound) > toMatch

# 54426117311903
# 3343167719436

echo "Test: ",monkeyFunc(3343167719436.float64)
echo "Test: ",monkeyFunc(3343167719435.float64)

while true:
    testVal = ((upperBound.int64 + lowerBound.int64) div 2).float64
    let mv = monkeyFunc(testVal)
    echo "mv = ",mv
    if mv > 0:
        lowerBound = testVal
    elif mv < 0:
        upperBound = testVal
    else:
        break

# Move by increments of 1 now:
echo "Guess: ",testVal
while monkeyFunc(testVal) > 0:
    testVal += 1
while monkeyFunc(testVal) < 0:
    testVal -= 1
echo "Part2: ",testVal
echo monkeyFunc(testVal)