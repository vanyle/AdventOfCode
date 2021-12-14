#? replace(sub = "\t", by = "  ")
import strutils, sequtils, tables

let lines = readFile("input14.txt").split("\n\n")
var curr_temp = lines[0]
let srules = lines[1].splitLines.map(proc (s: string): seq[string] = s.split(" -> "))
var rule_map = initTable[string,string]()

for r in srules:
	rule_map[r[0]] = r[1]

for i in 1..10:
	var new_temp = ""
	for j in 0..<curr_temp.len-1:
		if curr_temp[j..j+1] in rule_map:
			let s = rule_map[curr_temp[j..j+1]]
			new_temp = new_temp & curr_temp[j] & s
	new_temp &= curr_temp[curr_temp.len-1]
	curr_temp = new_temp

# find most common and least common
var counttable = initCountTable[char]()
for i in curr_temp:
	counttable.inc(i)
let largest = tables.largest(counttable)
let smallest = tables.smallest(counttable)

echo "Result: ",largest.val - smallest.val
