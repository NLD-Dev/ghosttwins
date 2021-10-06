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
import openfl.media.Sound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;


class Achievement extends FlxSpriteGroup
{
	var NameThing:FlxText;
	var DescThing:FlxText;
	var DescThing2:FlxText;
	var WhatIgetThing:FlxText; 
	var Names:Array<String> = [
		'lloud',
		'Marie',
		'Mike',
		'NLD',
		'Pap',
		'Penny',
		'Relp',
		'Saka',
		'Tanner',
		'Tanrie',
		'Tohru',
		'Torchic'
	];
	var Sprites:Array<FlxSprite> = [];

	public function new(yooo:String, desc:String, dataName:String, whatiget:String = '', desc2:String = '')
	{
		super();

		for (i in 0...Names.length)
		{
			var newSprite:FlxSprite = new FlxSprite(25, FlxG.height + 40).loadGraphic(Paths.image('achievements/' + Names[i], 'ghosttwins'));
			newSprite.setGraphicSize(Std.int(newSprite.width * 0.15));
			newSprite.updateHitbox();
			newSprite.scrollFactor.set();
			newSprite.visible = false;
			Sprites.push(newSprite);
			add(Sprites[i]);
		}

		var What = FlxG.random.int(0, 11);
		var name = Names[What];
		trace(name);
		var Obj = Sprites[What];
		Obj.visible = true;
		FlxTween.tween(Obj,{y: FlxG.height - 270},2,{ease: FlxEase.elasticInOut});
		NameThing = new FlxText(300, FlxG.height + 40, 0, yooo, 32);
		NameThing.scrollFactor.set();
		NameThing.setFormat("VCR OSD Mono", 17, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(NameThing);
		FlxTween.tween(NameThing,{y: FlxG.height - 145},2,{ease: FlxEase.elasticInOut});
		DescThing = new FlxText(330, FlxG.height + 40, 0, desc, 15);
		DescThing.scrollFactor.set();
		DescThing.setFormat("VCR OSD Mono", 15, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(DescThing);
		FlxTween.tween(DescThing,{y: FlxG.height - 115},2,{ease: FlxEase.elasticInOut});
		DescThing2 = new FlxText(330, FlxG.height + 40, 0, desc2, 15);
		DescThing2.scrollFactor.set();
		DescThing2.setFormat("VCR OSD Mono", 15, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(DescThing2);
		FlxTween.tween(DescThing2,{y: FlxG.height - 95},2,{ease: FlxEase.elasticInOut});
		WhatIgetThing = new FlxText(300, FlxG.height + 40, 0, whatiget, 15);
		WhatIgetThing.scrollFactor.set();
		WhatIgetThing.setFormat("VCR OSD Mono", 13, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(WhatIgetThing);
		FlxTween.tween(WhatIgetThing,{y: FlxG.height - 65},2,{ease: FlxEase.elasticInOut});

		switch(dataName){
			case 'beatEcho':
				FlxG.save.data.beatEcho = true;
			case 'beatNormal':
				FlxG.save.data.beatNormal = true;
			case 'fcHell':
				FlxG.save.data.fcHell = true;
			case 'echoFC':
				FlxG.save.data.echoFC = true;
			case 'badEnd':
				FlxG.save.data.badEnd = true;
			case 'canceled':
				FlxG.save.data.canceled = true;
			case 'balls':
				FlxG.save.data.balls = true;
		}
		new FlxTimer().start(4, function(tmr:FlxTimer)
		{
			FlxTween.tween(Obj,{y: FlxG.height + 1000},2,{ease: FlxEase.elasticInOut});
			FlxTween.tween(NameThing,{y: FlxG.height + 1000},2,{ease: FlxEase.elasticInOut});
			FlxTween.tween(DescThing,{y: FlxG.height + 1000},2,{ease: FlxEase.elasticInOut});
			FlxTween.tween(DescThing2,{y: FlxG.height + 1000},2,{ease: FlxEase.elasticInOut});
			FlxTween.tween(WhatIgetThing,{y: FlxG.height + 1000},2,{ease: FlxEase.elasticInOut});
			new FlxTimer().start(4, function(tmr:FlxTimer)
			{
				remove(Obj);
				remove(NameThing);
				remove(DescThing);
				remove(WhatIgetThing);
			});
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
