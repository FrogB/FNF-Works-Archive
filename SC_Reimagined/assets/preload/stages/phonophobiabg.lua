function onCreate()
	makeLuaSprite('ec','expunged/Phono',-1300, -700)
	addLuaSprite('ec',false)
    addGlitchEffect('ec', 5,100,0.1);
	setLuaSpriteScrollFactor('ec', 0.1, 0.1)

    scaleObject('ec', 2, 2)
	makeLuaSprite('ecfloor','expunged/ThanosGround', -450, 400)
	addLuaSprite('ecfloor',false)
	setLuaSpriteScrollFactor('ecfloor', 1, 1)
	addGlitchEffect('ecfloor', 1,50,0.1);
    scaleObject('ecfloor', 1, 1)
end