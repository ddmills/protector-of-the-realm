package data.resources;

import h2d.Tile;

class AnimationResources
{
	public static var animations:Map<AnimationKey, Array<Tile>> = [];

	public static function Get(key:AnimationKey):Array<Tile>
	{
		if (key.isNull())
		{
			return null;
		}

		var animation = animations.get(key);

		// if (animation.isNull())
		// {
		// 	return animations.get(AK_UNKNOWN);
		// }

		return animation;
	}

	public static function Init() {}
}
