package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;
	var name:FlxText;
	var ayo:FlxText;
	var theDog:FlxText;
	var bgBlack:FlxSprite;
	var bgBlack2:FlxSprite;

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	var swagDialogue:FlxTypeText;

	var talking:String;
	var framename:String;
	var overwrite:String;
	var fade:String;
	var holdTimer:Int;
	var observe:Bool = false;
	var balls:Bool = false;

	var firsttime:Int = 5;

	//sound
	var whatlineamiatbro:Int = 0;
	var curSound:FlxSound;

	var framesLol:Array<FlxSprite> = [];

	var skipDialogue:Bool = false;

	public var finishThing:Void->Void;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

				FlxG.sound.music = null;

				FlxG.sound.playMusic(Paths.music('loopdialogue', 'dialogue'),0.6);

		this.dialogueList = dialogueList;
		whatlineamiatbro = 0;
		if(PlayState.SONG.song.toLowerCase() == 'hat-tip'){
			firsttime = 6;
		}
		theDog = new FlxText(5, FlxG.height *  0.95, 0, "Hold S to skip dialogue", 64);
		theDog.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(theDog);
		ayo = new FlxText(5, FlxG.height * 0.4, 0, "Skipping dialogue...", 64);
		ayo.screenCenter();
		ayo.alpha = 0;
		ayo.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		bgBlack2 = new FlxSprite(100).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bgBlack2.screenCenter();
		bgBlack2.alpha = 0;
		bgBlack = new FlxSprite(100).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bgBlack.screenCenter();
		add(bgBlack);

		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			default:
					box = new FlxSprite(-100).loadGraphic(Paths.image('dialogueb', 'dialogue'));
					box.scrollFactor.x = 0;
					box.scrollFactor.y = 0.10;
					box.setGraphicSize(Std.int(box.width * 0.335));
					box.updateHitbox();
					box.screenCenter();
					box.antialiasing = true;
					add(box);
		}
		
		hasDialog = true;

		if (!hasDialog)
				return;

		//box.screenCenter(X);

		swagDialogue = new FlxTypeText(240, 545, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Lampshade';
		swagDialogue.color = FlxColor.WHITE;
		swagDialogue.borderColor = FlxColor.BLACK;
		add(swagDialogue);

		name = new FlxText(240, 495, 0, talking, 32);
		var color = 0xFFFFFFFF;
		switch(talking){
			default:
				color = 0xFF546166;
			case 'Girlfriend':
				color = 0xFFA5004D;
			case 'Boyfriend':
				color = 0xFF51A5EC;
			case 'T & M':
				color = 0xFF282A3D;
			case 'Marie':
				color = 0xFF151515;
			case 'Tanner':
				color = 0xFFFFFFFF;
			case 'Tanrie':
				color = 0xFFEDEDED;
		}
		name.setFormat(Paths.font("Lampshade-VBEx.otf"), 44, color, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.WHITE);
		name.scrollFactor.set();
		add(name);

		dialogue = new Alphabet(0, 80, "", false, true);
	}

	var dialogueOpened:Bool = true;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{

		if (dialogueOpened && !dialogueStarted)
		{
				startDialogue();
				dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding && balls == false)
				{
					if (curSound != null && curSound.playing){
						curSound.stop();
					}

					isEnding = true;

					FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.05, function(tmr:FlxTimer)
					{
							box.alpha -= 1 / 7;
							swagDialogue.alpha -= 1 / 7;
							for (frame in framesLol)
							{
								frame.alpha -= 1 / 7;
							}
							name.alpha -= 1 / 7;
							bgBlack.alpha -= 1 / 7;
							bgBlack2.alpha = 0;
							ayo.alpha -= 1 / 7;
							theDog.alpha -= 1 / 7;
					}, 7);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
							finishThing();
							kill();
					});
				}
			}
			else
			{
					dialogueList.remove(dialogueList[0]);
					startDialogue();
			}
		}
		if(balls == true){
		if (isEnding)
				{
					if (curSound != null && curSound.playing){
						curSound.stop();
					}
					isEnding = false;
					dialogueStarted = false;

					FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.05, function(tmr:FlxTimer)
					{
							box.alpha -= 1 / 7;
							swagDialogue.alpha -= 1 / 7;
							for (frame in framesLol)
							{
								frame.alpha -= 1 / 7;
							}
							name.alpha -= 1 / 7;
							bgBlack.alpha -= 1 / 7;
							bgBlack2.alpha = 0;
							ayo.alpha -= 1 / 7;
							theDog.alpha -= 1 / 7;
					}, 7);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
							finishThing();
							kill();
					});
				}
		}
		if (FlxG.keys.justPressed.S) {
			holdTimer = 0;
			bgBlack2.destroy();
			bgBlack2 = new FlxSprite(100).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			bgBlack2.screenCenter();
			bgBlack2.alpha = 0;
			add(bgBlack2);
			ayo.destroy();
			ayo = new FlxText(5, FlxG.height * 0.4, 0, "Skipping dialogue...", 64);
			ayo.screenCenter();
			ayo.alpha = 0;
			ayo.setFormat("VCR OSD Mono", 72, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			add(ayo);
			FlxTween.tween(bgBlack2, {alpha: 0.4}, 1, {ease: FlxEase.circOut});
			FlxTween.tween(ayo, {alpha: 1}, 1, {ease: FlxEase.circOut});
		}

		if (FlxG.keys.pressed.S) {
			holdTimer++;
			if(holdTimer > 300){
				isEnding = true;
				holdTimer = 0;
				balls = true;
			}
		}   else {
			if(bgBlack2.alpha > 0.01){
				FlxTween.tween(bgBlack2, {alpha: 0}, 1, {ease: FlxEase.circOut});
				FlxTween.tween(ayo, {alpha: 0}, 1, {ease: FlxEase.circOut});
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function hideAllFrames():Void
	{
		//hide all in this array
		for (frame in framesLol)
		{
				//remove frame
				frame.visible = false;
		}
	}

	function startDialogue():Void
	{
		//functions to get shit	part 1
		cleanDialog();
		
		switch(talking.toLowerCase()){
				case 'skip':
						//fuck u go awayu
						skipDialogue = true;
				case 'observe':
						skipDialogue = false;
						observe = true;
				default:
						//hell no stay
						skipDialogue = false;
						observe = false;
						//sound shit yeaaah
								whatlineamiatbro++;

								if(FlxG.save.data.voiceActing)
									playSound();
		}

		//functions to get shit	part 2
		if(overwrite == 'true'){  hideAllFrames();   }
		createFrame();
		if(observe == false){updateBoxShit();}else{observeBox();}

		//start text
		if(skipDialogue == false){
				swagDialogue.resetText(dialogueList[0]);
				swagDialogue.start(0.04, true);
		}else{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
		}
	}

	function playSound():Void{
		if (Paths.exists(Paths.sound(PlayState.SONG.song.toLowerCase() + '/' + Std.string(whatlineamiatbro), 'dialogue'))){
			if (curSound != null && curSound.playing){
				curSound.stop();
			}
			curSound = new FlxSound().loadEmbedded(Paths.sound(PlayState.SONG.song.toLowerCase() + '/' + Std.string(whatlineamiatbro), 'dialogue'));
			curSound.play();
		}
	}

	function observeBox():Void{
		if(!(box.alpha == 0)){
		box.destroy();
		box = new FlxSprite(-100).loadGraphic(Paths.image('dialogueb', 'dialogue'));
		box.scrollFactor.x = 0;
		box.scrollFactor.y = 0.10;
		box.setGraphicSize(Std.int(box.width * 0.335));
		box.updateHitbox();
		box.screenCenter();
		box.antialiasing = true;
		add(box);
		FlxTween.tween(box, {alpha: 0}, 1, {ease: FlxEase.circOut});
		}
	}

	function updateBoxShit():Void
	{
		//sussy box
		var fadein = false;
		if((box.alpha == 0)){
			fadein = true;
		}
		box.destroy();
		box = new FlxSprite(-100).loadGraphic(Paths.image('dialogueb', 'dialogue'));
		box.scrollFactor.x = 0;
		box.scrollFactor.y = 0.10;
		box.setGraphicSize(Std.int(box.width * 0.335));
		box.updateHitbox();
		box.screenCenter();
		box.antialiasing = true;
		add(box);
		if(fadein){
			box.alpha = 0;
			FlxTween.tween(box, {alpha: 1}, 1, {ease: FlxEase.circOut});
		}
		//sussy text
			swagDialogue.destroy();
			swagDialogue = new FlxTypeText(240, 545, Std.int(FlxG.width * 0.67), "", 32);
			swagDialogue.font = 'Lampshade';
			swagDialogue.color = FlxColor.WHITE;
			swagDialogue.borderColor = FlxColor.BLACK;
			add(swagDialogue);
			//ayo is that da name
		var color = 0xFFFFFFFF;
		switch(talking){
			default:
				color = 0xFF546166;
			case 'Girlfriend':
				color = 0xFFA5004D;
			case 'Boyfriend':
				color = 0xFF51A5EC;
			case 'T & M':
				color = 0xFF282A3D;
			case 'Marie':
				color = 0xFF151515;
			case 'Tanner':
				color = 0xFFFFFFFF;
			case 'Tanrie':
				color = 0xFFEDEDED;
		}
				name.destroy();
				name = new FlxText(240, 495, 0, talking, 32);
				name.setFormat(Paths.font("Lampshade-VBEx.otf"), 44, color, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.WHITE);
				name.scrollFactor.set();
				add(name);
				//ayo the dog
					theDog.destroy();
					theDog = new FlxText(5, FlxG.height *  0.95, 0, "Hold S to skip dialogue", 64);
					theDog.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
					add(theDog);
	}

	function createFrame():Void
	{
		//adding the frame if framename isnt null
		if(framename == 'stopit' || framename == 'null' || framename == null){
				trace('null');
		}else{
			//make sure lol!
			if (Paths.exists(Paths.image(PlayState.SONG.song.toLowerCase() + '/' + framename, 'dialogue'))){
				var frame:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image(PlayState.SONG.song.toLowerCase() + '/' + framename, 'dialogue'));
				frame.scrollFactor.x = 0;
				frame.scrollFactor.y = 0.10;
				frame.setGraphicSize(Std.int(frame.width * 0.335));
				frame.updateHitbox();
				frame.screenCenter();
				frame.antialiasing = true;
				framesLol.push(frame);
				add(frame);
			//hol up tho!! what if we want it to fade like a sussy baka it is
			if(fade == 'true')
			{
					frame.alpha = 0;
					FlxTween.tween(frame, {alpha : 1}, 1, {ease: FlxEase.circOut});
			}
			if(fade == 'shake')
			{
					camera.shake(0.035, 0.3);
			}
			if(fade == 'flash')
			{
					FlxG.camera.flash(FlxColor.WHITE);
			}
			}
		}
	}

	function cleanDialog():Void
	{
		//getting the dialogue line
		var splitName:Array<String> = dialogueList[0].split(':');
		talking = splitName[1];
		framename = splitName[2];
		overwrite = splitName[3];
		fade = splitName[4];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + splitName[2].length + splitName[3].length + splitName[4].length + firsttime).trim();
		firsttime = 5;
	}
}
