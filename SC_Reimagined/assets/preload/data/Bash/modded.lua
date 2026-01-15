local longPenis = false;
local beginBitches = false;

function onCreate()
    makeLuaSprite('shitty', '', 1100, 20)
    makeLuaSprite('shitty2', '', 1100, 3)
   
end

function onSongStart()
    cameraFlash('camOther', 'FFFFFF', 1, true)
    doTweenX('penis', 'shitty', 0.7, 1, 'elasticOut')
end

function onBeatHit()
    if curBeat == 16 then
        doTweenY('tweenNotes', 'shitty', 0, 10, 'quadIn')
        doTweenY('tweenNotes2', 'shitty2', 0, 10, 'quadIn')
    end
    if beginBitches == true then
        if curBeat % 1 == 0 then
            setProperty('camHUD.y', 0)
            doTweenY('cdeh', 'camHUD', 10, crochet/1000, 'backOut')
            setProperty('shitty.y', 50)
            doTweenY('lolololololololololololololololololololololololololololololololololololololololololollolololololololololololololololololololololololololololololololololololololololollololollollolololololololloolloolloolololololololollololo', 'shitty', 0, crochet / 1000, 'quadOut')
        end
    end
    if curBeat == 32 then
        beginBitches = true;
    end
    if curBeat == 160 then
        cameraFlash('camOther', 'FFFFFF', 1, true)
        beginBitches = false;
        doTweenY('tweenNotes', 'shitty', 40, 10, 'quadIn')
        doTweenY('tweenNotes2', 'shitty2', 3, 10, 'quadIn')
    end
end

function onUpdate(elapsed)
    songPos = getSongPosition()
    currentBeat = (songPos/20000)*(curBpm/60)

    noteTweenY("defaultOpponentStrumY0", 0, defaultOpponentStrumY0 - getProperty('shitty.y') * math.sin((currentBeat + 1) * 10), 0.001)
    noteTweenY("defaultOpponentStrumY1", 1, defaultOpponentStrumY1 - getProperty('shitty.y') * math.sin((currentBeat + 2) * 10), 0.001)
    noteTweenY("defaultOpponentStrumY2", 2, defaultOpponentStrumY2 - getProperty('shitty.y') * math.sin((currentBeat + 3) * 10), 0.001)
    noteTweenY("defaultOpponentStrumY3", 3, defaultOpponentStrumY3 - getProperty('shitty.y') * math.sin((currentBeat + 4) * 10), 0.001)

    noteTweenY("defaultPlayerStrumY0", 4, defaultPlayerStrumY0 - getProperty('shitty.y') * math.cos((currentBeat + 1) * 10), 0.001)
    noteTweenY("defaultPlayerStrumY1", 5, defaultPlayerStrumY1 - getProperty('shitty.y') * math.cos((currentBeat + 2) * 10), 0.001)
    noteTweenY("defaultPlayerStrumY2", 6, defaultPlayerStrumY2 - getProperty('shitty.y') * math.cos((currentBeat + 3) * 10), 0.001)
    noteTweenY("defaultPlayerStrumY3", 7, defaultPlayerStrumY3 - getProperty('shitty.y') * math.cos((currentBeat + 4) * 10), 0.001)

    setProperty('camHUD.angle', getProperty('shitty2.y') * math.sin((currentBeat + 1) * 10), 0.001)
end