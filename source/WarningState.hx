package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;
import Controls.KeyboardScheme;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class WarningState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;
	var wackyyy:Bool = false;

	override public function create():Void
	{
		super.create();

		FlxG.save.bind('funkin', 'ninjamuffin99');

		// var file:SMFile = SMFile.loadFile("file.sm");
		// this was testing things

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}
	}

	function startIntro()
	{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

		Conductor.changeBPM(102);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('warning', 'preload'));
        bg.scrollFactor.x = 0;
        bg.scrollFactor.y = 0.10;
        bg.setGraphicSize(Std.int(bg.width * 1));
        bg.updateHitbox();
        bg.screenCenter();
        bg.antialiasing = true;
        add(bg);
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if(wackyyy == false){
			wackyyy = true;
			super.create();
			startIntro();
		}
		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			FlxTween.tween(FlxG.camera, {zoom: 0}, 1, {ease: FlxEase.elasticInOut});
			FlxG.camera.flash(FlxColor.GREEN, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
			FlxG.save.data.distractions = true;
			#if web
				FlxG.switchState(new ClownSubState());
			#else
				FlxG.switchState(new TitleState());
			#end
		}
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxTween.tween(FlxG.camera, {zoom: 0}, 1, {ease: FlxEase.elasticInOut});
			FlxG.camera.flash(FlxColor.RED, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
			FlxG.save.data.distractions = false;
			#if web
				FlxG.switchState(new ClownSubState());
			#else
				FlxG.switchState(new TitleState());
			#end
		}

		super.update(elapsed);
	}

	override function beatHit()
	{
		super.beatHit();

		skipIntro();
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			remove(credGroup);
			skippedIntro = true;
		}
	}
}
