package domain.prefabs;

import common.struct.Coordinate;
import common.struct.FloatPoint;
import common.struct.IntPoint;
import domain.components.Collider;
import domain.components.Inspectable;
import domain.components.Monster;
import domain.components.Sprite;
import ecs.Entity;

class OgrePrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var e = new Entity(pos);

		var sprite = new Sprite(TK_OGRE, OBJECTS);

		sprite.width = 40;
		sprite.height = 40;
		sprite.origin = new FloatPoint(.5, .5);

		sprite.bm.filter = new h2d.filter.Outline(.5, 0x1C1C1C, .3, true);

		e.add(sprite);
		e.add(new Collider(POINT, new IntPoint(0, 0), [FLG_UNIT]));
		// e.add(new Collider(CIRCLE(1), new IntPoint(0, 0), [FLG_UNIT]));
		e.add(new Monster());
		e.add(new Inspectable("Ogre", 32));

		return e;
	}
}
