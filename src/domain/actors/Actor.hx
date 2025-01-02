package domain.actors;

import data.domain.SpawnableType;

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
}
