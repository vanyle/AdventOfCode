import strutils, sequtils

let start_fishes = readFile("input6.txt").split(",").map(parseInt)

const ttr: int = 7 # time to reproduce
const ttm: int = 2 # time to mature

var fish_pop = newSeq[int](ttr + ttm)

for i in start_fishes:
    fish_pop[i] += 1

const DAYS: int = 256

for i in 1..DAYS:
    ## simulate a day: shift array to the left
    var newPop = newSeq[int](ttr + ttm)
    for j in 1..<fish_pop.len:
        newPop[j-1] = fish_pop[j]
    newPop[ttr-1] += fish_pop[0]
    newPop[ttr+ttm-1] += fish_pop[0]

    fish_pop = newPop


echo "Result: ",fish_pop.foldl(a+b)