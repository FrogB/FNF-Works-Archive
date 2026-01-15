
function onEvent(name, value1, value2)
    if name == "SC Subtitles V2 - Reset" then
        for i = 1,5 do
        setTextString('text_Row'..i,'')
        end
    end
end