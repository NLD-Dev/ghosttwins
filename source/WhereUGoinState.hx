package;

import Controls.KeyboardScheme;
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
import io.newgrounds.NG;
import lime.app.Application;
import flixel.FlxCamera;
import flixel.util.FlxTimer;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class WhereUGoinState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['StoryMode', 'Freeplay', 'Achievements'];
	#else
	var optionShit:Array<String> = ['StoryMode', 'Freeplay', 'Achievements'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;
	var curThing:Int = 0;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.4.2" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		Application.current.window.title = "Vs Ghosttwins";
		persistentUpdate = persistentDraw = true;
		
		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.flipX = true;
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80, -150).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.flipX = true;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		var tex = Paths.getSparrowAtlas('menu-assets');
		var Blackshit:FlxSprite = new FlxSprite(-375, 10);
		Blackshit.frames = tex;
		Blackshit.animation.addByPrefix('idle', "SideHolder", 24);
		Blackshit.setGraphicSize(Std.int(Blackshit.width * 1.3));
		Blackshit.animation.play('idle');
		add(Blackshit);
		Blackshit.scrollFactor.set();

		tex = Paths.getSparrowAtlas('menu-assets2');

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);


		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(200, 60 + (i * 200));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + "Off", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + "On", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			if(i == 1){
				#if debug
					trace('debug');
				#else
					if(FlxG.save.data.beatEcho == false){
						menuItem.color = 0xFF151515;
					}
				#end
			}
		}

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Ghost Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		curThing += 1;
		if(curThing == 70){
			FlxTween.tween(FlxG.camera, {zoom:1.03}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
			curThing = 0;
		}
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'Donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}
				else
				{
				if(curSelected == 0 || curSelected == 2){
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

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
									case 'StoryMode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");

									case 'Freeplay':
										#if debug
											FlxG.switchState(new FreeplayState());
										#else
											if(FlxG.save.data.beatEcho == true){
												FlxG.switchState(new FreeplayState());
											}else{
												camera.shake(0.035, 0.2);
											}
										#end
									case 'Achievements':
										FlxG.switchState(new AchievementState());
								}
							});
						}
					});
				}else{
					#if debug
						FlxG.switchState(new FreeplayState());
					#else
						if(FlxG.save.data.beatEcho == false){
							camera.shake(0.035, 0.2);
						}else{
							FlxG.switchState(new FreeplayState());
						}
					#end
				}
				}
			}
		}

		super.update(elapsed);
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

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
