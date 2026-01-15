function onCreate()
    setProperty('camGame.zoom', 0.2)
    setProperty('camHUD.alpha', 0)
end

function onCreatePost()
    makeLuaSprite("shitsAss","blackscreen",-10,-10)
	setObjectCamera("shitsAss",'other') -- 'other' for in front of hud, 'hud' to be on it i think i forgor

	addLuaSprite("shitsAss",true)
	setProperty("shitsAss.alpha",1)
	scaleObject('shitsAss', 10, 10)
end

function onSongStart()
    doTweenAlpha("DARKBANG","shitsAss",0,5)
    doTweenZoom('BEGIN', 'camGame', '0.4', 7, 'quadOut')
end

function onUpdate(elapsed)
    if curStep == 496 then 
        setProperty('camHUD.alpha', 0.2)
    end
    if curStep == 498 then
        setProperty('camHUD.alpha', 0.4)
    end
    if curStep == 502 then
        setProperty('camHUD.alpha', 0.6)
    end
    if curStep == 504 then
        setProperty('camHUD.alpha', 0.8)
    end
    if curStep == 508 then
        setProperty('camHUD.alpha', 1)
    end
end