package;

import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.system.FlxSoundGroup;
import flixel.math.FlxPoint;
import openfl.geom.Point;
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.util.FlxStringUtil;
import purgatory.PurFreeplayState;

#if desktop
import Discord.DiscordClient;
#end

class CharacterSelectionState extends MusicBeatState //This is not from the D&B source code, it's completely made by me (Delta).
{
	public static var characterData:Array<Dynamic> = [
        //["character name", /*forms are here*/[["form 1 name", 'character json name'], ["form 2 name (can add more than just one)", 'character json name 2']]/*forms end here*/, /*these are score multipliers for arrows*/[1.0, 1.0, 1.0, 1.0], /*hide it completely*/ true], 
        ["Boyfriend", [["Boyfriend", 'bf'], ["Boyfriend (Pixel)", 'bf-pixel-normalpos'], ["Boyfriend (Christmas)", 'bf-christmas'], ["Boyfriend and Girlfriend", 'bf-holding-gf'], ["Boyfriend and Girlfriend (Pixel)", 'bf-holding-gf-pixel'], ["Boyfriend and Girlfriend (Relic Version)", 'bf-holding-gf-relicversion'],], [1, 1, 1, 1], false],
        ["Dave", [["Dave", 'dave'], ["Dave (Insanity)", 'dave-insanity'], ["Dave (Splitathon)", 'dave-splitathon'], ["Dave (Old)", 'dave-older']], [0.25, 2, 2, 0.25], false], 
        ["3D Dave", [["3D Dave", 'dave-3d'], ["3D Dave (Old)", 'dave-insanity3d']], [2, 0.25, 0.25, 2], false],
        ["Bambi", [["Bambi", 'bambi'], ["Bambi (Old)", 'bambi-old'], ["Bambi (Splitathon)", 'bambi-splitathon'], ["Bambi (Angry)", 'bambi-mad']], [0, 0, 3, 0], false],
        ["Tristan", [["Tristan", 'tristan'], ["Golden Tristan", 'golden-tristan']], [2, 0.5, 0.5, 0.5], false], 
        ["Drip Dave", [["Drip Dave", 'dave-drip']], [0.42, 0.69, 0.42, 0.69/*Nice*/], true],
        ["Expunged", [["3D Bambi", 'bambi-3d'], ["Unfair Bambi", 'bambi-unfair']], [0, 0, 0, 3], false]
    ];
    var characterSprite:Boyfriend;
    public static var characterFile:String = 'bf';

	var nightColor:FlxColor = 0xFF878787;
    var curSelected:Int = 0;
    var curSelectedForm:Int = 0;
    var curText:FlxText;
    var controlsText:FlxText;
    var formText:FlxText;
    var entering:Bool = false;

    var otherText:FlxText;
    var yesText:FlxText;
    var noText:FlxText;
    var previewMode:Bool = false;
    var unlocked:Bool = true;

    public static var notBF:Bool = false;

    var arrowStrums:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

    var scoreMultipliersText:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

    public static var scoreMultipliers:Array<Float> = [1, 1, 1, 1];

    var scoreMulti:FlxText; //screw this im making this an independent variable i cant deal with the array

	public var camGame:FlxCamera;
	public var camHUD:FlxCamera;

    var basePosition:FlxPoint;

    var bgShader:Shaders.GlitchEffect;

    var arrows:Array<FlxSprite> = [];

    var tutorialThing:FlxSprite; //moved this here
    var arrowLeft:FlxSprite;
    var arrowRight:FlxSprite;

    override function create() 
    {
        #if desktop
		DiscordClient.changePresence("Choosing a character to play as... (In the Character Selection Screen)", null);
		#end

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxCamera.defaultCameras = [camGame];
        scoreMultipliers = [1, 1, 1, 1];
        characterFile = 'bf';
        notBF = false;
        if (PlayState.SONG.song.toLowerCase() == "exploitation")
			FlxG.sound.playMusic(Paths.music("bad-ending"), 1, true);
		else
			FlxG.sound.playMusic(Paths.music("good-ending"), 1, true);
		Conductor.changeBPM(110);

        var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('dave/sky_night'));
        bg.antialiasing = true;
        bg.scrollFactor.set(0.75, 0.75);
        bg.active = false;

        if (PlayState.SONG.song.toLowerCase() == "exploitation") //fuck
		{
			bg.loadGraphic(Paths.image('backgrounds/void/redsky', 'shared'));

			bgShader = new Shaders.GlitchEffect();
			bgShader.waveAmplitude = 0.1;
			bgShader.waveFrequency = 5;
			bgShader.waveSpeed = 2;

			bg.shader = bgShader.shader;
		}
		add(bg);
            
        var hills:BGSprite = new BGSprite('backgrounds/charSelect/hills', -133, 52, 1, 1);
        hills.scale.set(1.1, 1.1);
        add(hills);

        var house:BGSprite = new BGSprite('backgrounds/charSelect/house', 385, 78, 1, 1);
        house.scale.set(1.1, 1.1);
        add(house);

        var behindGrass:BGSprite = new BGSprite('backgrounds/charSelect/behindGrass', -33, 468, 1, 1);
        behindGrass.scale.set(1.1, 1.1);
        add(behindGrass);

        var gateLeft:BGSprite = new BGSprite('backgrounds/charSelect/gateLeft', -38, 464, 1, 1);
        gateLeft.scale.set(1.1, 1.1);
        add(gateLeft);

        var gateRight:BGSprite = new BGSprite('backgrounds/charSelect/gateRight', 1014, 464, 1, 1);
        gateRight.scale.set(1.1, 1.1);
        add(gateRight);

        var grass:BGSprite = new BGSprite('backgrounds/charSelect/grass', -80, 385, 1, 1);
        grass.scale.set(1.1, 1.1);
        add(grass);

        var frontGrass:BGSprite = new BGSprite('backgrounds/charSelect/frontGrass', -185, 382, 1, 1);
        frontGrass.scale.set(1.1, 1.1);
        add(frontGrass);

        var varientColor = 0xFF878787;

		frontGrass.color = varientColor;
		hills.color = varientColor;
		house.color = varientColor;
		behindGrass.color = varientColor;
		gateLeft.color = varientColor;
		gateRight.color = varientColor;
		grass.color = varientColor;

		//FlxG.camera.zoom = 0.75;
		//camHUD.zoom = 0.75;

        if(PlayState.SONG.player1 != "bf" && PauseSubState.isPlayState == false)
            {
                otherText = new FlxText(10, 150, 0, 'This song does not use BF as the player,\nor a different version of BF is used.\nDo you want to continue without changing character?\n', 20);
                otherText.setFormat(Paths.font("comic-sans.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                otherText.size = 55;
                otherText.screenCenter(X);
                add(otherText);
                yesText = new FlxText(FlxG.width / 4, 400, 0, 'Yes', 20);
                yesText.setFormat(Paths.font("comic-sans.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                yesText.size = 55;
                add(yesText);
                noText = new FlxText(FlxG.width / 1.5, 400, 0, 'No', 20);
                noText.setFormat(Paths.font("comic-sans.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                noText.size = 55;
                add(noText);
                otherText.cameras = [camHUD];
                yesText.cameras = [camHUD];
                noText.cameras = [camHUD];
            }
        else {
            spawnSelection();
        }

        super.create();
    }

    var selectionStart:Bool = false;

    function spawnArrows()
        {
            for (i in 0...4)
                {
                    // FlxG.log.add(i);
                    var babyArrow:FlxSprite = new FlxSprite(0, FlxG.height - 40);

                    babyArrow.y -= 10;
                    babyArrow.alpha = 0;
                    FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
                    
			        babyArrow.frames = Paths.getSparrowAtlas('NOTE_assets');
			        babyArrow.animation.addByPrefix('green', 'arrowUP');
			        babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
			        babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
			        babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
    
                    babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
                    babyArrow.x += Note.swagWidth * i;
                    switch (Math.abs(i))
                    {
                        case 0:
                            babyArrow.animation.addByPrefix('static', 'arrowLEFT');
                            babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
                            babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
                        case 1:
                            babyArrow.animation.addByPrefix('static', 'arrowDOWN');
                            babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
                            babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
                        case 2:
                            babyArrow.animation.addByPrefix('static', 'arrowUP');
                            babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
                            babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
                        case 3:
                            babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
                            babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
                            babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
                    }
                    babyArrow.updateHitbox();
                    babyArrow.scrollFactor.set();
                    babyArrow.ID = i;
    
                    babyArrow.animation.play('static');
                    babyArrow.x += 50;
                    babyArrow.x += ((FlxG.width / 3.5));
                    babyArrow.y -= 10;
                    arrowStrums.add(babyArrow);

                    scoreMulti = new FlxText(FlxG.width / 4, 350, 0, "x" + FlxStringUtil.formatMoney(characterData[curSelected][2][i]), 20);
                    scoreMulti.setFormat(Paths.font("comic-sans.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                    scoreMulti.size = 20;
                    scoreMulti.x = babyArrow.x;
                    scoreMulti.y = babyArrow.y;
                    scoreMulti.x += 20;
                    scoreMulti.y += 50;
                    scoreMultipliersText.add(scoreMulti);
                }
        }

    function spawnSelection()
        {
            selectionStart = true;
            tutorialThing = new FlxSprite(-110, -30).loadGraphic(Paths.image('charSelect/charSelectGuide'));
		    tutorialThing.setGraphicSize(Std.int(tutorialThing.width * 1.5));
		    tutorialThing.antialiasing = true;
		    add(tutorialThing);

            curText = new FlxText((FlxG.width / 9) - 50, (FlxG.height / 8) - 225, characterData[curSelected][1][0][0]);
            curText.setFormat(Paths.font("comic-sans.ttf"), 90, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            curText.autoSize = false;
		    curText.fieldWidth = 1080;
		    curText.borderSize = 5;
		    curText.screenCenter(X);
		    curText.cameras = [camHUD];
		    curText.antialiasing = true;
		    curText.y = FlxG.height - 180;
            add(curText);

            var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 46).makeGraphic(FlxG.width, 56, 0xFF000000);
            textBG.alpha = 0.6;
            textBG.scrollFactor.set();
            
            controlsText = new FlxText(textBG.x + -10, textBG.y + 3, FlxG.width, 'Press P to enter preview mode.', 20);
            controlsText.setFormat(Paths.font("comic-sans.ttf"), 18, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            controlsText.scrollFactor.set();
            controlsText.size = 20;

            spawnArrows();
            add(arrowStrums);
            add(scoreMultipliersText);

            characterSprite = new Boyfriend(0, 0, "bf");
            add(characterSprite);
            characterSprite.scale.set(0.75, 0.75);
            characterSprite.dance();
            characterSprite.screenCenter(XY);
    
            add(curText);
            add(textBG);
            add(controlsText);
            curText.cameras = [camHUD];
            controlsText.cameras = [camHUD];
            tutorialThing.cameras = [camHUD];
            arrowStrums.cameras = [camHUD];
            scoreMultipliersText.cameras = [camHUD];
    
            curText.screenCenter(X);
            changeCharacter(0);

            arrowLeft = new FlxSprite(10, 0).loadGraphic(Paths.image("charSelect/ArrowLeft_Idle"));
            arrowLeft.screenCenter(Y);
            arrowLeft.antialiasing = true;
            arrowLeft.scrollFactor.set();
            arrowLeft.cameras = [camHUD];
            arrows[0] = arrowLeft;
            add(arrowLeft);

            arrowRight = new FlxSprite(-5, 0).loadGraphic(Paths.image("charSelect/ArrowRight_Idle"));
            arrowRight.screenCenter(Y);
            arrowRight.antialiasing = true;
            arrowRight.x = 1280 - arrowRight.width - 5;
            arrowRight.scrollFactor.set();
            arrowRight.cameras = [camHUD];
            arrows[1] = arrowRight;
            add(arrowRight);
        }

    function checkPreview()
        {
            if(previewMode)
                {
                    controlsText.text = "PREVIEW MODE | Press I to play idle animation. | Press your controls to play an animation.";
                    arrowRight.alpha = 0;
                    arrowLeft.alpha = 0;
                    curText.alpha = 0;
                }
            else {
                controlsText.text = "Press P to enter preview mode.";
                characterSprite.playAnim('idle');
            }
        }
    override function update(elapsed)
    {
        //idk it didnt work on function create so
        //FlxG.camera.zoom = 1.2;
		camHUD.zoom = 0.75;

        if(FlxG.keys.justPressed.P && selectionStart && unlocked && !entering)
            {
                previewMode = !previewMode;
                checkPreview();
            }
        if(selectionStart && !previewMode)
            {
                if(FlxG.keys.justPressed.RIGHT)
                    {
                        arrows[1].loadGraphic(Paths.image("charSelect/ArrowRight_Pressed"));
                        changeCharacter(1);
                    }
                if(FlxG.keys.justPressed.LEFT)
                    {
                        arrows[0].loadGraphic(Paths.image("charSelect/ArrowLeft_Pressed"));
                        changeCharacter(-1);
                    }
                if (FlxG.keys.justReleased.LEFT)
                    {
                        arrows[0].loadGraphic(Paths.image("charSelect/ArrowLeft_Idle"));
                    }
                if (FlxG.keys.justReleased.RIGHT)
                    {
                        arrows[1].loadGraphic(Paths.image("charSelect/ArrowRight_Idle"));
                    }
                if(controls.UI_DOWN_P && unlocked)
                    {
                        changeForm(1);
                    }
                if(controls.UI_UP_P && unlocked)
                    {
                        changeForm(-1);
                    }
                if(controls.ACCEPT && unlocked)
                    {
                        acceptCharacter();
                    }
            }
            else if (!previewMode)
            {
                if(FlxG.keys.justPressed.RIGHT)
                    {
                        curSelected += 1;
                        FlxG.sound.play(Paths.sound('scrollMenu'));
                    }
                if(FlxG.keys.justPressed.LEFT)
                    {
                        curSelected =- 1;
                        FlxG.sound.play(Paths.sound('scrollMenu'));
                    }
                if (curSelected < 0)
                    {
                        curSelected = 0;
                    }
                    if (curSelected >= 2)
                    {
                        curSelected = 0;
                    }
                switch(curSelected)
                {
                    case 0:
                        yesText.alpha = 1;
                        noText.alpha = 0.5;
                    case 1:
                        noText.alpha = 1;
                        yesText.alpha = 0.5;
                }
                if(controls.ACCEPT)
                    {
                        switch(curSelected)
                        {
                            case 0:
                                FlxG.sound.music.stop();
                                FlxTween.tween(camHUD, {alpha: 0}, 0.25, {ease: FlxEase.circOut});
                                LoadingState.loadAndSwitchState(new PlayState());
                            case 1:
                                noText.alpha = 0;
                                yesText.alpha = 0;
                                otherText.alpha = 0;
                                curSelected = 0;
                                spawnSelection();
                                
                        }
                    }
            }
            else
                {
                    if(controls.NOTE_LEFT_P)
                        {
                            if(characterSprite.animOffsets.exists('singLEFT'))
                                {
                                    arrowStrums.members[0].animation.play('confirm');
									arrowStrums.members[0].centerOffsets();
									arrowStrums.members[0].offset.x -= 13;
									arrowStrums.members[0].offset.y -= 13;
                                    characterSprite.playAnim('singLEFT');
                                }
                        }
                    if(controls.NOTE_DOWN_P)
                        {
                            if(characterSprite.animOffsets.exists('singDOWN'))
                                {
                                    arrowStrums.members[1].animation.play('confirm');
									arrowStrums.members[1].centerOffsets();
									arrowStrums.members[1].offset.x -= 13;
									arrowStrums.members[1].offset.y -= 13;
                                    characterSprite.playAnim('singDOWN');
                                }
                        }
                    if(controls.NOTE_UP_P)
                        {
                            if(characterSprite.animOffsets.exists('singUP'))
                                {
                                    arrowStrums.members[2].animation.play('confirm');
									arrowStrums.members[2].centerOffsets();
									arrowStrums.members[2].offset.x -= 13;
									arrowStrums.members[2].offset.y -= 13;
                                    characterSprite.playAnim('singUP');
                                }
                        }
                    if(controls.NOTE_RIGHT_P)
                        {
                            if(characterSprite.animOffsets.exists('singRIGHT'))
                                {
                                    arrowStrums.members[3].animation.play('confirm');
									arrowStrums.members[3].centerOffsets();
									arrowStrums.members[3].offset.x -= 13;
									arrowStrums.members[3].offset.y -= 13;
                                    characterSprite.playAnim('singRIGHT');
                                }
                        }
                    if(controls.NOTE_LEFT_R)
                        {
                            arrowStrums.members[0].animation.play('static');
                            arrowStrums.members[0].centerOffsets();
                        }
                    if(controls.NOTE_DOWN_R)
                        {
                            arrowStrums.members[1].animation.play('static');
                            arrowStrums.members[1].centerOffsets();
                        }
                    if(controls.NOTE_UP_R)
                        {
                            arrowStrums.members[2].animation.play('static');
                            arrowStrums.members[2].centerOffsets();
                        }
                    if(controls.NOTE_RIGHT_R)
                        {
                            arrowStrums.members[3].animation.play('static');
                            arrowStrums.members[3].centerOffsets();
                        }
                    if(FlxG.keys.justPressed.I)
                        {
                            characterSprite.playAnim('idle');
                        }
                }

        		if (controls.BACK) {
                    if(PlayState.isFreeplay) {
                        FlxG.sound.play(Paths.sound('cancelMenu'));
						MusicBeatState.switchState(new FreeplayState());
						FlxG.sound.playMusic(Paths.music('freakyMenu'));
                        PauseSubState.isPlayState = false;
					}
                    if(PlayState.isFreeplayPur) {
                        FlxG.sound.play(Paths.sound('cancelMenu'));
						MusicBeatState.switchState(new PurFreeplayState());
						FlxG.sound.playMusic(Paths.music('purFreakyMenu'));
                        PauseSubState.isPlayState = false;
					} // is the bp menu still gonna be used or not?
                }
        super.update(elapsed);
    }


    function changeCharacter(change:Int, playSound:Bool = true) 
    {
        
        if(!entering)
            {
        if(playSound)
            {
                FlxG.sound.play(Paths.sound('scrollMenu'));
            }
        curSelectedForm = 0;
        curSelected += change;

        if (curSelected < 0)
        {
			curSelected = characterData.length - 1;
        }
		if (curSelected >= characterData.length)
        {
			curSelected = 0;
        }
        if(FlxG.save.data.unlockedCharacters.contains(characterData[curSelected][0]))
        {
            unlocked = true;
        }
        else
        {
            #if debug
                unlocked = true;
            #else
                unlocked = false;
            #end
        }

        characterFile = characterData[curSelected][1][0][1];

        if(unlocked)
            {
                curText.text = characterData[curSelected][1][0][0];
                scoreMultipliers = characterData[curSelected][2];
                 for (i in 0...characterData[curSelected][2].length)
                    {
                        scoreMultipliersText.members[i].text = FlxStringUtil.formatMoney(characterData[curSelected][2][i]) + "x";
                    }
                reloadCharacter();
            }
        else if(!characterData[curSelected][3])
            {
                curText.text = "???";
                scoreMultipliers = [0, 0, 0, 0];
                for (i in 0...characterData[curSelected][2].length)
                    {
                        scoreMultipliersText.members[i].text = "?.??x";
                    }
                reloadCharacter();
            }
        else
            {
                changeCharacter(change, false);
            }

        curText.screenCenter(X);
            }
    }

    function changeForm(change:Int) 
        {
            if(!entering)
            {
            if(characterData[curSelected][1].length >= 2)
            {
                FlxG.sound.play(Paths.sound('scrollMenu'));
                curSelectedForm += change;
    
                if (curSelectedForm < 0)
                {
                    curSelectedForm = characterData[curSelected][1].length;
                    curSelectedForm = curSelectedForm - 1;
                }
                if (curSelectedForm >= characterData[curSelected][1].length)
                {
                    curSelectedForm = 0;
                }
                curText.text = characterData[curSelected][1][curSelectedForm][0];
                characterFile = characterData[curSelected][1][curSelectedForm][1];

                reloadCharacter();
        
                curText.screenCenter(X);
            }
            }
        }

    function reloadCharacter()
        {
            characterSprite.destroy();
            characterSprite = new Boyfriend(0, 0, characterFile);
            add(characterSprite);
            characterSprite.updateHitbox();
            characterSprite.scale.set(0.75, 0.75);
            characterSprite.dance();

            characterSprite.screenCenter(XY);

            if(!unlocked)
                {
                    characterSprite.color = FlxColor.BLACK;
                }
            switch(characterData[curSelected][0])
            {
                case "Bambi":
                    characterSprite.y += 50;
                case "Dave":
                    characterSprite.y -= 80;
                case "3D Dave":
                    characterSprite.y -= 110;
            }
            switch(characterData[curSelected][1][curSelectedForm][0])
            {
                case "3D Dave (Old)":
                    characterSprite.x -= 60;
                    characterSprite.y -= 120;
            }
        }


    function acceptCharacter() 
    {
        if(!entering)
        {
            entering = true;
            FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.circOut});
            if(characterData[curSelected][1][0][0] != "Boyfriend")
                notBF = true;

            if(characterSprite.animOffsets.exists('hey') && characterSprite.animation.getByName('hey') != null) {
                characterSprite.playAnim('hey');
            } else {
                characterSprite.playAnim('singUP');
            }

            FlxG.sound.music.fadeOut(1.9, 0);
            FlxG.sound.play(Paths.sound('confirmMenu'));
            new FlxTimer().start(1.9, function(tmr:FlxTimer)
            {
                if(characterFile == 'bf-pixel-normalpos')
					PlayState.SONG.gfVersion = 'gf-pixel';
                if(characterFile == 'bf-christmas')
					PlayState.SONG.gfVersion = 'gf-christmas';
                if(characterFile == 'bf-holding-gf')
					PlayState.SONG.gfVersion = 'pico-speakers';
                if(characterFile == 'bf-holding-gf-relicversion')
					PlayState.SONG.gfVersion = 'Android21';
                if(characterFile == 'bf-holding-gf-pixel')
					PlayState.SONG.gfVersion = 'Android21-pixel';
                PlayState.SONG.player1 = characterFile;
                LoadingState.loadAndSwitchState(new PlayState());
                FlxTween.tween(FlxG.camera, {zoom: 5}, 0.8, {ease: FlxEase.expoIn});
                FlxTween.tween(FlxG.camera, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
             });
        }
    }
}

class CharacterUnlockObject extends FlxSpriteGroup {
	public var onFinish:Void->Void = null;
	var alphaTween:FlxTween;
	public function new(name:String, ?camera:FlxCamera = null, characterIcon:String, color:FlxColor = FlxColor.BLACK)
	{
		super(x, y);
		ClientPrefs.saveSettings();

		var characterBG:FlxSprite = new FlxSprite(60, 50).makeGraphic(420, 120, color);
		characterBG.scrollFactor.set();

		var characterIcon:HealthIcon = new HealthIcon(characterIcon, false);
        characterIcon.animation.curAnim.curFrame = 2;
        characterIcon.x = characterBG.x + 10;
        characterIcon.y = characterBG.y + 10;
		characterIcon.scrollFactor.set();
		characterIcon.setGraphicSize(Std.int(characterIcon.width * (2 / 3)));
		characterIcon.updateHitbox();
		characterIcon.antialiasing = ClientPrefs.globalAntialiasing;

		var characterName:FlxText = new FlxText(characterIcon.x + characterIcon.width + 20, characterIcon.y + 16, 280, name, 16);
		characterName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		characterName.scrollFactor.set();

		var characterText:FlxText = new FlxText(characterName.x, characterName.y + 32, 280, "Play as this character in freeplay!", 16);
		characterText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		characterText.scrollFactor.set();

		add(characterBG);
		add(characterName);
		add(characterText);
		add(characterIcon);

		var cam:Array<FlxCamera> = FlxCamera.defaultCameras;
		if(camera != null) {
			cam = [camera];
		}
		alpha = 0;
		characterBG.cameras = cam;
		characterName.cameras = cam;
		characterText.cameras = cam;
		characterIcon.cameras = cam;
		alphaTween = FlxTween.tween(this, {alpha: 1}, 0.5, {onComplete: function (twn:FlxTween) {
			alphaTween = FlxTween.tween(this, {alpha: 0}, 0.5, {
				startDelay: 2.5,
				onComplete: function(twn:FlxTween) {
					alphaTween = null;
					remove(this);
					if(onFinish != null) onFinish();
				}
			});
		}});
	}

	override function destroy() {
		if(alphaTween != null) {
			alphaTween.cancel();
		}
		super.destroy();
	}
}