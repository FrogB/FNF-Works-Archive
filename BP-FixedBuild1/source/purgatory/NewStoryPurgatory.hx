package purgatory;

#if desktop
import Discord.DiscordClient;
#end
import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import flixel.group.FlxSpriteGroup;
import openfl.Lib;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import purgatory.PurMainMenuState;
import purgatory.PurWeekData;

class NewStoryPurgatory extends MusicBeatState
{
	var bg:FlxSprite = new FlxSprite(0).loadGraphic(PurMainMenuState.randomizeBG());
	var slidething:FlxBackdrop;
	var grid:FlxBackdrop;
	var spikeys:FlxBackdrop;
	var line:FlxSprite;
	var glow:FlxSprite;
	var week1:FlxSprite;
	var o:FlxSprite;
	var lol:Bool = false;
	var sex:FlxSprite;
	var canExit:Bool = true;
	var week1text:FlxText;
	var week2text:FlxText;
	var week2:FlxSprite;
	var week3:FlxSprite;
	var week3text:FlxText;
	var arrowshit:FlxSprite;
	var menuItems:FlxTypedGroup<FlxSprite>;
	var text:FlxText;
	var text2:FlxText;

	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();
	
	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In Purgatory Menu", null);
		#end

		#if android
		addVirtualPad(FULL, A_B_X_Y);
		addPadCamera();
		#end
		
		super.create();

		FlxG.mouse.visible = true;
		
		bg.loadGraphic(PurMainMenuState.randomizeBG());
		bg.color = 0xFF420000;
		add(bg);

		var checker:FlxBackdrop;
		checker = new FlxBackdrop(Paths.image('purgatoryui/check'),1, 0, true, true);
		checker.velocity.set(100, 51);
		checker.updateHitbox();
		checker.screenCenter(X);
		checker.alpha = 0.5;
		add(checker);

		var ok:FlxSprite = new FlxSprite().loadGraphic(Paths.image('purgatoryui/glow'));
		ok.scrollFactor.set();
		ok.updateHitbox();
		ok.screenCenter();
		ok.antialiasing = ClientPrefs.globalAntialiasing;
		add(ok);

		var line:FlxSprite = new FlxSprite().loadGraphic(Paths.image('purgatoryui/line'));
		line.scrollFactor.set();
		line.updateHitbox();
		line.screenCenter();
		line.antialiasing = ClientPrefs.globalAntialiasing;
		add(line);

		var slider:FlxBackdrop;
		slider = new FlxBackdrop(Paths.image('purgatoryui/hahaslider'), 1, 0, true, false);
		slider.velocity.set(-14, 0);
		slider.updateHitbox();
		slider.x = -20;
		slider.y = 250;
		slider.setGraphicSize(Std.int(slider.width * 0.65));
		add(slider);

		var spikes:FlxBackdrop;
		spikes = new FlxBackdrop(Paths.image('purgatoryui/spikeys'),1, 0, true, false);
		spikes.velocity.set(100, 0);
		spikes.updateHitbox();
		spikes.screenCenter(X);
		add(spikes);
		
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		
		week1 = new FlxSprite(100, 70).loadGraphic(Paths.image('purgatoryweeks/story1'));
		week1.scale.set(0.8, 0.8);
		week1.updateHitbox();
		week1.antialiasing = ClientPrefs.globalAntialiasing;
		menuItems.add(week1);
		
		week1text = new FlxText(80, 480, 320, "Rage\n" + "Week\n");
		week1text.setFormat(Paths.font("comic-sans.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		week1text.scrollFactor.set();
		week1text.borderSize = 3.25;
		week1text.visible = true;
		menuItems.add(week1text);
		
		week2 = new FlxSprite(500, 70).loadGraphic(Paths.image('purgatoryweeks/story2'));
		week2.scale.set(0.8, 0.8);
		week2.updateHitbox();
		week2.antialiasing = ClientPrefs.globalAntialiasing;
		menuItems.add(week2);
		
		week2text = new FlxText(480, 480, 320, "Hell\n" + "Week\n");
		week2text.setFormat(Paths.font("comic-sans.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		week2text.scrollFactor.set();
		week2text.borderSize = 3.25;
		week2text.visible = true;
		menuItems.add(week2text);
		
		week3 = new FlxSprite(900, 70).loadGraphic(Paths.image('purgatoryweeks/story3'));
		week3.scale.set(0.8, 0.8);
		week3.updateHitbox();
		week3.antialiasing = ClientPrefs.globalAntialiasing;
		menuItems.add(week3);
		
		week3text = new FlxText(880, 480, 320, "Dave's\n" + "Rematch\n");
		week3text.setFormat(Paths.font("comic-sans.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		week3text.scrollFactor.set();
		week3text.borderSize = 3.25;
		week3text.visible = true;
		menuItems.add(week3text);
		
		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 46).makeGraphic(FlxG.width, 56, 0xFF000000);
		textBG.alpha = 0.6;
		menuItems.add(textBG);
		var leText:String = "Use your mouse to select a week.";
		text = new FlxText(textBG.x + -10, textBG.y + 3, FlxG.width, leText, 21);
		text.setFormat(Paths.font("comic-sans.ttf"), 18, FlxColor.WHITE, CENTER);
		text.scrollFactor.set();
		menuItems.add(text);

		var leText2:String = "Press CTRL to open the Gameplay Modifier Menu";
		text2 = new FlxText(10, 690, 0, leText2, 21);
		text2.setFormat(Paths.font("comic-sans.ttf"), 18, FlxColor.WHITE, LEFT);
		text2.scrollFactor.set();
		menuItems.add(text2);
		
		arrowshit = new FlxSprite(-80).loadGraphic(Paths.image('stupidarrows'));
		arrowshit.setGraphicSize(Std.int(arrowshit.width * 1));
		arrowshit.updateHitbox();
		arrowshit.screenCenter();
		arrowshit.antialiasing = ClientPrefs.globalAntialiasing;
		menuItems.add(arrowshit);
		
	}
	  override public function update(elapsed:Float)
	  {
		  
		var clicked = FlxG.mouse.overlaps(week1) && FlxG.mouse.justPressed && !lol;
		
		if (clicked)
		{
			lol = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxG.mouse.visible = false;
			startSong('shattered/shattered-hard', 'supplanted', 'reality breaking');	
		}

		var clicked = FlxG.mouse.overlaps(week2) && FlxG.mouse.justPressed && !lol;
		
		if (clicked)
		{
			lol = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxG.mouse.visible = false;
			startSong2('rebound/rebound-hard', 'disposition', 'upheaval');	
		}
		
		var clicked = FlxG.mouse.overlaps(week3) && FlxG.mouse.justPressed && !lol;
		
		if (clicked)
		{
			lol = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxG.mouse.visible = false;
			startSong3('roundabout/roundabout-hard', 'rascal');	
		}

		if(controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.mouse.visible = false;
			MusicBeatState.switchState(new PurMainMenuState());
				
		}

		if(FlxG.keys.justPressed.CONTROL)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		
		if (controls.UI_RIGHT_P)
		{
			openSubState(new Section2Substate());
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}

		// "Disabled for Part 1. - Relic" MAN SHUT YO STUPID-
		
		super.update(elapsed);
	  }
	  
    function startSong(songName1:String, songName2:String, songName3:String)
    {
	   FlxFlicker.flicker(week1, 1, 0.06, false, false, function(flick:FlxFlicker)
	   {
	    PlayState.storyPlaylist = [songName1, songName2, songName3];
		PlayState.isStoryMode = false;
		PlayState.isFreeplay = false;
		PlayState.isFreeplayPur = false;
		PlayState.isPurStoryMode = true;
	    PlayState.storyWeek = 2;
	    PlayState.storyDifficulty = 2;
	    PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0], '');
	    PlayState.campaignScore = 0;
	    PlayState.campaignMisses = 0;
	    FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
	    FlxTween.tween(bg, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
	    FlxTween.tween(bg, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
	    menuItems.forEach(function(spr:FlxSprite) {
	    FlxTween.tween(spr, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    spr.kill();
		    }
	      });
       });
	    new FlxTimer().start(1, function(tmr:FlxTimer)
	    {
		    LoadingState.loadAndSwitchState(new PlayState());
	    });
	   });
	}

	function startSong2(songName1:String, songName2:String, songName3:String)
    {
	   FlxFlicker.flicker(week2, 1, 0.06, false, false, function(flick:FlxFlicker)
	   {
	    PlayState.storyPlaylist = [songName1, songName2, songName3];
		PlayState.isStoryMode = false;
		PlayState.isFreeplay = false;
		PlayState.isFreeplayPur = false;
		PlayState.isPurStoryMode = true;
	    PlayState.storyWeek = 2;
	    PlayState.storyDifficulty = 2;
	    PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0], '');
	    PlayState.campaignScore = 0;
	    PlayState.campaignMisses = 0;
	    FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
	    FlxTween.tween(bg, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
	    FlxTween.tween(bg, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
	    menuItems.forEach(function(spr:FlxSprite) {
	    FlxTween.tween(spr, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    spr.kill();
		    }
	      });
       });
	    new FlxTimer().start(1, function(tmr:FlxTimer)
	    {
		    LoadingState.loadAndSwitchState(new PlayState());
	    });
	   });
	}

	function startSong3(songName1:String, songName2:String)
    {
	   FlxFlicker.flicker(week3, 1, 0.06, false, false, function(flick:FlxFlicker)
	   {
	    PlayState.storyPlaylist = [songName1, songName2];
		PlayState.isStoryMode = false;
		PlayState.isFreeplay = false;
		PlayState.isFreeplayPur = false;
		PlayState.isPurStoryMode = true;
	    PlayState.storyWeek = 2;
	    PlayState.storyDifficulty = 2;
	    PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0], '');
	    PlayState.campaignScore = 0;
	    PlayState.campaignMisses = 0;
	    FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
	    FlxTween.tween(bg, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
	    FlxTween.tween(bg, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
	    menuItems.forEach(function(spr:FlxSprite) {
	    FlxTween.tween(spr, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    spr.kill();
		    }
	      });
       });
	    new FlxTimer().start(1, function(tmr:FlxTimer)
	    {
		    LoadingState.loadAndSwitchState(new PlayState());
	    });
	   });
	}

	function weekIsLocked(weekNum:Int) {
		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[weekNum]);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}
}


class Section2Substate extends MusicBeatSubstate
{
	
	var arrowshitSub:FlxSprite;
	var menuItemsSub:FlxTypedGroup<FlxSprite>;
	var bgSub:FlxSprite = new FlxSprite(0).loadGraphic(PurMainMenuState.randomizeBG());
	var slidethingSub:FlxBackdrop;
	var gridSub:FlxBackdrop;
	var spikeysSub:FlxBackdrop;
	var lineSub:FlxSprite;
	var glowSub:FlxSprite;
	var lol:Bool = false;
	var text:FlxText;
	var text2:FlxText;
	var menuItems:FlxTypedGroup<FlxSprite>;
	var week4:FlxSprite;
	var week5:FlxSprite;
	var week4text:FlxText;
	var week5text:FlxText;
	var week6:FlxSprite;
	var week6text:FlxText;

	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();
	
	public function new() {
		super();
		
		bgSub.loadGraphic(PurMainMenuState.randomizeBG());
		bgSub.color = 0xFF420000;
		add(bgSub);

		var checkerSub:FlxBackdrop;
		checkerSub = new FlxBackdrop(Paths.image('purgatoryui/check'),1, 0, true, true);
		checkerSub.velocity.set(100, 51);
		checkerSub.updateHitbox();
		checkerSub.screenCenter(X);
		checkerSub.alpha = 0.5;
		add(checkerSub);

		var okSub:FlxSprite = new FlxSprite().loadGraphic(Paths.image('purgatoryui/glow'));
		okSub.scrollFactor.set();
		okSub.updateHitbox();
		okSub.screenCenter();
		okSub.antialiasing = ClientPrefs.globalAntialiasing;
		add(okSub);

		var lineSub:FlxSprite = new FlxSprite().loadGraphic(Paths.image('purgatoryui/line'));
		lineSub.scrollFactor.set();
		lineSub.updateHitbox();
		lineSub.screenCenter();
		lineSub.antialiasing = ClientPrefs.globalAntialiasing;
		add(lineSub);

		var sliderSub:FlxBackdrop;
		sliderSub = new FlxBackdrop(Paths.image('purgatoryui/hahaslider'), 1, 0, true, false);
		sliderSub.velocity.set(-14, 0);
		sliderSub.updateHitbox();
		sliderSub.x = -20;
		sliderSub.y = 250;
		sliderSub.setGraphicSize(Std.int(sliderSub.width * 0.65));
		add(sliderSub);

		var spikesSub:FlxBackdrop;
		spikesSub = new FlxBackdrop(Paths.image('purgatoryui/spikeys'),1, 0, true, false);
		spikesSub.velocity.set(100, 0);
		spikesSub.updateHitbox();
		spikesSub.screenCenter(X);
		add(spikesSub);
		
		menuItemsSub = new FlxTypedGroup<FlxSprite>();
		add(menuItemsSub);
		
		week4 = new FlxSprite(100, 70).loadGraphic(Paths.image('purgatoryweeks/story4'));
		week4.scale.set(0.8, 0.8);
		week4.updateHitbox();
		week4.antialiasing = ClientPrefs.globalAntialiasing;
		menuItemsSub.add(week4);
		
		week4text = new FlxText(80, 480, 320, "Crusti and\n" + "Poip/Paulp Week\n");
		week4text.setFormat(Paths.font("comic-sans.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		week4text.scrollFactor.set();
		week4text.borderSize = 3.25;
		week4text.visible = true;
		menuItemsSub.add(week4text);
		
		week5 = new FlxSprite(500, 70).loadGraphic(Paths.image('purgatoryweeks/story5'));
		week5.scale.set(0.8, 0.8);
		week5.updateHitbox();
		week5.antialiasing = ClientPrefs.globalAntialiasing;
		menuItemsSub.add(week5);
		
		week5text = new FlxText(480, 480, 320, "The\n" + "Trio Week\n");
		week5text.setFormat(Paths.font("comic-sans.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		week5text.scrollFactor.set();
		week5text.borderSize = 3.25;
		week5text.visible = true;
		menuItemsSub.add(week5text);
		
		week6 = new FlxSprite(900, 70).loadGraphic(Paths.image('purgatoryweeks/story6'));
		week6.scale.set(0.8, 0.8);
		week6.updateHitbox();
		week6.antialiasing = ClientPrefs.globalAntialiasing;
		menuItemsSub.add(week6);
		
		week6text = new FlxText(880, 480, 320, "Vs\n" + "Expunged\n");
		week6text.setFormat(Paths.font("comic-sans.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		week6text.scrollFactor.set();
		week6text.borderSize = 3.25;
		week6text.visible = true;
		menuItemsSub.add(week6text);
		
		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 46).makeGraphic(FlxG.width, 56, 0xFF000000);
		textBG.alpha = 0.6;
		menuItemsSub.add(textBG);
		var leText:String = "Use your mouse to select a week.";
		text = new FlxText(textBG.x + -10, textBG.y + 3, FlxG.width, leText, 21);
		text.setFormat(Paths.font("comic-sans.ttf"), 18, FlxColor.WHITE, CENTER);
		text.scrollFactor.set();
		menuItemsSub.add(text);

		var leText2:String = "Press CTRL to open the Gameplay Modifier Menu";
		text2 = new FlxText(10, 690, 0, leText2, 21);
		text2.setFormat(Paths.font("comic-sans.ttf"), 18, FlxColor.WHITE, LEFT);
		text2.scrollFactor.set();
		menuItemsSub.add(text2);
		
		arrowshitSub = new FlxSprite(-80).loadGraphic(Paths.image('stupidarrows'));
		arrowshitSub.setGraphicSize(Std.int(arrowshitSub.width * 1));
		arrowshitSub.updateHitbox();
		arrowshitSub.screenCenter();
		arrowshitSub.antialiasing = ClientPrefs.globalAntialiasing;
		menuItemsSub.add(arrowshitSub);
	}
	
	override function update(elapsed:Float)
	{

		var clicked = FlxG.mouse.overlaps(week4) && FlxG.mouse.justPressed && !lol;
		
		if (clicked)
		{
			lol = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxG.mouse.visible = false;
			startSong4('acquaintance/acquaintance-hard');	
		}

		var clicked = FlxG.mouse.overlaps(week5) && FlxG.mouse.justPressed && !lol;
		
		if (clicked)
		{
			lol = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxG.mouse.visible = false;
			startSong5("beefin'/beefin'-hard", 'technology', 'devastation');	
		}
		
		var clicked = FlxG.mouse.overlaps(week6) && FlxG.mouse.justPressed && !lol;
		
		if (clicked)
		{
			lol = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxG.mouse.visible = false;
			startSong6('antagonism/antagonism-hard');
		}

		if (controls.UI_LEFT_P)
		{
			close();
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}

		if(FlxG.keys.justPressed.CONTROL)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		
		if(controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.mouse.visible = false;
			MusicBeatState.switchState(new PurMainMenuState());
				
		}
		
		super.update(elapsed);
	}

	function startSong4(songName1:String)
    {
	   FlxFlicker.flicker(week4, 1, 0.06, false, false, function(flick:FlxFlicker)
	   {
	    PlayState.storyPlaylist = [songName1];
		PlayState.isStoryMode = false;
		PlayState.isFreeplay = false;
		PlayState.isFreeplayPur = false;
		PlayState.isPurStoryMode = true;
	    PlayState.storyWeek = 2;
	    PlayState.storyDifficulty = 2;
	    PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0], '');
	    PlayState.campaignScore = 0;
	    PlayState.campaignMisses = 0;
	    FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
	    FlxTween.tween(bgSub, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
	    FlxTween.tween(bgSub, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
	    menuItemsSub.forEach(function(spr:FlxSprite) {
	    FlxTween.tween(spr, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    spr.kill();
		    }
	      });
       });
	    new FlxTimer().start(1, function(tmr:FlxTimer)
	    {
		    LoadingState.loadAndSwitchState(new PlayState());
	    });
	   });
	}

	function startSong5(songName1:String, songName2:String, songName3:String)
    {
	   FlxFlicker.flicker(week5, 1, 0.06, false, false, function(flick:FlxFlicker)
	   {
	    PlayState.storyPlaylist = [songName1, songName2, songName3];
		PlayState.isStoryMode = false;
		PlayState.isFreeplay = false;
		PlayState.isFreeplayPur = false;
		PlayState.isPurStoryMode = true;
	    PlayState.storyWeek = 2;
	    PlayState.storyDifficulty = 2;
	    PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0], '');
	    PlayState.campaignScore = 0;
	    PlayState.campaignMisses = 0;
	    FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
	    FlxTween.tween(bgSub, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
	    FlxTween.tween(bgSub, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
	    menuItemsSub.forEach(function(spr:FlxSprite) {
	    FlxTween.tween(spr, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    spr.kill();
		    }
	      });
       });
	    new FlxTimer().start(1, function(tmr:FlxTimer)
	    {
		    LoadingState.loadAndSwitchState(new PlayState());
	    });
	   });
	}

	function startSong6(songName1:String)
    {
	   FlxFlicker.flicker(week6, 1, 0.06, false, false, function(flick:FlxFlicker)
	   {
	    PlayState.storyPlaylist = [songName1];
		PlayState.isStoryMode = false;
		PlayState.isFreeplay = false;
		PlayState.isFreeplayPur = false;
		PlayState.isPurStoryMode = true;
	    PlayState.storyWeek = 2;
	    PlayState.storyDifficulty = 2;
	    PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0], '');
	    PlayState.campaignScore = 0;
	    PlayState.campaignMisses = 0;
	    FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
	    FlxTween.tween(bgSub, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
	    FlxTween.tween(bgSub, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
	    menuItemsSub.forEach(function(spr:FlxSprite) {
	    FlxTween.tween(spr, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    spr.kill();
		    }
	      });
       });
	    new FlxTimer().start(1, function(tmr:FlxTimer)
	    {
		    LoadingState.loadAndSwitchState(new PlayState());
	    });
	   });
	}

	function weekIsLocked(weekNum:Int) {
		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[weekNum]);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}
}
