package domain.prefabs;

import common.struct.Coordinate;
import common.struct.FloatPoint;
import common.struct.IntPoint;
import domain.components.Building;
import domain.components.Collider;
import domain.components.Interactive;
import domain.components.Sprite;
import ecs.Entity;

class GuildHallPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var e = new Entity(pos);

		e.add(new Building("Guild Hall", 7));

		var sprite = new Sprite(TK_GUILD_HALL);

		sprite.width = 128;
		sprite.height = 128;
		sprite.origin = new FloatPoint(.5, .85);

		sprite.bm.filter = new h2d.filter.Outline(.5, 0x1C1C1C, .3, true);
		e.add(sprite);

		var collider = new Collider(CIRCLE(2), new IntPoint(0, 0), [FLG_BUILDING]);
		e.add(collider);

		e.add(new Interactive(64));

		return e;
	}
}
