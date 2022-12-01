import strutils

let lines = readFile("input10.txt").splitLines
var score = 0

for l in lines:
    var stack: seq[char] = @[]
    for i in l:
        if i in {'(','[','{','<'}:
            stack.add(i)
        else:
            let c = stack.pop()
            if (i == ')' and c != '(') or
               (i == ']' and c != '[') or
               (i == '}' and c != '{') or
               (i == '>' and c != '<'):
                # syntax error.
                if i == ')':
                    score += 3
                if i == ']':
                    score += 57
                if i == '}':
                    score += 1197
                if i == '>':
                    score += 25137
                break


echo "Result: ",score