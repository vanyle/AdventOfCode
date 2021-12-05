import strutils, sequtils, tables

type pos = tuple[x: int,y: int]

let lines = readFile("input5.txt").splitLines


# coordLines is a list of lists of 4 elements: x1,y1,x2,y2
var coordsLines = lines.map(
    proc (s: string): seq[int] =
        var v = s.split(" -> ")
        var startp = v[0].split(",").map(parseInt)
        var endp = v[1].split(",").map(parseInt)
        return startp & endp
)


proc addIntersections(t: var Table[pos,bool], l1: seq[int], l2: seq[int]): bool =

    if l1[0] == l1[2]:
        # l1 vertical
        if l2[0] == l2[2] and l1[0] == l2[0]:
            let min1 = min(l1[1],l1[3])
            let max1 = max(l1[1],l1[3])
            let min2 = min(l2[1],l2[3])
            let max2 = max(l2[1],l2[3])
            
            for i in max(min1,min2) .. min(max1,max2):
                t[(l1[0],i)] = true
            return true
        if l2[1] == l2[3] and min(l2[0],l2[2]) <= l1[0] and l1[0] <= max(l2[0],l2[2]):
            # l2 horizontal
            if min(l1[1],l1[3]) <= l2[1] and l2[1] <= max(l1[1],l1[3]):
                t[(l1[0],l2[1])] = true
                return true
    elif l1[1] == l1[3]:
        # l1 horizontal
        if l2[1] == l2[3] and l1[1] == l2[1]:
            let min1 = min(l1[0],l1[2])
            let max1 = max(l1[0],l1[2])
            let min2 = min(l2[0],l2[2])
            let max2 = max(l2[0],l2[2])
            for i in max(min1,min2) .. min(max1,max2):
                t[(i,l1[1])] = true
            return true
        if l2[0] == l2[2] and min(l2[1],l2[3]) <= l1[1] and l1[1] <= max(l2[1],l2[3]):
            # l2 horizontal
            if min(l1[0],l1[2]) <= l2[0] and l2[0] <= max(l1[0],l1[2]):
                t[(l2[0],l1[1])] = true
                return true
    return false


var intersections = initTable[pos,bool]()

for i in 0..<coordsLines.len:
    # we only consider vertical and horizontal lines:
    if coordsLines[i][0] != coordsLines[i][2] and coordsLines[i][1] != coordsLines[i][3]:  
        continue
    for j in (i+1)..<coordsLines.len:
        if coordsLines[j][0] != coordsLines[j][2] and coordsLines[j][1] != coordsLines[j][3]:  
            continue
        discard intersections.addIntersections(coordsLines[i],coordsLines[j])
        


echo "Result: ",intersections.len