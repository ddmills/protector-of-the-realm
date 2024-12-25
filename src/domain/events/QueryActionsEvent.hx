package domain.events;

import data.domain.ActorType;
import ecs.EntityEvent;

enum EntityActionType
{
	HIRE_ACTOR(actorType:ActorType);
}

typedef EntityAction =
{
	actionType:EntityActionType,
	current:Float,
	duration:Float,
}

class QueryActionsEvent extends EntityEvent
{
	public var actions(default, null):Array<EntityActionType>;

	public function new()
	{
		actions = new Array();
	}

	public function add(action:EntityActionType)
	{
		actions.push(action);
	}

	public function addAll(actions:Array<EntityActionType>)
	{
		for (action in actions)
		{
			this.actions.push(action);
		}
	}
}
