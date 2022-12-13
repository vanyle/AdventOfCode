import strutils, sugar, sequtils, algorithm
# Friends don't let friends write parsers by hand.
import npeg

type
    PacketType = enum
        Number
        List

    Packet = ref object
        parent: Packet
        case kind: PacketType
        of Number:
            value: int
        of List:
            data: seq[Packet]

# First packet should be smaller.
proc cmp(a,b: Packet): int = # 0 => ==, positive => a > b, negative => a < b
    if a.kind == Number and b.kind == Number:
        return cmp(a.value,b.value)
    elif a.kind == List and b.kind == List:
        for i in 0..<a.data.len:
            if b.data.len <= i: return 1
            let v = cmp(a.data[i],b.data[i])
            if v != 0: return v
        if a.data.len != b.data.len:
            return cmp(a.data.len, b.data.len)
        else:
            return 0
    elif a.kind == Number:
        return cmp(Packet(kind: List, data: @[a]), b)
    else:
        return cmp(a, Packet(kind: List, data: @[b]))

let parser = peg("packet", currentPacket: Packet):
    packet <- par * !1
    endOfPacket <- ']':
        currentPacket = currentPacket.parent
    startOfPacket <- '[':
        var newPacket = Packet(kind: List)
        newPacket.parent = currentPacket
        currentPacket = newPacket
        currentPacket.parent.data.add(currentPacket)
    par <- emptyList | (startOfPacket * >element * *(',' * >element) * endOfPacket)
    emptyList <- "[]":
        currentPacket.data.add(Packet(kind: List))
    element <- par | number
    number <- >+Digit:
        currentPacket.data.add(Packet(kind: Number, value: parseInt($1)))


proc toPacket(s: string): Packet =
    var rootPacket = Packet(kind: List)
    discard parser.match(s, rootPacket)
    return rootPacket

var input = readFile("input13.txt").strip().split("\n").filter((x) => x.len > 0).map((x) => x.toPacket)
let divider1 = toPacket("[[2]]")
let divider2 = toPacket("[[6]]")
input.add(divider1)
input.add(divider2)
input.sort(cmp)

var idx1, idx2: int
for i in 0..<input.len:
    if input[i] == divider1: idx1 = i+1
    if input[i] == divider2: idx2 = i+1

echo idx1 * idx2