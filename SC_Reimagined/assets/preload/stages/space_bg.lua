function onCreate()

	makeLuaSprite('theBg','bambi/space/skye_gapple_reference', -2000, -1000)
	addLuaSprite('theBg',false)
	scaleObject('theBg', 5, 5)
	setLuaSpriteScrollFactor('theBg', 0.5, 0.5)
	addGlitchEffect('theBg', 0.1, 0.1, 0.1)

	makeLuaSprite('ground','bambi/space/land', 300, 700)
	addLuaSprite('ground',false)
	setLuaSpriteScrollFactor('ground', 1, 1)


end