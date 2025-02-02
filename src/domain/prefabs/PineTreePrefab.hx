package domain.prefabs;

import common.struct.Coordinate;
import common.struct.FloatPoint;
import common.struct.IntPoint;
import core.Game;
import data.resources.TileKey;
import domain.components.Collider;
import domain.components.IsExplorable;
import domain.components.Label;
import domain.components.Sprite;
import ecs.Entity;

class PineTreePrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var e = new Entity(pos);
		e.add(new Label('Pine Tree'));

		var r = Game.instance.world.rand;
		var k = r.pick([
			TK_TREE_PINE_01,
			TK_TREE_PINE_02,
			TK_TREE_PINE_03,
			TK_TREE_PINE_04,
			TK_TREE_PINE_05,
			TK_TREE_PINE_06,
			TK_TREE_PINE_07,
			TK_TREE_PINE_08,
		]);

		var s = new Sprite(k, OBJECTS);

		s.width = 32 * 2;
		s.height = 80 * 2;

		s.origin = new FloatPoint(.5, .9);

		e.add(s);
		e.add(new Collider(POINT, new IntPoint(0, 0), [FLG_OBJECT]));
		e.add(new IsExplorable());

		return e;
	}
}
