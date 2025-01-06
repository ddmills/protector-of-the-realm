package domain.map;

class MapLayer
{
	public var map(default, null):GameMap;

	public function new(map:GameMap)
	{
		this.map = map;
	}
}
