package domain.events;

import data.domain.ActorType;
import ecs.EntityEvent;

class HireActorEvent extends EntityEvent
{
	public var actorType:ActorType;

	public function new(actorType:ActorType)
	{
		this.actorType = actorType;
	}
}
