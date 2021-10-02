package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
	*DEBUG MODE
 */
class AnimationDebug extends FlxState
{
	var bf:Boyfriend;
	var dad:Character;
	var fakedad:Character;
	var char:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var isDad:Bool = true;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;
	var xoffset:Float = 0;
	var yoffset:Float = 0;
	var xoffsetbf:Float = 0;
	var yoffsetbf:Float = 0;
	var selected:String;

	public function new(daAnim:String = 'spooky')
	{
		super();
		this.daAnim = daAnim;
	}

	override function create()
	{
		FlxG.sound.music.stop();

		var gridBG:FlxSprite = FlxGridOverlay.create(50, 50);
		gridBG.scrollFactor.set(0.5, 0.5);
		gridBG.alpha -= 0.5;
		add(gridBG);

		if (daAnim == 'bf')
			isDad = false;

		fakedad = new Character(100, -50, 'dad');
		fakedad.debugMode = true;
		add(fakedad);

		dad = new Character(100, -50, daAnim);
		dad.debugMode = true;
		add(dad);

		xoffset = dad.x;
		yoffset = dad.y;


		char = dad;
		dad.flipX = false;

		bf = new Boyfriend(770, 300);
		bf.debugMode = false;
		add(bf);

		xoffsetbf = bf.x;
		yoffsetbf = bf.y;

		selected = "dad";

		//char = bf;
		bf.flipX = false;

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(300, 16);
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		add(textAnim);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		super.create();
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;

		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.BLUE;
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
		}
		if(char == dad)
		{
		var xof = xoffset - 100;
		var yof = yoffset + 50;
		var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, "dad.x :" + xof, 15);
		text.scrollFactor.set();
		text.color = FlxColor.BLUE;
		dumbTexts.add(text);

		daLoop++;
		var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, "dad.y :" + yof, 15);
		text.scrollFactor.set();
		text.color = FlxColor.BLUE;
		dumbTexts.add(text);

		daLoop++;
		}else
		{
		var xof = xoffsetbf - 770;
		var yof = yoffsetbf - 300;
		var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, "bf.x :" + xof, 15);
		text.scrollFactor.set();
		text.color = FlxColor.BLUE;
		dumbTexts.add(text);

		daLoop++;
		var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, "bf.y :" + yof, 15);
		text.scrollFactor.set();
		text.color = FlxColor.BLUE;
		dumbTexts.add(text);

		daLoop++;
		}
		var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, "selected : " + selected, 15);
		text.scrollFactor.set();
		text.color = FlxColor.ORANGE;
		dumbTexts.add(text);

		daLoop++;
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text);
		});
	}

	override function update(elapsed:Float)
	{
		var holdShift = FlxG.keys.pressed.SHIFT;
		var holdCtrl = FlxG.keys.pressed.CONTROL;
		var multiplier = 1;
		var multiplier2 = 20;
		if (holdShift)
			multiplier = 10;

		if(holdCtrl)
			multiplier2 = 2;

		textAnim.text = char.animation.curAnim.name;

		if (FlxG.keys.justPressed.E)
			FlxG.camera.zoom += 0.25;
		if (FlxG.keys.justPressed.Q)
			FlxG.camera.zoom -= 0.25;
		if(multiplier2 == 2)
		{
		if (FlxG.keys.pressed.UP && multiplier == 1)
		{
			char.animOffsets.get(animList[curAnim])[1] += 1;
			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}
		if (FlxG.keys.pressed.DOWN && multiplier == 1)
		{
			char.animOffsets.get(animList[curAnim])[1] -= 1;
			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}
		if (FlxG.keys.pressed.LEFT && multiplier == 1)
		{
			char.animOffsets.get(animList[curAnim])[0] += 1;
			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}
		if (FlxG.keys.pressed.RIGHT && multiplier == 1)
		{
			char.animOffsets.get(animList[curAnim])[0] -= 1;
			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}
		}else
		{
			if (FlxG.keys.justPressed.UP && multiplier == 1)
		{
			char.animOffsets.get(animList[curAnim])[1] += 1;
			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}
		if (FlxG.keys.justPressed.DOWN && multiplier == 1)
		{
			char.animOffsets.get(animList[curAnim])[1] -= 1;
			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}
		if (FlxG.keys.justPressed.LEFT && multiplier == 1)
		{
			char.animOffsets.get(animList[curAnim])[0] += 1;
			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}
		if (FlxG.keys.justPressed.RIGHT && multiplier == 1)
		{
			char.animOffsets.get(animList[curAnim])[0] -= 1;
			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}
		}


		if(multiplier2 == 2)
		{
		if(char == dad)
		{
		if (FlxG.keys.pressed.UP && multiplier == 10)
		{
			yoffset -= 1;
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.pressed.DOWN && multiplier == 10)
		{
			yoffset += 1;
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.pressed.LEFT && multiplier == 10)
		{
			xoffset -= 1;
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.pressed.RIGHT && multiplier == 10)
		{
			xoffset += 1;
			updateTexts();
			genBoyOffsets(false);
		}
		}
		else{
			if (FlxG.keys.pressed.UP && multiplier == 10)
		{
			yoffsetbf -= 1;
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.pressed.DOWN && multiplier == 10)
		{
			yoffsetbf += 1;
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.pressed.LEFT && multiplier == 10)
		{
			xoffsetbf -= 1;
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.pressed.RIGHT && multiplier == 10)
		{
			xoffsetbf += 1;
			updateTexts();
			genBoyOffsets(false);
		}
		}
		}else
		{
		if(char == dad)
		{
		if (FlxG.keys.justPressed.UP && multiplier == 10)
		{
			yoffset -= 1;
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.justPressed.DOWN && multiplier == 10)
		{
			yoffset += 1;
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.justPressed.LEFT && multiplier == 10)
		{
			xoffset -= 1;
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.justPressed.RIGHT && multiplier == 10)
		{
			xoffset += 1;
			updateTexts();
			genBoyOffsets(false);
		}
		}
		else{
		if (FlxG.keys.justPressed.RIGHT && multiplier == 10)
		{
			xoffsetbf += 1;
			updateTexts();
			genBoyOffsets(false);
		}
			if (FlxG.keys.justPressed.UP && multiplier == 10)
		{
			yoffsetbf -= 1;
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.justPressed.DOWN && multiplier == 10)
		{
			yoffsetbf += 1;
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.justPressed.LEFT && multiplier == 10)
		{
			xoffsetbf -= 1;
			updateTexts();
			genBoyOffsets(false);
		}
		if (FlxG.keys.justPressed.RIGHT && multiplier == 10)
		{
			xoffsetbf += 1;
			updateTexts();
			genBoyOffsets(false);
		}
		}
		}
		

		dad.x = xoffset;
		dad.y = yoffset;
		bf.x = xoffsetbf;
		bf.y = yoffsetbf;

		if (FlxG.keys.justPressed.ESCAPE)
		{	
			
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}

		if (FlxG.keys.justPressed.W)
		{
			curAnim -= 1;
		}

		if (FlxG.keys.justPressed.S)
		{
			curAnim += 1;
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(animList[curAnim]);

			updateTexts();
			genBoyOffsets(false);
		}
		

		super.update(elapsed);
	}
}
