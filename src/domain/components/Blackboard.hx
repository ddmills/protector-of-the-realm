package domain.components;

import ecs.Component;

class Blackboard extends Component
{
	@save public var timer:Float;

	public function new()
	{
		reset();
	}

	public function reset()
	{
		timer = 0;
	}
}
