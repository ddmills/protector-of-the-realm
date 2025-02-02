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
		return 2;
	}

	override function get_width():Int
	{
		return 2;
	}

	override function getActions(entity:Entity):Array<EntityActionType>
	{
		return [
			HIRE_ACTOR(ACTOR_PALADIN),
			HIRE_ACTOR(ACTOR_ROGUE),
			HIRE_ACTOR(ACTOR_WIZARD),
			HIRE_ACTOR(ACTOR_RANGER),
			HIRE_ACTOR(ACTOR_SKELETON),
			HIRE_ACTOR(ACTOR_GOBLIN),
			HIRE_ACTOR(ACTOR_OGRE)
		];
	}
}
