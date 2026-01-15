function onCreatePost()
	makeLuaSprite("shitsAss","blackscreen",-10,-10)
	setObjectCamera("shitsAss",'other') -- 'other' for in front of hud, 'hud' to be on it i think i forgor
	addLuaSprite("shitsAss",true)
	setProperty("shitsAss.alpha",0)
	scaleObject('shitsAss', 10, 10)
end

function onEvent(name, value1, value2)
	if name == "FadeScreen" then
		doTweenAlpha("shitScreenFade","shitsAss",value1,value2)
		--hi viv :)
	end
end