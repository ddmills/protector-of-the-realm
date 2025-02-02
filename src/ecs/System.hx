package ecs;

import core.Frame;
import core.Game;
import domain.World;

class System
{
	public var game(get, null):Game;
	public var world(get, null):World;

	inline function get_game():Game
	{
		return Game.instance;
	}

	inline function get_world():World
	{
		return game.world;
	}

	/**
	 * Called on every frame
	 */
	public function update(frame:Frame) {}

	/**
	 * Called on teardown
	 */
	public function teardown() {}
}
