package domain.events;

import common.struct.Coordinate;
import ecs.EntityEvent;

class EntityWorldMovedEvent extends EntityEvent
{
	public var current:Coordinate;
	public var previous:Coordinate;

	public function new(current:Coordinate, previous:Coordinate)
	{
		this.current = current;
		this.previous = previous;
	}
}
