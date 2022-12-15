import strutils, strscans, algorithm

let lines = readFile("input15.txt").strip().splitLines

var sensorBeaconInfo: seq[tuple[x: int,y: int,bx: int,by: int]] = @[]
for l in lines:
    var d: (int,int,int,int)
    assert scanf(l, "Sensor at x=$i, y=$i: closest beacon is at x=$i, y=$i", d[0], d[1], d[2], d[3])
    sensorBeaconInfo.add(d)

let y = 2000000 # 10
# Count the number of position on row y where an undetected beacon cannot be located.
# There are few sensors, but they are far apart.
# So, no iteration on row positions, we need to iterate on sensors / beacons

var intervalSections: seq[(int,int)] = @[] # start and end are included

for sensor in sensorBeaconInfo:
    let maxDist = abs(sensor.x - sensor.bx) + abs(sensor.y - sensor.by)
    let toY = abs(sensor.y - y)
    if toY > maxDist: continue
    # Compute how large the section covered at y is.
    let sectionDiff = (maxDist - toY)
    intervalSections.add((
        sensor.x - sectionDiff,
        sensor.x + sectionDiff
    ))
# Compute the union of all the intervals.
intervalSections.sort(proc(interval1,interval2: (int,int)): int = interval1[0] - interval2[0])
#echo intervalSections
var intervalClean: seq[(int,int)] = @[]

for interval in intervalSections:
    let begin = interval[0]
    let endv = interval[1]
    if intervalClean.len > 0 and intervalClean[^1][1] >= begin:
        intervalClean[^1][1] = max(intervalClean[^1][1], endv)
    else:
        intervalClean.add((begin, endv))

#echo intervalClean

var result = 0
for interval in intervalClean:
    result += interval[1] - interval[0]
echo result