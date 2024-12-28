package domain.actors;

import data.domain.SpawnableType;

class ActorSkeleton extends Actor
{
	override function get_spawnableType():SpawnableType
	{
		return SKELETON;
	}

	override function get_actorTypeName():String
	{
		return "Skeleton";
	}
}
