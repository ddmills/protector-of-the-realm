package domain.actors;

import data.domain.SpawnableType;

class ActorWizard extends Actor
{
	override function get_spawnableType():SpawnableType
	{
		return WIZARD;
	}

	override function get_actorTypeName():String
	{
		return "Wizard";
	}
}
