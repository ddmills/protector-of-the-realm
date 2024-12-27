package domain.map;

import common.struct.Grid;

class MapLayer<T>
{
	private var map(default, null):GameMap;

	public var grid:Grid<T>;

	public function new(map:GameMap)
	{
		this.map = map;
		grid = new Grid(map.width, map.height);
	}

	public function get(x:Int, y:Int):T
	{
		return grid.get(x, y);
	}

	public function getAt(idx:Int):T
	{
		return grid.getAt(idx);
	}
}
