function onCreate()
	if songName == 'THEARCHY' then
		makeLuaSprite('thearchyRedFUCKER','REDFLASH',0,0)
		setObjectCamera('thearchyRedFUCKER','hud')
		setBlendMode('thearchyRedFUCKER','add')
		addLuaSprite('thearchyRedFUCKER',false)
		setProperty('thearchyRedFUCKER.alpha',0)
	end
end
function onEvent(name,value1,value2)
    if name == 'thearchyRedFlash' then
		if value1 == '' and value2 == '' then
			cancelTween('thearchyRedFUCKERTWEENFUCKER')
			setProperty('thearchyRedFUCKER.alpha',1)
			doTweenAlpha('thearchyRedFUCKERTWEENFUCKER','thearchyRedFUCKER',0,0.4,'sineOut')
		end
	end
end