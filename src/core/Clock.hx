package core;

import core.Frame;
import core.Game;
import domain.events.GameSpeedChange;

typedef SaveClock =
{
	tick:Float,
	speed:Float,
}

class Clock
{
	private var _speed:Float = 1;

	/**
	 * In-game seconds
	 */
	public var tick(default, null):Float;

	/**
	 * Speed of the game, 2 speed = 2 in-game seconds per actual second 
	 */
	public var speed(get, set):Float;

	/**
	 * Pause the game
	 */
	public var isPaused(default, set):Bool = false;

	public function new()
	{
		tick = 0;
	}

	public function save():SaveClock
	{
		return {
			tick: tick,
			speed: _speed,
		}
	}

	public function load(save:SaveClock)
	{
		_speed = save.speed;
		tick = save.tick;
		isPaused = true;
	}

	public function update(frame:Frame)
	{
		if (!isPaused)
		{
			tick += frame.dt * speed;
		}
	}

	public function reset()
	{
		tick = 0;
		_speed = 1;
		isPaused = false;
	}

	function set_speed(value:Float):Float
	{
		if (_speed != value)
		{
			_speed = value;
			triggerSpeedUpdate();
		}
		return value;
	}

	function set_isPaused(value:Bool):Bool
	{
		if (isPaused != value)
		{
			isPaused = value;
			triggerSpeedUpdate();
		}
		return value;
	}

	private function triggerSpeedUpdate()
	{
		var s = isPaused ? 0 : _speed;
		for (e in Game.instance.registry)
		{
			e.fireEvent(new GameSpeedChange(s));
		}
	}

	function get_speed():Float
	{
		return isPaused ? 0 : _speed;
	}
}
