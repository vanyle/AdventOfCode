import strutils, sequtils, tables, math, strformat, sugar

var input = readFile("input20.txt").strip().splitLines.map(parseInt)

input = input.map((x) => x * 811589153)

# original index, new index, value
var nums: Table[int,int]
var indices: Table[int,int]
var revIndices: Table[int,int]

for i in 0..input.len-1:
  nums.add(i,input[i])
  indices.add(i,i)
  revIndices.add(i,i)

proc realModulo(a,b: int): int =
  a - ((a div b)*b)

let ns = input.len

# mix
for i in 0..<10:
    for j in 0..ns-1:
      let i = indices[j]
      let n = input[j]
      var
        x = (if n < 0 and n + i <= 0:
               # cycle right
               let shift = (n mod (ns-1))
               if shift + i <= 0: ns - 1 + shift else: shift
             elif n > 0 and n + i >= ns-1:
               # cycle left
               ((i + n) mod (ns-1)) - i
             else:
               n mod ns)
        oldI = i

      while n != 0 and x != 0:
        # get new idx of next n, which will be +/- 1 from its current real index
        let newI = oldI+sgn(x)
        # and destination value
        let tmp = nums[newI]
        # get original index of destination value
        let destOrigI = revIndices[newI]

        # echo fmt"swapping {i}: {n} from {oldI} to {newI}, displacing {tmp}"
        nums[newI] = n
        nums[oldI] = tmp
        # update reverse indices
        revIndices[newI] = j
        revIndices[oldI] = destOrigI
        indices[j] = newI
        indices[destOrigI] = oldI
        x -= sgn(x)
        oldI = newI

# get grove numbers
var zIndex = -1
for i in 0..ns-1:
  if nums[i] == 0:
    zIndex = i
    break

let
  a = nums[(zIndex + 1000) mod ns]
  b = nums[(zIndex + 2000) mod ns]
  c = nums[(zIndex + 3000) mod ns]

echo (a,b,c)
echo sum([a,b,c])