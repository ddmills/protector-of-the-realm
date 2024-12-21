package domain;

import common.struct.Cardinal;
import common.struct.Coordinate;
import common.struct.IntPoint;
import common.tools.Performance;
import core.Game;
import data.resources.AudioKey;
import data.save.SaveWorld;
import domain.Spawner;
import domain.systems.SystemManager;
import ecs.Entity;
import hxd.Rand;

class World
{
	public var game(get, null):Game;
	public var systems(default, null):SystemManager;
	public var spawner(default, null):Spawner;
	public var mapWidth(default, null):Int;
	public var mapHeight(default, null):Int;
	public var terrain(default, null):Terrain;

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
		mapWidth = 320;
		mapHeight = 320;
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
		terrain = new Terrain(mapWidth, mapHeight);
		game.render(GROUND, terrain);
		game.clock.reset();

		var p = new common.rand.Perlin(1);

		for (x in 0...mapWidth)
		{
			for (y in 0...mapHeight)
			{
				if (rand.bool(.05) && p.get(x, y, 16, 3) < .4)
				{
					Spawner.Spawn(WEED, new Coordinate(x + .5, y + .5, WORLD));
				}
				else if (rand.bool(.005))
				{
					Spawner.Spawn(HERO, new Coordinate(x + .5, y + .5, WORLD));
				}
				else if (rand.bool(.0025))
				{
					Spawner.Spawn(OGRE, new Coordinate(x + .5, y + .5, WORLD));
				}
			}
		}
	}

	public function load(data:SaveWorld)
	{
		Performance.start('world-load');

		seed = data.seed;
		rand = new Rand(seed);
		terrain = new Terrain(mapWidth, mapHeight);
		game.render(GROUND, terrain);
		game.clock.load(data.clock);

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

		if (teardown)
		{
			terrain.remove();
		}

		var entities = game.registry.map((e) ->
		{
			var entitySaveData = e.save();

			e.destroy();

			return entitySaveData;
		});

		var s = {
			seed: seed,
			clock: game.clock.save(),
			entities: entities,
			camera: game.camera.save(),
		};

		Performance.stop('world-save', true);

		return s;
	}

	public overload extern inline function getEntitiesAt(pos:IntPoint):Array<Entity>
	{
		// return ids.map((id:String) -> game.registry.getEntity(id));
		return new Array<Entity>();
	}

	public overload extern inline function getEntitiesAt(pos:Coordinate):Array<Entity>
	{
		return getEntitiesAt(pos.toWorld().toIntPoint());
	}

	public function getEntitiesInRect(pos:IntPoint, width, height):Array<Entity>
	{
		var entities:Array<Entity> = [];

		for (x in pos.x...(pos.x + width))
		{
			for (y in pos.y...(pos.y + height))
			{
				entities = entities.concat(getEntitiesAt(new IntPoint(x, y)));
			}
		}

		return entities;
	}

	public function getEntitiesInRange(pos:IntPoint, range:Int):Array<Entity>
	{
		var diameter = (range * 2) + 1;
		var topLeft = pos.sub(new IntPoint(range, range));
		return getEntitiesInRect(topLeft, diameter, diameter);
	}

	public function getNeighborEntities(pos:IntPoint):Array<Array<Entity>>
	{
		// todo - just make faster by removing cardinal calls?
		return [
			getEntitiesAt(pos.add(Cardinal.NORTH_WEST.toOffset())), // NORTH_WEST
			getEntitiesAt(pos.add(Cardinal.NORTH.toOffset())), // NORTH
			getEntitiesAt(pos.add(Cardinal.NORTH_EAST.toOffset())), // NORTH_EAST
			getEntitiesAt(pos.add(Cardinal.WEST.toOffset())), // WEST
			getEntitiesAt(pos.add(Cardinal.EAST.toOffset())), // EAST
			getEntitiesAt(pos.add(Cardinal.SOUTH_WEST.toOffset())), // SOUTH_WEST
			getEntitiesAt(pos.add(Cardinal.SOUTH.toOffset())), // SOUTH
			getEntitiesAt(pos.add(Cardinal.SOUTH_EAST.toOffset())), // SOUTH_EAST
		];
	}

	inline function get_game():Game
	{
		return Game.instance;
	}

	public inline function isOutOfBounds(pos:IntPoint)
	{
		return pos.x < 0 || pos.y < 0 || pos.x > mapWidth || pos.y > mapHeight;
	}

	public inline function getTileIdx(pos:IntPoint)
	{
		return pos.y * mapWidth + pos.x;
	}

	public inline function getTilePos(idx:Int):IntPoint
	{
		var w = mapWidth;
		return {
			x: Math.floor(idx % w),
			y: Math.floor(idx / w),
		}
	}
}
