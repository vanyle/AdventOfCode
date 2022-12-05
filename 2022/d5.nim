import strutils

let content = readFile("input5.txt").split("\n\n",1)
var initialState = content[0]
var actions = content[1].strip().split("\n")

# The real challenge today is parsing the input.
# Note that the stack positions are 1-indexed.
var cols = initialState.split("\n")
var columnCount = (cols[0].len+1) div 4
var stacks: seq[seq[char]] = newSeq[seq[char]](columnCount)
for i in countdown(cols.len - 2, 0):
    for j in 0..<columnCount:
        let c = cols[i][j*4 + 1]
        if c == ' ': continue
        stacks[j].add(c)

for act in actions:
    let bits = act.split(" ")
    let count = parseInt(bits[1])
    let src = parseInt(bits[3])
    let dest = parseInt(bits[5])
    for i in 0..<count:
        stacks[dest-1].add(stacks[src-1].pop())

var result = ""
for s in stacks:
    result.add(s[s.len-1])
echo result
