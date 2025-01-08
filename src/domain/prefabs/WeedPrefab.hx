package domain.prefabs;

import common.struct.Coordinate;
import common.struct.FloatPoint;
import core.Game;
import data.resources.TileKey;
import domain.components.IsExplorable;
import domain.components.Label;
import domain.components.Sprite;
import ecs.Entity;

class WeedPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var e = new Entity(pos);
		e.add(new Label('Weed'));
		e.add(new IsExplorable());

		var r = Game.instance.world.rand;
		var k = r.pick([TK_WEED_01, TK_WEED_02, TK_WEED_03]);

		var sprite = new Sprite(k, OBJECTS);
		sprite.width = 32;
		sprite.height = 32;
		sprite.origin = new FloatPoint(.5, .9);

		e.add(sprite);

		return e;
	}
}
