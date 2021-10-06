package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class AchievementState extends MusicBeatState
{
	var songs:Array<String> = ['Party Started!', 'Finally peace.', 'How.', 'FC Echo', 'Goop', 'Canceled', 'Balls in yo jaws.'];
	var desc:Array<String> = ['Beat the week on Hard/Echo', 'Beat the week on Normal/Easy', 'FC Scuffle Hell', 'FC Full Week [Echo Difficulty]', 'Get the bad ending', 'sex', 'Up Up Down Down Left Right Left Right'];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var versionShit:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var dif:String;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<AchievementIcon> = [];

	override function create()
	{
		/* 
			if (FlxG.sound.music != null)
			{
				if (!FlxG.sound.music.playing)
					FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
		 */

		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Achievement Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i], true, false, true);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:AchievementIcon = new AchievementIcon('icons');
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);


			if(i == 0 && FlxG.save.data.beatEcho)
			{
				icon.animation.curAnim.curFrame = 1;
			}
			if(i == 1 && FlxG.save.data.beatNormal)
			{
				icon.animation.curAnim.curFrame = 1;
			}
			if(i == 2 && FlxG.save.data.fcHell)
			{
				icon.animation.curAnim.curFrame = 1;
			}
			if(i == 3 && FlxG.save.data.echoFC)
			{
				icon.animation.curAnim.curFrame = 1;
			}
			if(i == 4 && FlxG.save.data.badEnd)
			{
				icon.animation.curAnim.curFrame = 1;
			}
			if(i == 5 && FlxG.save.data.canceled)
			{
				icon.animation.curAnim.curFrame = 1;
			}
			if(i == 6 && FlxG.save.data.balls)
			{
				icon.animation.curAnim.curFrame = 1;
			}

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		versionShit = new FlxText(5, FlxG.height + 40, 0, "a", 15);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		FlxTween.tween(versionShit,{y: FlxG.height - 25},2,{ease: FlxEase.elasticInOut});

		changeSelection();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		versionShit.text = desc[curSelected];

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
				if(iconArray[curSelected].animation.curAnim.curFrame == 1)
				{
					trace('pog');
				}else{
					camera.shake(0.035, 0.2);
				}
		}

		if (controls.BACK)
		{
			FlxG.switchState(new WhereUGoinState());
		}
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}