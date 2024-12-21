package domain.components;

import ecs.Component;

class Interactive extends Component
{
	@save public var radius(default, null):Int;

	public function new(radius:Int)
	{
		this.radius = radius;
	}
}
