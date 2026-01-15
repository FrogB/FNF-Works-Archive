

function onCreate()

	makeLuaSprite('theBg','expunged/cheater',-1600,-800)
	addLuaSprite('theBg',false)
	setLuaSpriteScrollFactor('theBg', 1, 1)
	scaleObject('theBg', 1.8, 1.8)
	addGlitchEffect('theBg', 2, 10, 0.1)
end

function onUpdate()
	songPos = getSongPosition()
	currentBeat = (songPos/1000)*(bpm/80)
	setProperty("gf.scale.x",0.3)
	setProperty("gf.scale.y",0.3)
	setProperty("gf.y",150+math.sin(currentBeat*math.pi/16)*200)
	setProperty("gf.x",-1500+math.fmod(currentBeat*100,3300))
	setProperty("gf.angle",currentBeat*10)

	local currentBeat2 = (songPos/5000)*(curBpm/130)
	
	doTweenY('playermove', 'boyfriend', 350 - 350*math.sin((currentBeat2+5*10)*math.pi), 2)
	doTweenAngle('turnp', 'boyfriend', 0 - 15*math.sin((currentBeat2+10*5)*math.pi), 0.2, 'cubeOut')
	
	doTweenY('opponentmove', 'dad', 350 - 350*math.sin((currentBeat2+5*20)*math.pi), 2)
	doTweenAngle('turnd', 'dad', 0 + 15*math.sin((currentBeat2+10*5)*math.pi), 0.2, 'cubeOut')
end


