package domain;

import common.struct.Coordinate;
import common.struct.IntPoint;
import common.tools.Performance;
import core.Game;
import data.domain.SpawnableType;
import data.resources.AudioKey;
import data.save.SaveWorld;
import domain.Spawner;
import domain.map.FogOfWar;
import domain.map.GameMap;
import domain.map.Terrain;
import domain.systems.SystemManager;
import ecs.Entity;
import hxd.Rand;

class World
{
	public var game(get, null):Game;
	public var systems(default, null):SystemManager;
	public var spawner(default, null):Spawner;
	public var terrain(default, null):Terrain;
	public var fow(default, null):FogOfWar;
	public var inspection(default, null):Inspection;
	public var map(default, null):GameMap;

	public var seed:Int = 2;

	public var rand:Rand;

	public function new()
	{
		systems = new SystemManager();
		spawner = new Spawner();
		spawner.initialize();
	}

	public function initialize()
	{
		rand = new Rand(seed);
		map = new GameMap();
		inspection = new Inspection();
		systems.initialize();
	}

	public function updateSystems()
	{
		systems.update(game.frame);
	}

	public function playAudio(pos:IntPoint, key:AudioKey, threshold:Int = 16)
	{
		game.audio.play(key);
		return true;
	}

	public function newGame(seed:Int)
	{
		this.seed = seed;
		rand = new Rand(seed);
		map = new GameMap();
		inspection = new Inspection();
		fow = new FogOfWar(map.width, map.height);
		terrain = new Terrain(map.width, map.height);

		game.render(GROUND, terrain);
		game.render(HUD, fow);

		game.clock.reset();

		var p = new common.rand.Perlin(1);

		for (x in 0...map.width)
		{
			for (y in 0...map.height)
			{
				var h = p.get(x, y, 14, 3);

				if (h <= .4)
				{
					continue;
				}

				var trees = p.get(x, y, 18, 3);

				if (h > .5 && trees > .55 && rand.bool(.5))
				{
					Spawner.Spawn(TREE_PINE, new Coordinate(x + .5, y + .5, WORLD));
				}
				else if (rand.bool(.001))
				{
					var s:SpawnableType = rand.pick([PALADIN, ROGUE, WIZARD, RANGER, OGRE, GOBLIN, SKELETON]);
					Spawner.Spawn(s, new Coordinate(x + .5, y + .5, WORLD));
				}
			}
		}
	}

	public function load(data:SaveWorld)
	{
		Performance.start('world-load');

		seed = data.seed;
		rand = new Rand(seed);
		map = new GameMap();

		fow = new FogOfWar(map.width, map.height);
		terrain = new Terrain(map.width, map.height);
		game.render(GROUND, terrain);

		inspection = new Inspection();
		game.clock.load(data.clock);
		map.load(data.map);

		for (data in data.entities)
		{
			Entity.Load(data);
		}

		game.camera.load(data.camera);

		Performance.stop('world-load', true);
	}

	public function save(teardown:Bool = false):SaveWorld
	{
		Performance.start('world-save');

		var entities = game.registry.map((e) ->
		{
			var entitySaveData = e.save();

			if (teardown)
			{
				e.destroy();
			}

			return entitySaveData;
		});

		var s:SaveWorld = {
			seed: seed,
			map: map.save(),
			clock: game.clock.save(),
			entities: entities,
			camera: game.camera.save(),
		};

		if (teardown)
		{
			fow.remove();
			terrain.remove();
			systems.teardown();
		}

		Performance.stop('world-save', true);

		return s;
	}

	inline function get_game():Game
	{
		return Game.instance;
	}
}
