#? replace(sub = "\t", by = "  ")
# won't read file might as well just copy the data
# x=20..30, y=-10..-5
const xstart = 241
const xend = 273
const ystart = -97
const yend = -63

proc inArea(x,y: int): bool =
	return xstart <= x and x <= xend and ystart <= y and y <= yend


func sign(x: int): int {.inline.} = 
	if x>0: 
		1
	elif x<0:
		-1
	else:
		0

proc processVel(velx,vely: int): tuple[r: bool,m: int] =
	var xpos = 0
	var ypos = 0
	var vx = velx
	var vy = vely

	var maxy = 0

	while true:
		if ypos < ystart: return (r: false,m: maxy)
		if inArea(xpos,ypos): return (r: true,m: maxy)

		if ypos > maxy: maxy = ypos


		xpos += vx
		ypos += vy

		vx = (abs(vx)-1) * sign(vx) # drag
		vy -= 1

# xstart > 0 and xend > 0, so vx > 0
# also, vx < xend and  vx > 1

var maxvy = 0
var maxy = 0

for vx in 1..xend:
	# vy > 0 (as big as possible)
	# vy < xend/2 --> the top of the traj will be at least the half way pt
	for vy in 0..xend:
		let tinfo = processVel(vx,vy)
		if tinfo.r and maxvy < vy:
			echo "vx,vy: ",vx," ",vy
			maxvy = vy
			maxy = tinfo.m

echo "Result: ",maxy