package domain.actors;

import data.domain.SpawnableType;
import domain.ai.behaviors.BehaviorType;

class Actor
{
	public var spawnableType(get, never):SpawnableType;
	public var actorTypeName(get, never):String;

	public function new() {}

	function get_spawnableType():SpawnableType
	{
		return OGRE;
	}

	function get_actorTypeName():String
	{
		return "Unknown";
	}

	public function getDefaultBehaviors():Array<BehaviorType>
	{
		return [BHV_IDLE, BHV_WANDER];
	}
}
