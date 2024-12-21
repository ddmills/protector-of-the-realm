package domain;

import core.Game;

typedef Cell = {}

class GameMap
{
	public var world(get, never):World;

	public function new() {}

	inline function get_world():World
	{
		return Game.instance.world;
	}
}
