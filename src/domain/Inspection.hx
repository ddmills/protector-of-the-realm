package domain;

import ecs.Entity;

class Inspection
{
	public var selected:Entity;

	public var isInspecting(get, never):Bool;

	public function new() {}

	public function select(entity:Entity)
	{
		selected = entity;
	}

	public function clear()
	{
		selected = null;
	}

	function get_isInspecting():Bool
	{
		return selected != null;
	}
}
