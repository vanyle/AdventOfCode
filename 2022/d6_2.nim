import sets

let content = readFile("input6.txt")

proc allDifferent(s: string, idx: int): bool =
    var ss: seq[char] = @[]
    for i in 0..<14:
        ss.add(s[idx + i])
    return ss.toHashSet.len == 14

for i in 0..<(content.len - 13):
    if allDifferent(content, i):
        echo i + 14
        break