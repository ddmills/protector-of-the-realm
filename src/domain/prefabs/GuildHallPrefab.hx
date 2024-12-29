package domain.prefabs;

import common.struct.Coordinate;
import common.struct.FloatPoint;
import common.struct.IntPoint;
import core.Data;
import core.Game;
import domain.components.ActionQueue;
import domain.components.Building;
import domain.components.Collider;
import domain.components.Inspectable;
import domain.components.IsExplorable;
import domain.components.IsPlayer;
import domain.components.Label;
import domain.components.Sprite;
import domain.components.Vision;
import ecs.Entity;

class GuildHallPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var e = new Entity(pos);
		var building = Data.Buildings.get(BLDG_GUILD_HALL);

		e.add(new Label('Guild Hall'));
		e.add(new Building(BLDG_GUILD_HALL));
		e.add(new ActionQueue());
		e.add(new IsPlayer());

		var sprite = new Sprite(TK_GUILD_HALL);

		sprite.width = Game.TILE_WIDTH * 5;
		sprite.height = Game.TILE_HEIGHT * 5;
		sprite.origin = new FloatPoint(.5, .5);

		e.add(sprite);

		var collider = new Collider(RECTANGLE(building.width, building.height), new IntPoint(0, 0), [FLG_BUILDING]);
		e.add(collider);

		e.add(new Inspectable(building.name, 64));
		e.add(new IsExplorable());
		e.add(new Vision(10));

		return e;
	}
}
