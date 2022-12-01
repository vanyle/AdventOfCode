#? replace(sub = "\t", by = "  ")
import strutils, sequtils, tables

let lines = readFile("input14.txt").split("\n\n")
var curr_temp = lines[0]
let srules = lines[1].splitLines.map(proc (s: string): seq[string] = s.split(" -> "))
var rule_map = initTable[string,char]()

for r in srules:
	rule_map[r[0]] = r[1][0]

var counttable = initCountTable[char]()
var callcache = initTable[tuple[l,r: char, d: int], CountTable[char]]()

proc sumtables(a,b: CountTable[char]): CountTable[char] = 
	for i,v in a.pairs():
		if i in result:
			result[i] = result[i] + v
		else:
			result[i] = v
	for i,v in b.pairs():
		if i in result:
			result[i] = result[i] + v
		else:
			result[i] = v

proc explore(left,right: char, depth: int): CountTable[char] =
	if depth == 0: return initCountTable[char]() # max depth reached.
	let calldescription = (l: left,r: right, d: depth)
	if calldescription in callcache:
		return callcache[calldescription]

	let s = left & right
	if s in rule_map:
		let r = rule_map[s]
		# Generate a new entry in cache:
		var cache = explore(left,r,depth-1)
		cache.inc(r)
		cache = sumtables(cache,explore(r,right,depth-1))
		callcache[calldescription] = cache
		return cache
	return initCountTable[char]()

for i in 0..<curr_temp.len-1:
	echo i,"/",curr_temp.len-1
	counttable.inc(curr_temp[i])
	counttable = sumtables(counttable,explore(curr_temp[i],curr_temp[i+1],40))
counttable.inc(curr_temp[curr_temp.len-1])

let largest = tables.largest(counttable)
let smallest = tables.smallest(counttable)

echo "Result: ",largest.val - smallest.val
