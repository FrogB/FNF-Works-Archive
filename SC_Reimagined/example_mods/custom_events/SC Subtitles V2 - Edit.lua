local row = 0
local string = ''
local printI = 0
function onCreate()
    for i = 1,5 do
        makeLuaText('text_Row'..i, '', 900, 170, 450+i*25)
        setTextColor('text_Row'..i, 'ffffff')
        setTextSize('text_Row'..i, 45);
        addLuaText('text_Row'..i)
    end
end
function onUpdate()
    if printI <= string.len(string) then
    setProperty('text_Row'..row..'.text',getProperty('text_Row'..row..'.text') .. string.sub(string,printI,printI))
    printI = printI+1
    end
end
function onEvent(name, value1, value2)
    if name == "SC Subtitles V2 - Edit" then
        row = value1
        string = value2
        printI = 2
        setProperty('text_Row'..row..'.text',getProperty('text_Row'..row..'.text') .. string.sub(string,1,1))
    end
end