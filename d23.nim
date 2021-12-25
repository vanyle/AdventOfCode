#? replace(sub = "\t", by = "  ")

# no input reading today !

const aCost = 1
const bCost = 10
const cCost = 100
const dCost = 1000

# computers are so useful at problem solving !

var score = 0

# move a left
score += (5 + 5) * aCost

# move c right
score += 2 * cCost

# move b to correct spot
score += 8 * bCost

# move d to correct spot
score += 5 * dCost
score += 8 * dCost

# move other b to correct spot
score += 5 * bCost

# move both c to correct spot
score += (5 + 7) * cCost

# move both a to correct spot
score += (3 + 3) * aCost

echo "Result: ",score