#? replace(sub = "\t", by = "  ")
import tables
# No input here, it's only 2 numbers.
let start_p1 = 10 # named A as in Alice
let start_p2 = 7 # named B as in Bob

type calldesc = tuple[scoreA,scoreB,posA,posB: int, turn: int]
type winCounts = tuple[a,b: int]
var callcache: Table[calldesc, winCounts] = initTable[calldesc,winCounts]()

proc winCount(state: calldesc): winCounts =
	if state in callcache: return callcache[state]
	
	if state.scoreA >= 21:
		callcache[state] = (a: 1,b: 0)
		return (a: 1,b: 0)
	if state.scoreB >= 21:
		callcache[state] = (a: 0,b: 1)
		return (a: 0,b: 1)

	# turn in 0..2 => alice. turn in 3..5 => bob
	for dice_outcome in 1..3:
		var newstate = state
		if state.turn in {0,1,2}:
			newstate.posA = ((newstate.posA + dice_outcome - 1) mod 10) + 1
			if state.turn == 2: newstate.scoreA += newstate.posA
		else:
			newstate.posB = ((newstate.posB + dice_outcome - 1) mod 10) + 1
			if state.turn == 5: newstate.scoreB += newstate.posB
		newstate.turn = (newstate.turn + 1) mod 6 
		let r = winCount(newstate)
		result.a += r.a
		result.b += r.b

	callcache[state] = result


let startingState = (scoreA: 0,scoreB: 0, posA: start_p1, posB: start_p2, turn: 0)
let r = winCount(startingState)
echo "Match results: ",r
echo "Total games: ",r.a + r.b
echo "Result: ",max(r.a,r.b)