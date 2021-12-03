import strutils, sequtils

let lines = readFile("input3.txt").splitLines
let bitlength = lines[0].len

# Return true if 1 is the most common at position among the lines corresponding to the given indices.
# Note that 1 most common <=> 0 least common
proc matchingBit(pos: int, lines_indices: seq[int]): bool =
    var bt = 0
    for i in lines_indices:
        if lines[i][pos] == '1': bt += 1
    return bt.float >= (lines_indices.len / 2) 

proc filter(switch: bool): string =
    var lines_indices: seq[int] = toSeq(0..lines.len-1)
    var pos = 0
    while lines_indices.len > 1 and pos < bitlength:
        var idx = 0
        var indices_copy = deepCopy lines_indices
        var matching_char = if switch == matchingBit(pos, indices_copy): '1' else: '0'
        while idx < lines_indices.len:
            # switch = false => match
            if lines[lines_indices[idx]][pos] == matching_char: lines_indices.del(idx)
            else: idx += 1
        pos += 1
    return lines[lines_indices[0]]

proc binToDec(s: string): int = 
    result = 0
    for i in 0..<s.len:
        result *= 2
        if s[i] == '1':
            result += 1 

var oxygen_rating = binToDec(filter(false))
var co2_rating = binToDec(filter(true))
echo "Result:",oxygen_rating * co2_rating