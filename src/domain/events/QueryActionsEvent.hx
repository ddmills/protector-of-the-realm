package domain.events;

import ecs.EntityEvent;

typedef EntityAction =
{
	name:String,
	evt:EntityEvent,
}

class QueryActionsEvent extends EntityEvent
{
	public var actions(default, null):Array<EntityAction>;

	public function new()
	{
		actions = new Array();
	}

	public function add(action:EntityAction)
	{
		actions.push(action);
	}

	public function addAll(actions:Array<EntityAction>)
	{
		for (action in actions)
		{
			this.actions.push(action);
		}
	}
}
