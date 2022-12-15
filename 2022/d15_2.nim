import strutils, strscans, bigints, options

let lines = readFile("input15.txt").strip().splitLines

var sensorBeaconInfo: seq[tuple[x: int,y: int,bx: int,by: int]] = @[]
for l in lines:
    var d: (int,int,int,int)
    assert scanf(l, "Sensor at x=$i, y=$i: closest beacon is at x=$i, y=$i", d[0], d[1], d[2], d[3])
    sensorBeaconInfo.add(d)

const maxPos = 4000000 # 10
# We need to find a position somewhere in the grid that is not covered by any sensor.
# We need a clever approch to not have to interate over 4 000 000^2 positions.
# It'd like for the complexity to only depend on the number of sensors.
# We are dealing with overlapping rotated squares ...

# We know the solution is unique. So it must be on the edges of the zones (otherwise, it cannot be unique).
# We thus only need to consider the edges of the zone and find a spot that is ok!

# We need to compute the intersections of the lines formed by the corners.
# There are 2 types of lines: \ and /
var linesType1: seq[tuple[x1,y1,x2,y2: int64]]
var linesType2: seq[tuple[x1,y1,x2,y2: int64]]
var candidates: seq[tuple[x,y:int64]]

for sensor in sensorBeaconInfo:
    let maxDist = abs(sensor.x - sensor.bx) + abs(sensor.y - sensor.by)
    let c1 = (x: sensor.x,y: sensor.y + maxDist + 1)
    let c2 = (x: sensor.x,y: sensor.y - maxDist - 1)
    let c3 = (x: sensor.x + maxDist + 1,y: sensor.y)
    let c4 = (x: sensor.x - maxDist - 1,y: sensor.y)
    linesType1.add((c1.x.int64,c1.y.int64, c3.x.int64,c3.y.int64)) # from y+ (top) to x+ (right) \ 
    linesType2.add((c1.x.int64,c1.y.int64, c4.x.int64,c4.y.int64)) # /

    linesType1.add((c4.x.int64,c4.y.int64, c2.x.int64,c2.y.int64)) # from x- (left) to y- (bottom) \
    linesType2.add((c4.x.int64,c4.y.int64, c1.x.int64,c1.y.int64)) # /

type Vec2 = tuple[x,y:int64]
func cross * (a: Vec2, b: Vec2): int64 =
    return a.x * b.y - a.y * b.x
func `-` * (a: Vec2,b: Vec2): Vec2 =
    result.x = a.x - b.x
    result.y = a.y - b.y
func `*` * (a: Vec2,b: Vec2): Vec2 =
    ## Complex multiplication
    result.x = a.x*b.x - a.y*b.y
    result.y = a.x*b.y + a.y*b.x
func dot * (a : Vec2, b: Vec2) : int64 = return a.x*b.x + a.y*b.y
proc intersectLine* (al1,bl1,al2,bl2: Vec2): Vec2 =
    ## Compute the intersection between 2 lines (named 1 and 2), defined by 2 points (named a and b)
    ## Only for / and \ lines.
    assert abs(al1.x - bl1.x) == abs(al1.y - bl1.y)
    assert abs(al2.x - bl2.x) == abs(al2.y - bl2.y)

    let d1 = al1 - bl1
    let d2 = al2 - bl2
    let d = initBigInt(d1.cross(d2)) # det.

    let t1 = initBigInt(al1.x * bl1.y - al1.y * bl1.x)
    let t2 = initBigInt(al2.x * bl2.y - al2.y * bl2.x)
    let x = (t1 * initBigInt(d2.x) - t2 * initBigInt(d1.x)) div d
    let y = (t1 * initBigInt(d2.y) - t2 * initBigInt(d1.y)) div d


    return (x: bigints.toInt[int64](x).get(), y: bigints.toInt[int64](y).get())

proc intersectSegment* (a,b,c,d: Vec2): (bool, Vec2) =
    ## Compute the intersection between 2 segments (a-b and c-d)
    ## If there is an intersection, return true and the intersection.
    ## Returns false if this intersection does not exist.
    let ab_normal = (b-a)*(0.int64,1.int64)
    let cd_normal = (d-c)*(0.int64,1.int64)

    let dot_product1 = (a-c).dot(ab_normal)
    let dot_product2 = (a-d).dot(ab_normal)
    let dot_product3 = (c-a).dot(cd_normal)
    let dot_product4 = (c-b).dot(cd_normal)

    if (dot_product1<0) != (dot_product2<0) and (dot_product3<0) != (dot_product4<0):
        return (true, intersectLine(a,b,c,d))
    else:
        return (false, (0.int64,0.int64))

for i in linesType1:
    for j in linesType2:
        # Apply line intersection algorithm.
        var (isFound, res) = intersectSegment((i[0],i[1]),(i[2],i[3]),(j[0],j[1]),(j[2],j[3]))
        if isFound:
            candidates.add(res)

for candidate in candidates:
    if candidate.x < 0 or candidate.y < 0 or candidate.x > maxPos or candidate.y > maxPos:
        continue

    var isOk = true
    for sensor in sensorBeaconInfo:
        let maxDist = abs(sensor.x - sensor.bx) + abs(sensor.y - sensor.by)
        let canDist = abs(sensor.x - candidate.x) + abs(sensor.y - candidate.y)
        if canDist <= maxDist:
            isOk = false
            break
    if isOk:
        echo "Found."
        echo candidate
        echo candidate.y + candidate.x * 4000000
        break

echo "Done."
