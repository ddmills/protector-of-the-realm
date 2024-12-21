package domain.prefabs;

import common.struct.Coordinate;
import common.struct.FloatPoint;
import common.struct.IntPoint;
import core.Game;
import data.resources.TileKey;
import domain.components.Collider;
import domain.components.Interactive;
import domain.components.Monster;
import domain.components.Sprite;
import ecs.Entity;

class PaladinPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var e = new Entity(pos);

		var r = Game.instance.world.rand;
		var k = r.pick([TK_PALADIN, TK_WIZARD, TK_ROGUE]);
		var sprite = new Sprite(k, OBJECTS);

		// sprite.origin = new FloatPoint(.5, .5);

		sprite.bm.filter = new h2d.filter.Outline(.5, 0x1C1C1C, .3, true);

		e.add(sprite);
		e.add(new Collider(POINT, new IntPoint(0, 0), [FLG_UNIT]));
		e.add(new Monster());
		e.add(new Interactive(32));

		return e;
	}
}
