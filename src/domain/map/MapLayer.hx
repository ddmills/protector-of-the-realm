package domain.map;

import common.struct.Grid;
import core.Game;

class MapLayer
{
	public var map(default, null):GameMap;

	public function new(map:GameMap)
	{
		this.map = map;
	}
}
