package domain.events;

import ecs.EntityEvent;

class GameSpeedChange extends EntityEvent
{
	public var speed:Float;

	public function new(speed:Float)
	{
		this.speed = speed;
	}
}
