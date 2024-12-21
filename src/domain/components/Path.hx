package domain.components;

import common.struct.IntPoint;
import domain.systems.ColliderSystem.ColliderFlag;
import ecs.Component;

class Path extends Component
{
	@save public var instructions:Array<IntPoint>;
	@save public var collider_flags:Array<ColliderFlag>;
	@save public var curIdx:Int;

	public var length(get, never):Int;
	public var remaining(get, never):Int;
	public var current(get, never):IntPoint;

	public function new(instructions:Array<IntPoint>, collider_flags:Array<ColliderFlag>)
	{
		this.instructions = instructions;
		this.collider_flags = collider_flags;
		curIdx = 0;
	}

	inline function get_length():Int
	{
		return instructions.length;
	}

	inline function get_current():IntPoint
	{
		return instructions[curIdx];
	}

	inline function get_remaining():Int
	{
		return (length - 1) - curIdx;
	}

	/**
	 * Advance the current node in the path
	**/
	public function next():IntPoint
	{
		curIdx++;
		return current;
	}

	public function hasNext():Bool
	{
		return remaining > 0;
	}
}
