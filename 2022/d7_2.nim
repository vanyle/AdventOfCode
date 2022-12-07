import strutils, tables

type Tree = ref object
    files: Table[string, int]
    directories: Table[string, Tree]
    parent: Tree # is nil for root
    totalSize: int

var root = Tree()
var cwd = root
let lines = readFile("input7.txt").strip().splitLines()

const totalSpace = 70000000
const spaceRequired = 30000000

# Step 1. Build Tree
for l in lines:
    var l = l.strip()
    if l.startswith("$"):
        if l == "$ cd /":
            cwd = root
        elif l.startswith("$ cd "):
            var dir = l[5..<l.len]
            if dir == ".." and cwd != root:
                cwd = cwd.parent
            else:
                cwd = cwd.directories[dir]
        # ignore ls.
    elif l.startswith("dir "):
        var dir = l[4..<l.len]
        cwd.directories[dir] = Tree()
        cwd.directories[dir].parent = cwd
    else:
        var filedesc = l.split(" ",2)
        cwd.files[filedesc[1]] = filedesc[0].parseInt

# Step 2. Compute totalSize
proc computeTotalSize(t: var Tree) =
    var ts = 0
    for f,s in t.files: ts += s
    for d, children in t.directories:
        computeTotalSize(t.directories[d])
        ts += children.totalSize
    t.totalSize = ts
# Step 3. Find
computeTotalSize(root)
var spaceToDelete = spaceRequired - (totalSpace - root.totalSize)
var result = root.totalSize
proc findDirectory(t: Tree) =
    if t.totalSize > spaceToDelete and t.totalSize < result:
        result = t.totalSize
    for d, children in t.directories:
        findDirectory(t.directories[d])
findDirectory(root)
echo result