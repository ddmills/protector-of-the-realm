package domain.buildings;

import domain.events.QueryActionsEvent.EntityActionType;
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

	override function getActions(entity:Entity):Array<EntityActionType>
	{
		return [HIRE_ACTOR(ACTOR_PALADIN), HIRE_ACTOR(ACTOR_OGRE),];
	}
}
