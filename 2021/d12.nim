#? replace(sub = "\t", by = "  ")
import strutils, tables

let lines = readFile("input12.txt").splitLines
var graph = initTable[string,seq[string]]()

for l in lines:
	let link = l.split("-")
	if link[0] notin graph:
		graph[link[0]] = @[]
	if link[1] notin graph:
		graph[link[1]] = @[]

	graph[link[0]].add(link[1])
	graph[link[1]].add(link[0])

var path_counter = 0

proc explore(start: string, seen: seq[string]) =
	for c in graph[start]:
		if c == "end":
			path_counter += 1
		elif c[0].isUpperAscii() or c notin seen:
			# We assume that there are no infinite loops in the paths
			# i.e no big caves are connected.
			let newseen = seen & @[c]
			explore(c, newseen)


explore("start", @["start"])
echo path_counter