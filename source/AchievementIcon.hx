package;

import flixel.FlxSprite;

class AchievementIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	public function new(char:String = 'icons', isPlayer:Bool = false)
	{
		super();
		loadGraphic(Paths.image('Yoo'), true, 150, 150);

		antialiasing = true;
		animation.add('icons', [0, 1], 0, false, isPlayer);
		
		animation.play(char);
		antialiasing = true;
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
