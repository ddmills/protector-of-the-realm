package domain.actors;

import data.domain.SpawnableType;

class ActorRogue extends Actor
{
	override function get_spawnableType():SpawnableType
	{
		return ROGUE;
	}

	override function get_actorTypeName():String
	{
		return "Rogue";
	}
}
