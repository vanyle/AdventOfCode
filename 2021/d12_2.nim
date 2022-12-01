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

proc explore(start: string, seen: seq[string], small_seen_twice: bool) =
	for c in graph[start]:
		if c == "end":
			path_counter += 1
		elif c != "start":
			if c[0].isUpperAscii():
				# We assume that there are no infinite loops in the paths
				# i.e no big caves are connected.
				explore(c, seen, small_seen_twice)
			else:
				if c notin seen:
					let newseen = seen & @[c]
					explore(c, newseen, small_seen_twice)
				elif not small_seen_twice:
					explore(c, seen, true)

explore("start", @[], false)
echo path_counter