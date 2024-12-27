package domain.map;

import common.struct.Cardinal;
import common.struct.IntPoint;
import core.Game;
import domain.map.VisionLayer.SaveVisionLayer;
import ecs.Entity;

typedef SaveGameMap =
{
	width:Int,
	height:Int,
	vision:SaveVisionLayer,
}

class GameMap
{
	public var world(get, never):World;
	public var width(default, null):Int = 320;
	public var height(default, null):Int = 320;
	public var vision(default, null):VisionLayer;
	public var collision(default, null):CollisionLayer;

	public function new()
	{
		vision = new VisionLayer(this);
		collision = new CollisionLayer(this);

		vision.init();
		collision.init();
	}

	public function save():SaveGameMap
	{
		return {
			width: width,
			height: height,
			vision: vision.save(),
		};
	}

	public function load(data:SaveGameMap)
	{
		width = data.width;
		height = data.height;
		vision.load(data.vision);
	}

	public inline function isOutOfBounds(pos:IntPoint)
	{
		return pos.x < 0 || pos.y < 0 || pos.x > width || pos.y > height;
	}

	public inline function getTileIdx(pos:IntPoint)
	{
		return pos.y * width + pos.x;
	}

	public inline function getTilePos(idx:Int):IntPoint
	{
		return {
			x: Math.floor(idx % width),
			y: Math.floor(idx / width),
		};
	}

	public inline function getEntitiesAt(pos:IntPoint):Array<Entity>
	{
		// return ids.map((id:String) -> game.registry.getEntity(id));
		return new Array<Entity>();
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

	inline function get_world():World
	{
		return Game.instance.world;
	}
}
