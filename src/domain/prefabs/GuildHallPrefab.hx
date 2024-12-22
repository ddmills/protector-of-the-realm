package domain.prefabs;

import common.struct.Coordinate;
import common.struct.FloatPoint;
import common.struct.IntPoint;
import core.Game;
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

		e.add(new Building("Guild Hall", 9, 9));

		var sprite = new Sprite(TK_GUILD_HALL);

		sprite.width = Game.TILE_SIZE * 5;
		sprite.height = Game.TILE_SIZE * 5;
		sprite.origin = new FloatPoint(.5, .5);

		sprite.bm.filter = new h2d.filter.Outline(.5, 0x1C1C1C, .3, true);
		e.add(sprite);

		var collider = new Collider(RECTANGLE(5, 5), new IntPoint(0, 0), [FLG_BUILDING]);
		e.add(collider);

		e.add(new Interactive(64));

		return e;
	}
}
