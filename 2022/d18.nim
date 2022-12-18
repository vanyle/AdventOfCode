import strutils, sequtils, sugar

let input = readFile("input18.txt").strip().splitLines().map((x) => x.split(",").map(parseInt))

proc max(a,b: seq[int]): seq[int] =
    for i in 0..<a.len: result.add max(a[i],b[i])
let bounds = input.foldl(max(a, b), @[0,0,0])
# create a 3d list based on the bounds:
var cubes: seq[seq[seq[int]]] = @[]

echo bounds

for i in 0..bounds[0]+1:
    cubes.add @[]
    for j in 0..bounds[1]+1:
        cubes[i].add @[]
        for k in 0..bounds[2]+1:
            cubes[i][j].add 0 # 0 = air

for pos in input:
    cubes[pos[0]][pos[1]][pos[2]] = 1

proc outside(cubes: seq[seq[seq[int]]], x,y,z:int): bool =
    if x < 0 or x >= cubes.len: return true
    if y < 0 or y >= cubes[x].len: return true
    if z < 0 or z >= cubes[x][y].len: return true
    return false

proc getState(cubes: seq[seq[seq[int]]], x,y,z: int, shift: int = 0): int =
    if cubes.outside(x,y,z): return shift
    return cubes[x][y][z]


# let's count the sides!
var sides = 0
for pos in input:
    sides += 1 - cubes.getState(pos[0]+1,pos[1],pos[2])
    sides += 1 - cubes.getState(pos[0]-1,pos[1],pos[2])
    sides += 1 - cubes.getState(pos[0],pos[1]+1,pos[2])
    sides += 1 - cubes.getState(pos[0],pos[1]-1,pos[2])
    sides += 1 - cubes.getState(pos[0],pos[1],pos[2]+1)
    sides += 1 - cubes.getState(pos[0],pos[1],pos[2]-1)
echo "Part1: ",sides

# Now, let's do a bit of flood fill from the outside:
var fillingStack = @[(0,0,0), (bounds[0], bounds[1], bounds[2])]
while fillingStack.len > 0:
    let el = fillingStack.pop()
    if cubes.outside(el[0],el[1],el[2]): continue
    if cubes.getState(el[0],el[1],el[2]) != 0: continue
    cubes[el[0]][el[1]][el[2]] = 2 # outside air is 2

    fillingStack.add((el[0]+1,el[1],el[2]))
    fillingStack.add((el[0]-1,el[1],el[2]))
    fillingStack.add((el[0],el[1]+1,el[2]))
    fillingStack.add((el[0],el[1]-1,el[2]))
    fillingStack.add((el[0],el[1],el[2]+1))
    fillingStack.add((el[0],el[1],el[2]-1))

sides = 0
for pos in input:
    sides += (if 2 == cubes.getState(pos[0]+1,pos[1],pos[2], 2): 1 else: 0)
    sides += (if 2 == cubes.getState(pos[0]-1,pos[1],pos[2], 2): 1 else: 0)
    sides += (if 2 == cubes.getState(pos[0],pos[1]+1,pos[2], 2): 1 else: 0)
    sides += (if 2 == cubes.getState(pos[0],pos[1]-1,pos[2], 2): 1 else: 0)
    sides += (if 2 == cubes.getState(pos[0],pos[1],pos[2]+1, 2): 1 else: 0)
    sides += (if 2 == cubes.getState(pos[0],pos[1],pos[2]-1, 2): 1 else: 0)

echo "Part2: ",sides
