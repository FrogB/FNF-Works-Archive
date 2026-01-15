function onCreate()
    setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-death'); --Character json file for the death animation
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'noth'); --put in mods/sounds/
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'noth'); --put in mods/music/
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'noth'); --put in mods/music/
    
end