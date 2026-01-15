package;

import flixel.addons.ui.FlxInputText;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.addons.effects.chainable.FlxShakeEffect;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.addons.effects.chainable.FlxEffectSprite;
import sys.FileSystem;
import flixel.util.FlxSave;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.addons.display.FlxBackdrop;
import flixel.input.keyboard.FlxKey;
#if desktop
import Discord.DiscordClient;
#end
import flixel.system.FlxSound;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story_mode', 'freeplay', 'credits', 'ost', 'options', 'discord'];

	var languagesOptions:Array<String> = [
		'Story Mode',
		'Freeplay',
		'Credits',
		'OST',
		'Options',
		'Discord Server'
	];

	var languagesDescriptions:Array<String> = [
		'Watch the story of the mod unfold as you play through fun events!',
		'Play any song of your choosing/liking and achieve new high scores!',
		'Check out all the amazing people who worked on this mod!',
		'View the entire playlist for the mod on YouTube!',
		"Tweak game settings, adjust keybinds, or customize the game's UI to your liking!",
		'Join the official Vs. Dave & Bambi Discord Server!'
	];

	public static var firstStart:Bool = true;

	public static var finishedFunnyMove:Bool = false;

	public static var sexo3:Bool = false; //sex

	public static var daRealEngineVer:String = 'Psych';
	public static var psychEngineVersion:String = '0.6.2';
	public static var curModVer:String = '1.0'; //taken from old purgatory sc forgive me lmao

	public static var engineVers:Array<String> = ['Dave', 'Bambi', 'Tristan']; // <-- so many names

	//public static var kadeEngineVer:String = "DAVE"; NO. JUST NO. PLEASE NO. FOR THE LOvE OF GOD PLEASE. NO.
	//public static var gameVer:String = "0.2.8"; gamever is alr given on project.xml lmao

	public static var canInteract:Bool = true;
	var prompt:ResetPrompt;

	var bg:FlxSprite;
	var magenta:FlxSprite;
	var selectUi:FlxSprite;
	var bigIcons:FlxSprite;
	var camFollow:FlxObject;
	var debugKeys:Array<FlxKey>;

	public static var bgPaths:Array<String> = 
	[
		'backgrounds/Aadsta',
		'backgrounds/ArtiztGmer',
		'backgrounds/DeltaKastel',
		'backgrounds/DeltaKastel2',
		'backgrounds/DeltaKastel3',
		'backgrounds/DeltaKastel4',
		'backgrounds/DeltaKastel5',
		'backgrounds/diamond man',
		'backgrounds/Jukebox',
		'backgrounds/kiazu',
		'backgrounds/Lancey',
		'backgrounds/mamakotomi',
		'backgrounds/mantis',
		'backgrounds/mepperpint',
		'backgrounds/morie',
		'backgrounds/neon',
		'backgrounds/Onuko',
		'backgrounds/ps',
		'backgrounds/ramzgaming',
		'backgrounds/ricee_png',
		'backgrounds/sk0rbias',
		'backgrounds/SwagnotrllyTheMod',
		'backgrounds/zombought'
	];

	var logoBl:FlxSprite;

	var lilMenuGuy:FlxSprite;

	var curOptText:FlxText;
	var curOptDesc:FlxText;

	var black:FlxSprite;

	override function create()
	{
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		persistentUpdate = persistentDraw = true;

		#if desktop
		DiscordClient.changePresence("In the Menus", null);
		#end

		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		daRealEngineVer = engineVers[FlxG.random.int(0, 3)];
		
		bg = new FlxSprite(-80).loadGraphic(randomizeBG());
		bg.scrollFactor.set();
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		bg.color = 0xFFFDE871;
		add(bg);

		magenta = new FlxSprite(-80).loadGraphic(bg.graphic);
		magenta.scrollFactor.set();
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);

		selectUi = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenu/Select_Thing', 'preload'));
		selectUi.scrollFactor.set(0, 0);
		selectUi.antialiasing = true;
		selectUi.updateHitbox();
		add(selectUi);

		bigIcons = new FlxSprite(0, 0);
		bigIcons.frames = Paths.getSparrowAtlas('menu_big_icons');
		for (i in 0...optionShit.length)
		{
			bigIcons.animation.addByPrefix(optionShit[i], optionShit[i] == 'freeplay' ? 'freeplay0' : optionShit[i], 24);
		}
		bigIcons.scrollFactor.set(0, 0);
		bigIcons.antialiasing = true;
		bigIcons.updateHitbox();
		bigIcons.animation.play(optionShit[0]);
		bigIcons.screenCenter(X);
		add(bigIcons);

		curOptText = new FlxText(0, 0, FlxG.width, languagesOptions[curSelected], 32);
		curOptText.setFormat("Comic Sans MS Bold", 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		curOptText.scrollFactor.set(0, 0);
		curOptText.borderSize = 2.5;
		curOptText.antialiasing = true;
		curOptText.screenCenter(X);
		curOptText.y = FlxG.height / 2 + 28;
		add(curOptText);

		curOptDesc = new FlxText(0, 0, FlxG.width, languagesDescriptions[curSelected], 32);
		curOptDesc.setFormat("Comic Sans MS Bold", 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		curOptDesc.scrollFactor.set(0, 0);
		curOptDesc.borderSize = 2;
		curOptDesc.antialiasing = true;
		curOptDesc.screenCenter(X);
		curOptDesc.y = FlxG.height - 58;
		add(curOptDesc);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('main_menu_icons');

		// camFollow = new FlxObject(0, 0, 1, 1);
		// add(camFollow);

		// FlxG.camera.follow(camFollow, null, 0.06);

		// camFollow.setPosition(640, 150.5);

		for (i in 0...optionShit.length)
		{
			var currentOptionShit = optionShit[i];
			var menuItem:FlxSprite = new FlxSprite(FlxG.width * 1.6, 0);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', (currentOptionShit == 'freeplay glitch' ? 'freeplay' : currentOptionShit) + " basic", 24);
			menuItem.animation.addByPrefix('selected', (currentOptionShit == 'freeplay glitch' ? 'freeplay' : currentOptionShit) + " white", 24);
			menuItem.animation.play('idle');
			menuItem.antialiasing = false;
			menuItem.setGraphicSize(128, 128);
			menuItem.ID = i;
			menuItem.updateHitbox();
			// menuItem.screenCenter(Y);
			// menuItem.alpha = 0; //TESTING
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0, 1);
			if (firstStart)
			{
				FlxTween.tween(menuItem, {x: FlxG.width / 2 - 450 + (i * 160)}, 1 + (i * 0.25), {
					ease: FlxEase.expoInOut,
					onComplete: function(flxTween:FlxTween)
					{
						finishedFunnyMove = true;
						// menuItem.screenCenter(Y);
						changeItem();
					}
				});
			}
			else
			{
				// menuItem.screenCenter(Y);
				menuItem.x = FlxG.width / 2 - 450 + (i * 160);
				changeItem();
			}
		}

		firstStart = false;

		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var pressR:FlxText = new FlxText(10, 10, 0, "Press R to reset your data", 12);
		pressR.setFormat("Comic Sans MS Bold", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		pressR.antialiasing = true;
		pressR.alpha = 0;
		pressR.scrollFactor.set();
		add(pressR);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.y = FlxG.height / 2 + 130;
		});

		// NG.core.calls.event.logEvent('swag').send();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		var leftP = controls.UI_LEFT_P;
		var rightP = controls.UI_RIGHT_P;

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (FlxG.keys.justPressed.R)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));

				prompt = new ResetPrompt("Are you sure you want to reset all of your data?\nNOTE: THIS IS PERMANENT AND CANNOT BE UNDONE.", controls);
				prompt.canInteract = true;
				prompt.alpha = 0;
				canInteract = false;

				black = new FlxSprite().makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
				black.screenCenter();
				black.alpha = 0;
				add(black);

				FlxTween.tween(black, {alpha: 0.6}, 0.3);

				FlxTween.tween(prompt, {alpha: 1}, 0.5, {
					onComplete: function(tween:FlxTween)
					{
						prompt.canInteract = true;
					}
				});
				prompt.noFunc = function()
				{
					FlxTween.tween(black, {alpha: 0}, 0.3, {
						onComplete: function(tween:FlxTween)
						{
							remove(black);
						}
					});
					prompt.canInteract = false;
					FlxTween.tween(prompt, {alpha: 0}, 0.5, {
						onComplete: function(tween:FlxTween)
						{
							remove(prompt);
							FlxG.mouse.visible = false;
							canInteract = true;
						}
					});
				}
				prompt.yesFunc = function()
				{
					resetData();
				}
				add(prompt);
			}

		if (!selectedSomethin)
		{
			if (leftP)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (rightP)
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

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'discord' || optionShit[curSelected] == 'merch')
				{
					switch (optionShit[curSelected])
					{
						case 'discord':
							CoolUtil.browserLoad('https://discord.gg/jGNTgcjq');
					}
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					FlxTween.tween(FlxG.camera, {zoom:1.35}, 1.45, {ease: FlxEase.expoIn});
					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
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
										if (FlxG.random.bool(0.01))
										{
											CoolUtil.browserLoad("https://www.youtube.com/watch?v=dQw4w9WgXcQ"); //god im so unfunny lmao -frogb
										}
										MusicBeatState.switchState(new FreeplayState());
									case 'options':
										MusicBeatState.switchState(new options.OptionsState());
									case 'ost':
										MusicBeatState.switchState(new MusicPlayerState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'discord':
										CoolUtil.browserLoad('https://discord.gg/jGNTgcjq');
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
				MusicBeatState.switchState(new editors.MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	override function beatHit()
	{
		super.beatHit();
	}

	function changeItem(huh:Int = 0)
	{	
		if (canInteract)
			{
				curSelected += huh;

				if (curSelected >= menuItems.length)
					curSelected = 0;
				if (curSelected < 0)
					curSelected = menuItems.length - 1;
			}

			menuItems.forEach(function(spr:FlxSprite)
			{
				spr.animation.play('idle');

				if (spr.ID == curSelected && canInteract)
				{
					spr.animation.play('selected');
					// camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
				}
				// spr.screenCenter(Y);
				spr.updateHitbox();
			});

			bigIcons.animation.play(optionShit[curSelected]);
			curOptText.text = languagesOptions[curSelected];
			curOptDesc.text = languagesDescriptions[curSelected];
	}
	

	public static function randomizeBG():flixel.system.FlxAssets.FlxGraphicAsset
		{
			var chance:Int = FlxG.random.int(0, bgPaths.length - 1);
			return Paths.image(bgPaths[chance]);
		}
	
	function resetData()
	{
		for (save in ['funkin', 'controls'])
		{
			FlxG.save.bind(save, 'ninjamuffin99');
			FlxG.save.erase();
			FlxG.save.flush();
		}
		FlxG.save.bind('funkin', 'ninjamuffin99');

		Highscore.weekScores = new Map();
		Highscore.songScores = new Map();
		Highscore.songRating = new Map();

		Highscore.load();

		FlxG.sound.music.stop();

		FlxG.switchState(new TitleState());
		canInteract = true;
	}
}

class ResetPrompt extends FlxSpriteGroup
{
	var promptText:FlxText;
	var yesText:FlxText;
	var noText:FlxText;
	var texts = new Array<FlxText>();

	public var yesFunc:Void->Void;
	public var noFunc:Void->Void;
	public var canInteract:Bool = true;
	public var controls:Controls;

	var curSelected:Int = 0;

	public function new(question:String, controls:Controls)
	{
		super();

		this.controls = controls;

		FlxG.mouse.visible = true;

		promptText = new FlxText(0, FlxG.height / 2 - 200, FlxG.width, question, 16);
		promptText.setFormat("Comic Sans MS Bold", 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		promptText.screenCenter(X);
		promptText.scrollFactor.set(0, 0);
		promptText.borderSize = 2.5;
		promptText.antialiasing = true;
		add(promptText);

		noText = new FlxText(0, FlxG.height / 2 + 100, 0, "No", 16);
		noText.screenCenter(X);
		noText.x += 200;
		noText.setFormat("Comic Sans MS Bold", 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		noText.scrollFactor.set(0, 0);
		noText.borderSize = 1.5;
		noText.antialiasing = true;
		add(noText);

		yesText = new FlxText(0, FlxG.height / 2 + 100, 0, "Yes", 16);
		yesText.screenCenter(X);
		yesText.x -= 200;
		yesText.setFormat("Comic Sans MS Bold", 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		yesText.scrollFactor.set(0, 0);
		yesText.borderSize = 1.5;
		yesText.antialiasing = true;
		add(yesText);

		texts = [yesText, noText];

		updateText();
	}

	override function update(elapsed:Float)
	{
		var leftP = controls.UI_LEFT_P;
		var rightP = controls.UI_RIGHT_P;
		var enter = controls.ACCEPT;

		if (leftP)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected--;
			if (curSelected < 0)
			{
				curSelected = 1;
			}
			updateText();
		}
		if (rightP)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			curSelected++;
			if (curSelected > 1)
			{
				curSelected = 0;
			}
			updateText();
		}
		if (enter)
		{
			select(texts[curSelected]);
		}
		if (FlxG.mouse.justMoved)
		{
			for (i in 0...texts.length)
			{
				if (i != curSelected)
				{
					if (FlxG.mouse.overlaps(texts[i]) && !FlxG.mouse.overlaps(texts[curSelected]))
					{
						curSelected = i;
						FlxG.sound.play(Paths.sound('scrollMenu'));
						updateText();
					}
				}
			}
		}

		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(texts[curSelected]))
			{
				select(texts[curSelected]);
			}
		}
		super.update(elapsed);
	}

	function updateText()
	{
		switch (curSelected)
		{
			case 0:
				yesText.borderColor = FlxColor.YELLOW;
				noText.borderColor = FlxColor.BLACK;
			case 1:
				noText.borderColor = FlxColor.YELLOW;
				yesText.borderColor = FlxColor.BLACK;
		}
	}

	function select(text:FlxText)
	{
		FlxG.sound.play(Paths.sound('confirmMenu'));
		var select = texts.indexOf(text);

		FlxFlicker.flicker(text, 1.1, 0.1, false, false, function(flicker:FlxFlicker)
		{
			switch (select)
			{
				case 0:
					yesFunc();
				case 1:
					noFunc();
			}
		});
	}
}