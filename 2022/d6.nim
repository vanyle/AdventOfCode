import sets

let content = readFile("input6.txt")

proc allDifferent(s: string, idx: int): bool =
    [s[idx],s[idx+1],s[idx+2],s[idx+3]].toHashSet.len == 4

for i in 0..<(content.len - 3):
    if allDifferent(content, i):
        echo i + 4
        break