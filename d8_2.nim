import sequtils, strutils, sets

let lines = readFile("input8.txt").splitLines
var count = 0

proc letterToNum(c: char): int = c.int - 97

proc getByLen(table: seq[HashSet[int]], length: int): HashSet[int] =
    for i in table:
        if i.len == length: return i
    return table[0]

for line in lines:
    let groups = line.split("|")
    let all_nums_table = groups[0].split(" ").filter(proc(s:string):bool = s.len>0)
    let output_table = groups[1].split(" ").filter(proc(s:string):bool = s.len>0)
    
    var table: seq[HashSet[int]] = @[]
    var codes: seq[int] = @[0,1,2,3,4,5,6]

    for s in all_nums_table:    
        var ns = initHashSet[int]()
        for ch in s:
            var id = letterToNum ch
            ns.incl(id)
        table.add(ns)

    var zero = table[0]
    var one = table.getByLen(2)
    var two = table[0]
    var three = table[0]
    var four = table.getByLen(4)
    var five = table[0]
    var six = table[0]
    var seven = table.getByLen(3)
    var eight = table.getByLen(7)
    var nine = table[0]
    
    var bottom_right_segment = -1
    # Bottom right is from the 2: the only number where this segment is missing
    for i in codes:
        var count = 0
        for digit in table:
            if i in digit:
                count += 1
        if count == 9:
            # This is bottom right !
            bottom_right_segment = i
            break
    
    var top_left_segment = -1
    for digit in table:
        if bottom_right_segment notin digit:
            # This is 2.
            two = digit
            for i in codes:
                if i != bottom_right_segment and i notin digit:
                    top_left_segment = i

    var bottom_left_segment = -1
    var top_right_segment = -1
    for digit in table:
        if digit.len == 5 and bottom_right_segment in digit and digit != two:
            if top_left_segment in digit:
                five = digit
            else:
                three = digit
                for i in codes:
                    if i != top_left_segment and i notin three:
                        bottom_left_segment = i
    for i in codes:
        if i notin five and i in three:
            top_right_segment = i
            break 

    for digit in table:
        if digit.len == 6:
            if top_right_segment notin digit:
                six = digit
            elif bottom_left_segment in digit:
                zero = digit
            else:
                nine = digit

    # We got them all !
    var num_table = @[zero,one,two,three,four,five,six,seven,eight,nine]
    var line_nbr: int = 0

    for s in output_table:
        var ns = initHashSet[int]()
        for ch in s:
            var id = letterToNum ch
            ns.incl(id)
        for i,nbr in num_table.pairs():
            if nbr == ns:
                line_nbr *= 10
                line_nbr += i                

    count += line_nbr

echo "Result: ",count