# Quick hacky script to get everything into one portable file
fs = require "fs"

indexContents = fs.readFileSync("./src/index.html").toString()
scriptContents = fs.readFileSync("./build/main.js").toString()

[start, end] = indexContents.split('<script src="/main.js"></script>')

# This avoids a weird bug where replace would fail on very large strings
newIndexContents = start + "<script>" + scriptContents + "</script>" + end

fs.writeFileSync("./build/index.html", newIndexContents)
fs.unlinkSync("./build/main.js")
