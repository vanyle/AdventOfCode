#? replace(sub = "\t", by = "  ")
import strutils

# Functions for managing snail numbers
type 
	SKind = enum
		Regular, Pair
	SNbr = ref SNbrObj
	SNbrObj = object
		parent: SNbr
		case stype: SKind
		of Pair:
			left: SNbr
			right: SNbr
		of Regular:
			n: int

proc `$`(n: SNbr): string =
	if n.stype == Regular:
		return $n.n
	else:
		return "[" & $n.left & "," & $n.right & "]"

proc parse_helper(s: string): tuple[n: SNbr,i: int] =
	if s[0] == '[':
		result.n = SNbr(stype: Pair)
		let left = parse_helper(s[1..<s.len])
		result.n.left = left.n
		result.n.left.parent = result.n
		let rest = s[1+left.i..<s.len]
		let right = parse_helper(rest)
		result.n.right = right.n
		result.n.right.parent = result.n
		result.i = left.i + right.i + 2 # eat the "]"
	else:
		# read only 1 number.
		result.n = SNbr(stype: Regular)
		result.n.n = parseInt($s[0])
		result.i = 2
proc parse(s: string): SNbr =
	return parse_helper(s).n


proc compute_explode(a: SNbr, depth: int = 0): tuple[r: SNbr, e: bool] =
	## Attempt to perform an explosion reduction.
	## Returns a tuple containing the result as well as if an explosion occured.
	if a.stype == Regular:
		return (a,false)
	else:
		if depth >= 4:
			if a.stype == Pair:
				# explosion, we need to change the parents
				var up = a
				while up.parent != nil:
					if up.parent.left != up: # up is at the right
						# descend to the right
						up = up.parent.left
						while up.stype != Regular:
							up = up.right
						up.n += a.left.n
						break
					up = up.parent

				up = a
				while up.parent != nil:
					if up.parent.right != up: # up is at the left
						# descend to the left
						up = up.parent.right
						while up.stype != Regular:
							up = up.left
						up.n += a.right.n
						break
					up = up.parent
				var r = (r: SNbr(stype: Regular, n: 0), e: true)
				r.r.parent = a.parent
				return r
		else:
			let left_ex = compute_explode(a.left, depth+1)
			var r: tuple[r: SNbr, e: bool] = (nil, false)
			if not left_ex.e:
				var tmp = compute_explode(a.right, depth+1)
				if tmp.e:
					r = (r: SNbr(stype: Pair,left: a.left, right: tmp.r), e: true)
				else:
					r = (r: a, e: false)
			else:
				r = (r: SNbr(stype: Pair,left: left_ex.r, right: a.right), e: true) 
			r.r.parent = a.parent
			r.r.left.parent = r.r
			r.r.right.parent = r.r
			return r

proc compute_splits(a: SNbr): tuple[r: SNbr, e: bool] =
	if a.stype == Regular:
		if a.n >= 10:
			let lown = a.n div 2
			let highn = if a.n mod 2 == 0: lown else: lown + 1

			let left = SNbr(stype: Regular, n: lown)
			let right = SNbr(stype: Regular, n: highn)
			return (SNbr(stype: Pair, left: left,right: right),true)
		else:
			return (a,false)
	else:
		let left_ex = compute_splits(a.left)
		var r: tuple[r: SNbr, e: bool] = (nil, false)
		if not left_ex.e:
			var tmp = compute_splits(a.right)
			if tmp.e:
				r = (r: SNbr(stype: Pair,left: a.left, right: tmp.r), e: true)
			else:
				r = (r: a, e: false)
		else:
			r = (r: SNbr(stype: Pair,left: left_ex.r, right: a.right), e: true) 
		r.r.parent = a.parent
		r.r.left.parent = r.r
		r.r.right.parent = r.r
		return r

proc reduce(a: SNbr, depth: int = 0): SNbr =
	# Depth first search, left start
	result = a
	while true:
		let step1 = compute_explode(result)
		if step1.e:
			result = step1.r
			continue
		let step2 = compute_splits(result)
		if step2.e:
			result = step2.r
			continue
		break


proc mag(a: SNbr): int =
	if a.stype == Regular:
		return a.n
	else:
		return mag(a.left)*3 + mag(a.right)*2

proc `+`(a,b: SNbr): SNbr =
	return reduce(SNbr(stype: Pair, left: a, right: b))

# Start here.
let lines = readFile("input18.txt").strip.splitLines

var start = parse(lines[0])
for i in 1..<lines.len:
	start = start + parse(lines[i])
echo "Result: ",mag(start)