package domain;

import common.struct.Coordinate;
import core.Game;
import data.domain.SpawnableType;
import domain.events.EntitySpawnedEvent;
import domain.prefabs.GoblinPrefab;
import domain.prefabs.GuildHallPrefab;
import domain.prefabs.OgrePrefab;
import domain.prefabs.PaladinPrefab;
import domain.prefabs.PineTreePrefab;
import domain.prefabs.RangerPrefab;
import domain.prefabs.RoguePrefab;
import domain.prefabs.SkeletonPrefab;
import domain.prefabs.WeedPrefab;
import domain.prefabs.WizardPrefab;

class Spawner
{
	private var prefabs:Map<SpawnableType, Prefab> = new Map();

	public function new() {}

	public function initialize()
	{
		prefabs.set(WEED, new WeedPrefab());
		prefabs.set(GUILD_HALL, new GuildHallPrefab());
		prefabs.set(PALADIN, new PaladinPrefab());
		prefabs.set(ROGUE, new RoguePrefab());
		prefabs.set(WIZARD, new WizardPrefab());
		prefabs.set(RANGER, new RangerPrefab());
		prefabs.set(OGRE, new OgrePrefab());
		prefabs.set(GOBLIN, new GoblinPrefab());
		prefabs.set(SKELETON, new SkeletonPrefab());
		prefabs.set(TREE_PINE, new PineTreePrefab());
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
