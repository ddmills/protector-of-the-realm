package domain.events;

import domain.events.QueryActionsEvent.EntityAction;
import ecs.EntityEvent;

class QueueActionEvent extends EntityEvent
{
	public var action:EntityAction;

	public function new(action:EntityAction)
	{
		this.action = action;
	}
}
