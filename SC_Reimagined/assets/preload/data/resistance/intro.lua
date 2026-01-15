function onCreatePost()
	makeLuaSprite("shitsAss","blackscreen",-10,-10)
	setObjectCamera("shitsAss",'other') -- 'other' for in front of hud, 'hud' to be on it i think i forgor

	addLuaSprite("shitsAss",true)
	setProperty("shitsAss.alpha",1)
	scaleObject('shitsAss', 10, 10)

    makeLuaSprite('ec2','expunged/old/OppositonLol',-500, -300)
    setObjectCamera("ec2",'other')
	addLuaSprite('ec2',false)
    addGlitchEffect('ec2', 2,5,0.1);
	setLuaSpriteScrollFactor('ec2', 0, 0)
end

function onSongStart()
	doTweenAlpha("DARKBANG","shitsAss",0,7)
end

function onUpdate(elapsed)
    if curBeat == 70 then 
        removeLuaSprite('ec2')
    end
end