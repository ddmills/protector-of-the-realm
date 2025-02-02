package domain.map;

import common.struct.Grid;
import common.struct.GridMap;
import common.struct.IntPoint;

class PositionLayer extends MapLayer
{
	public var entities:GridMap<String>;

	public function init()
	{
		entities = new Grid(map.width, map.height);
	}

	public function getEntityIdsAt(x:Int, y:Int):Array<String>
	{
		return entities.get(x, y);
	}

	public function getPosition(entityId:String):IntPoint
	{
		return entities.getPosition(entityId);
	}

	public function updateEntityPosition(entityId:String, x:Int, y:Int)
	{
		entities.set(x, y, entityId);
	}

	public function removeEntity(entityId:String)
	{
		entities.remove(entityId);
	}
}
