package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxSprite;

class GameOverSubstate extends MusicBeatSubstate
{
	var bf:Boyfriend;
	var bf2:FlxSprite;
	var camFollow:FlxObject;

	var stageSuffix:String = "";
	var konami:Int;

	public function new(x:Float, y:Float, konam)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (PlayState.SONG.player1)
		{
			case 'bf-pixel':
				stageSuffix = '-pixel';
				daBf = 'bf-pixel-dead';
			default:
				daBf = 'bf';
		}
		konami = konam;

		super();

		Conductor.songPosition = 0;

		bf = new Boyfriend(x, y, daBf);
		add(bf);
		bf2 = new FlxSprite(x, y);
		bf2.frames = Paths.getSparrowAtlas('phase3shitholestuff/Ball_In_Yo_Yaws', 'ghosttwins');
		bf2.animation.addByPrefix('firstDeath', "BF dies", 24, false);
		bf2.animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
		bf2.animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
		bf2.alpha = 0;
		add(bf2);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx' + stageSuffix));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;
		if(konami > 7)
		{
		bf2.alpha = 1;
		bf.alpha = 0;
		bf.playAnim('firstDeath');
		bf2.animation.play('firstDeath');
		}else{
		bf2.alpha = 0;
		bf.playAnim('firstDeath');
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());
			PlayState.loadRep = false;
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
		{
			if(konami > 7){
				FlxG.sound.playMusic(Paths.music('ballsinyoyaws', 'ghosttwins'));
			}else{
				FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));
			}
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			bf2.alpha = 0;
			bf.alpha = 1;
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					LoadingState.loadAndSwitchState(new PlayState());
				});
			});
		}
	}
}
