package domain.actors;

import data.domain.SpawnableType;

class ActorPaladin extends Actor
{
	override function get_spawnableType():SpawnableType
	{
		return PALADIN;
	}

	override function get_actorTypeName():String
	{
		return "Paladin";
	}
}
