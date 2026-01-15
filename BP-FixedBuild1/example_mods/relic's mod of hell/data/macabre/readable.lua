
function onCreate()
    makeLuaText('dis', "Macabre - Teey3l", -600, -65, 30)
    setTextSize('dis', 40)
    setTextColor('dis', 'FF00FF')
    addLuaText('dis',true)
end

function onSongStart()
    makeLuaSprite('noteBG','',400,-300)
    makeGraphic('noteBG',480,3000,'000000')
    setObjectCamera('noteBG','HUD')
    addLuaSprite('noteBG',false)
    setProperty('noteBG.alpha', 0)
    doTweenAlpha('noteBGShow','noteBG',1,crochet*0.016,'expoIn')
end
function onBeatHit()
    floorStep = math.floor(currentStep)
    if floorStep == 2112 then
        for i = 4,7 do
            noteTweenAlpha('bruh'..i,i,0,crochet*0.004,'linear')
        end 
        doTweenX('showscoreX','scoreTxt',0,crochet*0.008,'expoOut')
        doTweenY('showscoreY','scoreTxt',200,crochet*0.008,'expoOut')
    end
end
function onUpdatePost()
    songPos = getSongPosition()
    currentStep = (songPos/1000)*(curBpm/15)
    setProperty('timeBar.alpha',0)
    setProperty('timeBarBG.alpha',0)
    setProperty('timeTxt.alpha',0)
    if currentStep > 64 and currentStep < 2112 then
    setProperty('scoreTxt.scale.x',1*(1+(math.floor(currentStep/8)-currentStep/8)*0.1))
    setProperty('scoreTxt.scale.y',1*(1+(math.floor(currentStep/8)-currentStep/8)*0.1))
    setProperty('scoreTxt.angle',math.sin(currentStep*math.pi/8)*2)
    setProperty('dis.scale.x',1*(1+(math.floor(currentStep/8)-currentStep/8)*0.1))
    setProperty('dis.scale.y',1*(1+(math.floor(currentStep/8)-currentStep/8)*0.1))
    setProperty('dis.angle',math.sin(currentStep*math.pi/8)*2)
    end
    if currentStep < 2112 then
        setProperty('scoreTxt.x',-520)
        setProperty('scoreTxt.y',0)
    else
        setProperty('scoreTxt.scale.x',2)
        setProperty('scoreTxt.scale.y',2)
    end
      setProperty('camHUD.zoom',0.8)
      for i = 0,3 do
        setPropertyFromGroup('strumLineNotes',i,'alpha',0.2)
        setPropertyFromGroup('strumLineNotes',i,'x',-20+(i+4)*110)
        setPropertyFromGroup('strumLineNotes',i,'y',-90)
      end
      for i = 4,7 do
        setPropertyFromGroup('strumLineNotes',i,'x',-20+i*110)
        setPropertyFromGroup('strumLineNotes',i,'y',-90)
      end
end