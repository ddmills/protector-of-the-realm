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
	public var position(default, null):PositionLayer;

	public function new()
	{
		vision = new VisionLayer(this);
		collision = new CollisionLayer(this);
		position = new PositionLayer(this);

		vision.init();
		collision.init();
		position.init();
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
		return pos.x < 0 || pos.y < 0 || pos.x >= width || pos.y >= height;
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

	public inline function getEntitiesAt(x:Int, y:Int):Array<Entity>
	{
		return getEntityIdsAt(x, y).map((id:String) -> Game.instance.registry.getEntity(id));
	}

	public inline function getEntityIdsAt(x:Int, y:Int):Array<String>
	{
		return position.getEntityIdsAt(x, y);
	}

	inline function get_world():World
	{
		return Game.instance.world;
	}
}
