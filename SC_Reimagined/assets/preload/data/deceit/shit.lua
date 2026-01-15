function onCreatePost()
	makeLuaSprite("shitsAss","blackscreen",-10,-10)
	setObjectCamera("shitsAss",'other') -- 'other' for in front of hud, 'hud' to be on it i think i forgor

	addLuaSprite("shitsAss",true)
	setProperty("shitsAss.alpha",1)
	scaleObject('shitsAss', 10, 10)
end

function onSongStart()
	doTweenAlpha("DARKBANG","shitsAss",0,5)
end