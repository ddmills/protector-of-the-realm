package domain.prefabs;

import common.struct.Coordinate;
import common.struct.IntPoint;
import core.Game;
import data.resources.TileKey;
import domain.components.Collider;
import domain.components.Label;
import domain.components.Sprite;
import ecs.Entity;

class WeedPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var e = new Entity(pos);
		e.add(new Label('Weed'));

		var r = Game.instance.world.rand;
		var k = r.pick([TK_WEED_01, TK_WEED_02, TK_WEED_03]);

		e.add(new Sprite(k, OBJECTS));
		e.add(new Collider(POINT, new IntPoint(0, 0), [FLG_OBJECT]));

		return e;
	}
}
