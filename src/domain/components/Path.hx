package domain.components;

import common.struct.IntPoint;
import core.Game;
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
	public var goal(get, never):IntPoint;

	public var waitDuration:Float;
	public var maxWaitDuration:Float;

	public function new(instructions:Array<IntPoint>, collider_flags:Array<ColliderFlag>)
	{
		this.instructions = instructions;
		this.collider_flags = collider_flags;
		maxWaitDuration = Game.instance.world.rand.float(1, 4);
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
	 * Peek at the next node in the path
	**/
	public inline function peek():IntPoint
	{
		return instructions[curIdx + 1];
	}

	/**
	 * Advance the current node in the path
	**/
	public inline function next():IntPoint
	{
		curIdx++;
		return current;
	}

	public inline function hasNext():Bool
	{
		return remaining > 0;
	}

	inline function get_goal():IntPoint
	{
		return instructions[length - 1];
	}
}
