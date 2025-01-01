package domain.ai.behaviors;

import core.Game;
import ecs.Entity;
import haxe.EnumTools;

class Behavior
{
	public var world(get, never):World;
	public var label(default, null):String;
	public var type(default, null):BehaviorType;

	public function new(type:BehaviorType)
	{
		this.type = type;
		this.label = EnumValueTools.getName(this.type);
	}

	public function start(entity:Entity) {}

	public function act(entity:Entity):Bool
	{
		trace('do behavior', entity.id);
		return true;
	}

	public function score(entity:Entity):Float
	{
		return 0;
	}

	function get_world():World
	{
		return Game.instance.world;
	}
}
