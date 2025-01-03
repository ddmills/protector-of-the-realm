package domain.components;

import common.struct.IntPoint;
import ecs.Component;

class Blackboard extends Component
{
	@save public var timer:Float;
	@save public var goal:IntPoint;
	@save public var path:Array<IntPoint>;

	public function new()
	{
		reset();
	}

	public function reset()
	{
		timer = 0;
		goal = null;
		path = null;
	}
}
