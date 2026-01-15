dalapsed = 0.0;
nightColor = '878787'
function onCreate()
	makeLuaSprite('stars','bamb/Bg_Stars',-1800, -600)
	scaleObject('stars', 2, 2)
	addLuaSprite('stars',false)
    addGlitchEffect('stars', 2,5,0.1); --lmao
	setLuaSpriteScrollFactor('stars', 0.1, 0.1)

    makeLuaSprite('planet','bamb/Bg_Planet', -6000, -80)
	scaleObject('planet', 2.5, 2.5)
	addLuaSprite('planet',false)
	setLuaSpriteScrollFactor('planet', 0.5, 0.5)

	makeLuaSprite('cubes','bamb/Bg_Cubes',-330, -100)
	addLuaSprite('cubes',false)
	setLuaSpriteScrollFactor('cubes', 0.85, 0.85)
end

function onCreatePost()
	--ambassing
	doTweenColor('bfColor', 'boyfriend', nightColor, 0.0001);
	doTweenColor('gfColor', 'gf', nightColor, 0.0001);
	doTweenColor('dadColor', 'dad', nightColor, 0.0001);
end

function onUpdate(elapsed)
	songPos = getSongPosition()
	currentBeat = (songPos/1000)*(bpm/80)
	runHaxeCode([[
	FlxTween.tween(planet, {x:-6000}, 25, {type: FlxTweenType.LOOPING, ease: FlxEase.linear}); 
	]]) --RARE RUNHAXECODE LINE SPOTTED 
end

function onUpdatePost(elapsed)
	dalapsed = dalapsed + elapsed;

	setProperty('cubes.y', -100 - 100 * math.sin((dalapsed - 3) * 0.5));
end