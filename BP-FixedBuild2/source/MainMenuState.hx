package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxBackdrop;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var BPVersion:String = '1.0'; //This is also used for Discord RPC
	public static var psychEngineVersion:String = '0.6.3'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'options',
		'credits',
		'gallery',
		#if ACHIEVEMENTS_ALLOWED 'awards' #end
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	var logo:FlxSprite;
	var fuck:FlxSprite;

	public static var bgPaths:Array<String> = 
	[
		'backgrounds/arandomguy',
		'backgrounds/cesars',
		'backgrounds/cheesedjelly',
		'backgrounds/darealmatt',
		'backgrounds/darlyboxman',
		'backgrounds/doodoofeces',
		'backgrounds/fast_f00d',
		'backgrounds/ion',
		'backgrounds/isaaclul',
		'backgrounds/kanandraw',
		'backgrounds/mmimim',
		'backgrounds/osp',
		'backgrounds/Senza_titolo_200_20230711092018',
		'backgrounds/Senza_titolo_201_20230711093117',
		'backgrounds/slushX',
		'backgrounds/spitz',
		'backgrounds/tamrika',
		'backgrounds/ultimate poop',
		'backgrounds/ultimate poop2',
		'backgrounds/voltrex',
		'backgrounds/watch_out',
		'backgrounds/zevisly',
	]; 

	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(randomizeBG());
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.color = 0xFF3F0000;

		
		var checker:FlxBackdrop;
		checker = new FlxBackdrop(Paths.image('uilol/check'), 1, 0, true, true);
		checker.velocity.set(100, 51);
		checker.updateHitbox();
		checker.screenCenter(X);
		checker.alpha = 0.5;
		add(checker);

		var ok:FlxSprite = new FlxSprite().loadGraphic(Paths.image('uilol/glow'));
		ok.scrollFactor.set();
		ok.updateHitbox();
		ok.screenCenter();
		ok.antialiasing = ClientPrefs.globalAntialiasing;
		add(ok);

		var line:FlxSprite = new FlxSprite().loadGraphic(Paths.image('uilol/line'));
		line.scrollFactor.set();
		line.updateHitbox();
		line.screenCenter();
		line.antialiasing = ClientPrefs.globalAntialiasing;
		add(line);

		var slider:FlxBackdrop;
		slider = new FlxBackdrop(Paths.image('uilol/hahaslider'), 1, 0, true, false);
		slider.velocity.set(-14, 0);
		slider.updateHitbox();
		slider.x = -20;
		slider.y = 150;
		slider.setGraphicSize(Std.int(slider.width * 0.65));
		add(slider);

		var spikes:FlxBackdrop;
		spikes = new FlxBackdrop(Paths.image('uilol/spikeys'),X);
		spikes.velocity.set(100, 0);
		spikes.updateHitbox();
		spikes.screenCenter(X);
		add(spikes);

		fuck = new FlxSprite().loadGraphic(Paths.image('uilol/funny'));
		fuck.scrollFactor.set();
		fuck.updateHitbox();
		fuck.screenCenter();
		fuck.antialiasing = ClientPrefs.globalAntialiasing;
		add(fuck);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			FlxG.mouse.visible = true;
			
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, 0);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();

			switch (i)
			{
				case 0: 
					menuItem.y = 193.75;
					menuItem.x = 716.5;

				case 1: 
					menuItem.y = 313;
					menuItem.x = 776.5;

				case 2:
					menuItem.y = 422.25;
					menuItem.x = 826.5;

				case 3:
					menuItem.x = 872.9;
					menuItem.y = 521.5;

				case 4:
					menuItem.x = 1023;
					menuItem.y = 521.5;

				case 5:
					menuItem.x = 1142.9;
					menuItem.y = 521.5;

			}
		}


		var versionShit:FlxText = new FlxText(12, FlxG.height - 64, 0, "Bambi's Purgatory v" + BPVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		logo = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.updateHitbox();
		logo.screenCenter();
		logo.antialiasing = ClientPrefs.globalAntialiasing;
		add(logo);
		logo.scale.set(0.6, 0.6);
		logo.x += 350;
		logo.y -= 250;

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{

			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			/*if (FlxG.mouse.pressed)
				{
					if (optionShit[curSelected] == 'donate')
					{
						CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
					}
					else
					{
						selectedSomethin = true;
						FlxG.sound.play(Paths.sound('confirmMenu'));
	
	
						menuItems.forEach(function(spr:FlxSprite)
						{
							if (curSelected != spr.ID)
							{
								FlxTween.tween(spr, {alpha: 0}, 0.4, {
									ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween)
									{
										spr.kill();
									}
								});
							}
							else
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									var daChoice:String = optionShit[curSelected];
	
									switch (daChoice)
									{
										case 'story_mode':
											MusicBeatState.switchState(new StoryMenuState());
										case 'freeplay':
											MusicBeatState.switchState(new CategoryState());
										#if MODS_ALLOWED
										case 'mods':
											MusicBeatState.switchState(new ModsMenuState());
										#end
										case 'awards':
											MusicBeatState.switchState(new AchievementsMenuState());
										case 'credits':
											MusicBeatState.switchState(new CreditsState());
										case 'gallery':
											MusicBeatState.switchState(new CreditsState());
										case 'options':
											LoadingState.loadAndSwitchState(new options.OptionsState());
									}
								});
							}
						});
					}
				}
				*/

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					FlxTween.tween(FlxG.camera, {zoom: 5}, 2.5, {ease: FlxEase.expoInOut});

					FlxTween.tween(fuck, {x: fuck.x + 600}, 1.5, {ease: FlxEase.expoInOut, type: ONESHOT});

					FlxTween.tween(logo, {x: logo.x + 600}, 1.5, {ease: FlxEase.expoInOut, type: ONESHOT});

					FlxTween.tween(logo, {alpha: 0}, 1, {ease: FlxEase.expoInOut, type: ONESHOT});
					FlxTween.tween(fuck, {alpha: 0}, 1, {ease: FlxEase.expoInOut, type: ONESHOT});

					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));


					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {x: spr.x + 3050}, 1, {ease: FlxEase.expoInOut, type: ONESHOT});
							FlxTween.tween(spr, {alpha: 0}, 1, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new CategoryState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'gallery':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
	public static function randomizeBG():flixel.system.FlxAssets.FlxGraphicAsset
		{
			var chance:Int = FlxG.random.int(0, bgPaths.length - 1);
			return Paths.image(bgPaths[chance]);
		}
}
