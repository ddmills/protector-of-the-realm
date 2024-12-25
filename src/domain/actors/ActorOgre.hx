package domain.actors;

import data.domain.SpawnableType;

class ActorOgre extends Actor
{
	override function get_spawnableType():SpawnableType
	{
		return OGRE;
	}

	override function get_actorTypeName():String
	{
		return "Ogre";
	}
}
