
function onCreate()
	makeLuaSprite('bg','nimbi/spam',-1000, -500)
	addLuaSprite('bg',false)
	setLuaSpriteScrollFactor('bg', 0, 0)
	scaleObject('bg', 1.3, 1.3)
	addGlitchEffect('bg', 2, 5, 0.1)
end
