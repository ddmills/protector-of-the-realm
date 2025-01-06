package domain.components;

import common.struct.IntPoint;
import ecs.Component;

class Blackboard extends Component
{
	@save public var timer:Float;
	@save public var goals:Array<IntPoint>;
	@save public var targetId:String;
	@save public var path:Array<IntPoint>;

	public function new()
	{
		reset();
	}

	public function reset()
	{
		timer = 0;
		goals = [];
		path = null;
		targetId = null;
	}
}
