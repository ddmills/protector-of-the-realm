package domain.actors;

import data.domain.SpawnableType;

class ActorRanger extends Actor
{
	override function get_spawnableType():SpawnableType
	{
		return RANGER;
	}

	override function get_actorTypeName():String
	{
		return "Ranger";
	}
}
