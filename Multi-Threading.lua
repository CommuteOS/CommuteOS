fs.makeDir("AutoRun")
fs.makeDir("PreRun")

function defShell ()
local historeh = {}
while true do
write(shell.dir() .. "> ")
inputtedText = read(nil, historeh)
local tWords = {}
for match in string.gmatch(sLine, "[^ \t]+") do
   table.insert( tWords, match )
end
if #tWords > 0 then
sCommand = tWords[1]
shell.run( sCommand, unpack( tWords, 2 ) )
end
end
end

for n,m in ipairs(fs.list("PreRun/")) do shell.run(m, "PreRun") end

threads = {}
threads[1] = defShell

for n,m in ipairs(fs.list("AutoRun/")) do threads[#threads+1] = function () shell.run(m, "AutoRun") end end

parallel.waitForAll ( unpack(threads) )