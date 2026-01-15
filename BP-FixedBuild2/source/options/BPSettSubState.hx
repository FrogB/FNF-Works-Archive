package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class BPSettSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'BP-Related Settings';
		rpcTitle = 'BP-Related Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Judgement Counter:',
			"Shows a judgement counter at the left of the screen (Example: Sicks: 93,\nGoods:0, Bads: 1, 'Shits: 0)",
			'judgementCounter',
			'string',
			'Simple',
			['Disabled', 'Simple', 'Advanced']);
		addOption(option);

	// i stole these from ffn :troll4k:
		var option:Option = new Option('Camera Follows on Note Hit',
			'If checked, the camera follows the direction of the note hit.',
			'cameraFollowsNote',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Sections Note Combo', // yea this is rewritten too
			"If checked, shows a note combo counter with the number of notes you hit in a section.\n(Script by Stilic)",
			'noteCombo',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Fast Camera Zoom',
			'Pretty obvious setting.',
			'fastZoom',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Enable Lane Underlay',
			"Enables a black underlay behind the notes\nfor better reading!\n(Similar to Funky Friday's Scroll Underlay or osu!mania's underlay)",
			'laneunderlay',
			'bool',
			true);
		addOption(option);
		
		var option:Option = new Option('Lane Underlay Transparency',
			'Set the Lane Underlay Transparency (Lane Underlay must be enabled)',
			'laneTransparency',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Modcharts',
			"If unchecked, disables Modcharts\nWe encourage turning this off if you do not have good PC specifications.",
			'modchart',
			'bool',
			true);
		addOption(option);
		super();

		var option:Option = new Option('Developer Build Watermark',
			'...I think you know what this does.',
			'devWatermark',
			'bool',
			true);
		addOption(option);
		super();
	}
}