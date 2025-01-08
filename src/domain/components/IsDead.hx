package domain.components;

import ecs.Component;

class IsDead extends Component
{
	public var cause:String;

	public function new(cause:String)
	{
		this.cause = cause;
	}
}
