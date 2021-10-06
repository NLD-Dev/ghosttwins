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
	public static var ending:String = 'neutral';
	public static var accuracy:Float;
	public static var inThing:Bool = false;
	
	private var bgColors:Array<String> = [
		'#314d7f',
		'#4e7093',
		'#70526e',
		'#594465'
	];
	private var colorRotation:Int = 1;
	var kadeLogoW:FlxSprite;

	override function create()
	{
		super.create();

		Application.current.window.title = "Vs Ghosttwins";

		FlxG.sound.playMusic(Paths.music('funy', 'ghosttwins'), 0.4, true);
		
		var kadeLogo:FlxSprite = new FlxSprite(FlxG.width, 0).loadGraphic(Paths.image('KadeEngineLogo'));
		kadeLogo.scale.y = 0.3;
		kadeLogo.scale.x = 0.3;
		kadeLogo.x -= kadeLogo.frameHeight;
		kadeLogo.y -= 180;
		kadeLogo.alpha = 0.8;
		//add(kadeLogo);
		kadeLogoW = new FlxSprite(FlxG.width, 0).loadGraphic(Paths.image('endingcards/'+ ending, 'ghosttwins'));
		kadeLogoW.screenCenter();
		kadeLogoW.scale.y = 1;
		kadeLogoW.scale.x = 1;
		add(kadeLogoW);

		if(ending == 'good'){
			if(FlxG.save.data.beatEcho == false){
				var a:Achievement = new Achievement('Party Started!', 'Wooo!', 'beatEcho', '[FREEPLAY UNLOCKED]');
				add(a);
			}
		}
		if(ending == 'neutral'){
			if(FlxG.save.data.beatNormal == false){
				var a:Achievement = new Achievement('Finally peace.', 'Im glad we could', 'beatNormal', '', 'finally rest...');
				add(a);
			}
		}
		if(ending == 'bad'){
			if(FlxG.save.data.badEnd == false){
				var a:Achievement = new Achievement('Goop', 'you uhh uhhh you goop', 'badEnd', '', 'you fucking suck ass');
				add(a);
			}
		}
		if(ending == 'secs'){
			if(FlxG.save.data.canceled == false){
				var a:Achievement = new Achievement('Canceled.', 'Marie said sex.', 'canceled', '', 'lmfao');
				add(a);
			}
		}
	}

	public function updateEnding(){
		kadeLogoW.destroy();

		if(PlayState.accuracySHIT <= 0.61 && ending == 'neutral')
			ending = 'bad';

		if(PlayState.didKonami == true)
			ending = 'secs';

		kadeLogoW = new FlxSprite(FlxG.width, 0).loadGraphic(Paths.image('endingcards/'+ ending, 'ghosttwins'));
		kadeLogoW.screenCenter();
		kadeLogoW.scale.y = 1;
		kadeLogoW.scale.x = 1;
		add(kadeLogoW);
	}

	override function update(elapsed:Float)
	{
		updateEnding();

		if (controls.ACCEPT && inThing == true)
		{
			inThing = false;
			ending = 'neutral';

			leftState = true;
				FlxG.switchState(new MainMenuState());
				FlxG.sound.music.fadeOut(0, 0);
	
		}
		if (controls.BACK && inThing == true)
		{
			inThing = false;
			ending = 'neutral';

			leftState = true;
				FlxG.switchState(new MainMenuState());
				FlxG.sound.music.fadeOut(0, 0);
			
		}
		super.update(elapsed);
	}
}
