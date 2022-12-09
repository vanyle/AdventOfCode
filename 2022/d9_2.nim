import strutils, sugar, sequtils, sets

let lines = readFile("input9.txt").strip().splitLines().map((x) => x.split(" ",1))

let instructions = lines.map((x) => (x[0], x[1].parseInt))
var visitedPositions: HashSet[(int,int)]
var rope = newSeq[(int,int)](10)
visitedPositions.incl(rope[rope.len-1])

proc isFar*(a,b: (int,int)): bool = abs(a[0] - b[0]) > 1 or abs(a[1] - b[1]) > 1

for move in instructions:
    let mcount = move[1]
    for _ in 0..<mcount:
        if move[0] == "U": dec rope[0][1]
        if move[0] == "D": inc rope[0][1]
        if move[0] == "R": inc rope[0][0]
        if move[0] == "L": dec rope[0][0]

        for ropePiece in 1..<rope.len:
            # If a piece of the rope is far from the previous piece
            if isFar(rope[ropePiece-1], rope[ropePiece]):
                let hx = rope[ropePiece-1][0]
                let hy = rope[ropePiece-1][1]
                var tx = rope[ropePiece][0]
                var ty = rope[ropePiece][1]

                if abs(hx - tx) > 1:
                    tx += ( if hx > tx: 1 else: -1 )
                    if abs(hy - ty) > 0:
                        ty += ( if hy > ty: 1 else: -1 )
                elif abs(hy - ty) > 1:
                    ty += ( if hy > ty: 1 else: -1 )
                    if abs(hx - tx) > 0:
                        tx += ( if hx > tx: 1 else: -1 )
                rope[ropePiece][0] = tx
                rope[ropePiece][1] = ty
            else:
                break

        visitedPositions.incl(rope[rope.len - 1])

echo visitedPositions.len