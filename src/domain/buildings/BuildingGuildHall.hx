package domain.buildings;

import domain.components.ActionQueue;
import domain.events.HireActorEvent;
import domain.events.QueryActionsEvent.EntityAction;
import ecs.Entity;

class BuildingGuildHall extends Building
{
	public function new() {}

	override function get_name():String
	{
		return "Guild Hall";
	}

	override function get_height():Int
	{
		return 5;
	}

	override function get_width():Int
	{
		return 5;
	}

	override function getActions(entity:Entity):Array<EntityAction>
	{
		var actionQueue = entity.get(ActionQueue);

		if (actionQueue == null)
		{
			return [];
		}

		var baseActions:Array<EntityAction> = [
			{
				name: "Hire Paladin",
				evt: new HireActorEvent(ACTOR_PALADIN),
				current: 0,
				duration: 5,
			},
			{
				name: "Hire Ogre",
				evt: new HireActorEvent(ACTOR_OGRE),
				current: 0,
				duration: 5,
			}
		];

		for (action in actionQueue.actions)
		{
			var idx = baseActions.findIdx(x -> x.name == action.name);

			if (idx > -1)
			{
				baseActions[idx] = action;
			}
		}

		return baseActions;
	}
}
