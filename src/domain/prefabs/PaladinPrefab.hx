package domain.prefabs;

import common.struct.Coordinate;
import common.struct.IntPoint;
import core.Game;
import domain.components.ActionQueue;
import domain.components.Collider;
import domain.components.Inspectable;
import domain.components.Label;
import domain.components.Monster;
import domain.components.Sprite;
import domain.components.Vision;
import ecs.Entity;

class PaladinPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var e = new Entity(pos);

		var r = Game.instance.world.rand;
		var sprite = new Sprite(TK_PALADIN, OBJECTS);

		sprite.bm.filter = new h2d.filter.Outline(.5, 0x1C1C1C, .3, true);

		e.add(sprite);
		e.add(new Label('Paladin'));
		e.add(new Collider(POINT, new IntPoint(0, 0), [FLG_UNIT]));
		e.add(new Monster());
		e.add(new Vision(6));
		e.add(new Inspectable("Paladin", 16));
		e.add(new ActionQueue());

		return e;
	}
}
