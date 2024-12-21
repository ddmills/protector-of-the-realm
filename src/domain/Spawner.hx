package domain;

import common.struct.Coordinate;
import core.Game;
import data.domain.SpawnableType;
import domain.events.EntitySpawnedEvent;
import domain.prefabs.GuildHallPrefab;
import domain.prefabs.OgrePrefab;
import domain.prefabs.PaladinPrefab;
import domain.prefabs.WeedPrefab;

class Spawner
{
	private var prefabs:Map<SpawnableType, Prefab> = new Map();

	public function new() {}

	public function initialize()
	{
		prefabs.set(WEED, new WeedPrefab());
		prefabs.set(GUILD_HALL, new GuildHallPrefab());
		prefabs.set(HERO, new PaladinPrefab());
		prefabs.set(OGRE, new OgrePrefab());
	}

	public function spawn(type:SpawnableType, ?pos:Coordinate, ?options:Dynamic)
	{
		var p = pos == null ? new Coordinate(0, 0, WORLD) : pos.toWorld();
		var o = options == null ? {} : options;
		var entity = prefabs.get(type).Create(o, p);

		entity.pos = p;

		entity.fireEvent(new EntitySpawnedEvent());

		return entity;
	}

	public static function Spawn(type:SpawnableType, ?pos:Coordinate, ?options:Dynamic)
	{
		return Game.instance.world.spawner.spawn(type, pos, options);
	}
}
