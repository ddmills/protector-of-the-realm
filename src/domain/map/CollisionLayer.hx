package domain.map;

import common.struct.Grid;
import common.struct.Set;

class CollisionLayer extends MapLayer
{
	public var grid:Grid<Set<String>>;

	public function init()
	{
		grid = new Grid(map.width, map.height);
		grid.fillFn(i -> new Set());
	}

	public function get(x:Int, y:Int):Set<String>
	{
		return grid.get(x, y);
	}
}
