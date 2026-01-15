function onCreate()
	-- background shit
	
	makeLuaSprite('room', 'birthday/BG', -500, -300);
	setScrollFactor('room', 0.2, 0.9);
	scaleObject('room', 1.5, 1.5);

	makeLuaSprite('triange', 'birthday/Hangers', -600, 0);
	setScrollFactor('triange', 0.7, 0.8);
	scaleObject('triange', 1.5, 1.5);

	makeAnimatedLuaSprite('crowdR','birthday/CrowdRight', 1050, 350)
	addAnimationByPrefix('crowdR','Crowd_Right','Crowd_Right',24,false)
	setLuaSpriteScrollFactor('crowdR', 0.9, 0.9)
	scaleObject('crowdR', 1.5, 1.5);

	makeAnimatedLuaSprite('crowdL','birthday/CrowdLeft', -300, 300)
	addAnimationByPrefix('crowdL','Crowd_Left','Crowd_Left',24,false)
	setLuaSpriteScrollFactor('crowdL', 0.9, 0.9)
	scaleObject('crowdL', 1.5, 1.5);

	makeLuaSprite('table', 'birthday/Table', 100, 500);
	setScrollFactor('table', 1, 1);
	scaleObject('table', 1.5, 1.5);

	makeLuaSprite('ballL', 'birthday/BalloonL', -350, 0);
	setScrollFactor('ballL', 1.5, 1.5);
	scaleObject('ballL', 2, 2);

	makeLuaSprite('ballR', 'birthday/BalloonR', 1300, 0);
	setScrollFactor('ballR', 1.5, 1.5);
	scaleObject('ballR', 2, 2);


	addLuaSprite('room', false);
	addLuaSprite('triange', false);
	addLuaSprite('crowdR',false);
	addLuaSprite('crowdL',false);
	addLuaSprite('table', true);
	addLuaSprite('ballL', true);
	addLuaSprite('ballR', true);


	


	function onBeatHit()-- for every beat
		if curBeat % 1 == 0 then
			objectPlayAnimation('crowdL','Crowd_Left',true)
			objectPlayAnimation('crowdR','Crowd_Right',true)
		end

	end
	
	--close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end