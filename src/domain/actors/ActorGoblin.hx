package domain.actors;

import data.domain.SpawnableType;

class ActorGoblin extends Actor
{
	override function get_spawnableType():SpawnableType
	{
		return GOBLIN;
	}

	override function get_actorTypeName():String
	{
		return "Goblin";
	}
}
