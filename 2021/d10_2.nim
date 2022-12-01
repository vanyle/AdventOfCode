import strutils, algorithm

let lines = readFile("input10.txt").splitLines
var scores: seq[int] = @[]

for l in lines:
    var stack: seq[char] = @[]
    var current_score = 0
    var syntax_error = false
    for i in l:
        if i in {'(','[','{','<'}:
            stack.add(i)
        else:
            let c = stack.pop()
            if (i == ')' and c != '(') or
               (i == ']' and c != '[') or
               (i == '}' and c != '{') or
               (i == '>' and c != '<'):
                # syntax error
                syntax_error = true
                break
    if syntax_error:
        continue

    if stack.len != 0:
        # Line is incomplete.
        for i in countdown(stack.len-1,0):
            let s = stack[i]
            current_score *= 5
            if s == '(':
                current_score += 1
            if s == '[':
                current_score += 2
            if s == '{':
                current_score += 3
            if s == '<':
                current_score += 4
        scores.add(current_score)

scores.sort()

echo "Result: ",scores[scores.len div 2]