package domain.components;

import ecs.Component;

class Inspectable extends Component
{
	@save public var displayName(default, null):String;
	@save public var radius(default, null):Int;

	public function new(displayName:String, radius:Int)
	{
		this.displayName = displayName;
		this.radius = radius;
	}
}
