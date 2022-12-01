import sequtils, strutils

let lines = readFile("input8.txt").splitLines
var count = 0

for line in lines:
    let groups = line.split("|")
    # let all_nums_table = groups[0].split(" ").filter(proc(s:string):bool = s.len>0)
    let output_table = groups[1].split(" ").filter(proc(s:string):bool = s.len>0)

    for output in output_table:
        if output.len in {2,3,4,7}: # 1, 4, 7 or 8
            count += 1 

echo "Result: ",count