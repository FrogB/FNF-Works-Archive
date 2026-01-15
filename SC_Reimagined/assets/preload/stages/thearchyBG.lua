function onCreate()
	makeLuaSprite('ec','expunged/OppositonLol',-1300, -700)
	addLuaSprite('ec',false)
    addGlitchEffect('ec', 3,25,0.1);
	setLuaSpriteScrollFactor('ec', 0.2, 0.2)

    scaleObject('ec', 2, 2)
	makeLuaSprite('ecfloor','expunged/ThanosGround', -450, 650)
	addLuaSprite('ecfloor',false)
	setLuaSpriteScrollFactor('ecfloor', 1, 1)
    scaleObject('ecfloor', 1, 1)
end