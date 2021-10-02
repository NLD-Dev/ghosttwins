package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Lib;

class DeathSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";
	public static var currChanges:String = "dk";
	var txt:FlxText;
	
	private var bgColors:Array<String> = [
		'#314d7f',
		'#4e7093',
		'#70526e',
		'#594465'
	];
	private var colorRotation:Int = 1;

	override function create()
	{
		super.create();

		FlxG.sound.music = null;
		FlxG.sound.playMusic(Paths.music('funy', 'ghosttwins'), 0.6, true);
		
		var kadeLogo:FlxSprite = new FlxSprite(FlxG.width, 0).loadGraphic(Paths.image('KadeEngineLogo'));
		kadeLogo.scale.y = 0.3;
		kadeLogo.scale.x = 0.3;
		kadeLogo.x -= kadeLogo.frameHeight;
		kadeLogo.y -= 180;
		kadeLogo.alpha = 0.8;
		//add(kadeLogo);
		var kadeLogoW:FlxSprite = new FlxSprite(FlxG.width, 0).loadGraphic(Paths.image('funy', 'ghosttwins'));
		kadeLogoW.screenCenter();
		kadeLogoW.scale.y = 1;
		kadeLogoW.scale.x = 1;
		add(kadeLogoW);

		var a:Achievement = new Achievement('Finally peace.', 'Im glad we could', 'beatNormal', '', 'finally rest...');
		add(a);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			leftState = true;
				FlxG.switchState(new MainMenuState());
	
		}
		if (controls.BACK)
		{
			leftState = true;
				FlxG.switchState(new MainMenuState());
			
		}
		super.update(elapsed);
	}
}
