#? replace(sub = "\t", by = "  ")

# No input here, it's only 2 numbers.
let start_p1 = 10
let start_p2 = 7

var d = 1
var roll_count = 0
proc get_die(): int =
	roll_count += 1
	result = d
	d += 1
	if d > 100: d = 1
proc move(ppos: var int, amount: int) =
	ppos += amount
	ppos = ((ppos-1) mod 10) + 1

var p1_pos = start_p1
var p1_score = 0
var p2_pos = start_p2
var p2_score = 0

while p1_score < 1000 and p2_score < 1000:
	let p1_move = get_die() + get_die() + get_die()
	move(p1_pos,p1_move)
	p1_score += p1_pos
	
	if p1_score >= 1000: break

	let p2_move = get_die() + get_die() + get_die()
	move(p2_pos,p2_move)
	p2_score += p2_pos

echo "Result: ", p2_score * roll_count