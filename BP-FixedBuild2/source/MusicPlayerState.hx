//all i just did was take modsmenu and not put the modding in it lmfao
package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxButtonPlus;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import haxe.format.JsonParser;
import openfl.display.BitmapData;
import flash.geom.Rectangle;
import flixel.ui.FlxButton;
import flixel.FlxBasic;
import sys.io.File;
/*import haxe.zip.Reader;
import haxe.zip.Entry;
import haxe.zip.Uncompress;
import haxe.zip.Writer;*/

using StringTools;

class MusicPlayerState extends MusicBeatState
{
	static var changedAThing = false;
	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	var noModsTxt:FlxText;
	var selector:AttachedSprite;
	var descriptionTxt:FlxText;
	var needaReset = false;
	private static var curSelected:Int = 0;
	public static var defaultColor:FlxColor = 0xFF665AFF;

	var buttonDown:FlxButton;
	var buttonTop:FlxButton;
	var buttonDisableAll:FlxButton;
	var buttonEnableAll:FlxButton;
	var buttonUp:FlxButton;
	var buttonToggle:FlxButton;
	var buttonsArray:Array<FlxButton> = [];

	var installButton:FlxButton;
	var removeButton:FlxButton;

	var modsList:Array<Dynamic> = [];

	var visibleWhenNoMods:Array<FlxBasic> = [];
	var visibleWhenHasMods:Array<FlxBasic> = [];

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		WeekData.setDirectoryFromWeek();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		noModsTxt = new FlxText(0, 0, FlxG.width, "COMING SOON", 48);
		if(FlxG.random.bool(0.1)) noModsTxt.text += '\nBITCH.'; //meanie
		noModsTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		noModsTxt.scrollFactor.set();
		noModsTxt.borderSize = 2;
		add(noModsTxt);
	}

	var canExit:Bool = true;
	override function update(elapsed:Float)
	{
		if(canExit && controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		}
	}
}
