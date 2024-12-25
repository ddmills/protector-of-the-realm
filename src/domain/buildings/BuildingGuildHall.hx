package domain.buildings;

import domain.events.QueryActionsEvent.EntityAction;
import domain.events.QueueBuildingJobEvent;
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
		return [
			{
				name: "Hire Paladin",
				evt: new QueueBuildingJobEvent({
					jobType: HIRE_ACTOR(ACTOR_PALADIN),
					current: 0,
					duration: 4,
				}),
			},
			{
				name: "Hire Ogre",
				evt: new QueueBuildingJobEvent({
					jobType: HIRE_ACTOR(ACTOR_OGRE),
					current: 0,
					duration: 8,
				}),
			}
		];
	}
}
