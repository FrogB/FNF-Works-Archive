

function onCreate()

	makeLuaSprite('theBg','conbi/cone',-1800, -600);
	setScrollFactor('theBg', 0.3, 0.3)
	addGlitchEffect('theBg', 1, 5, 0.1)
	addLuaSprite('theBg', false);

	makeLuaSprite('platform2', 'conbi/platform', 750, 1150);
	setScrollFactor('platform2', 1, 1);
	scaleObject('platform2', 0.3, 0.3);
	doTweenColor('platform2', 'platform2', '301934' , 0.1, 'linear');
	addLuaSprite('platform2', false);
end

function onUpdate()
	songPos = getSongPosition()
	currentBeat = (songPos/1000)*(bpm/80)
	setProperty("gf.scale.x",0.3)
	setProperty("gf.scale.y",0.3)
	setProperty("gf.y",150+math.sin(currentBeat*math.pi/16)*200)
	setProperty("gf.x",-1500+math.fmod(currentBeat*100,3300))
	setProperty("gf.angle",currentBeat*10)
end


