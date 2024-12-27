package domain.components;

import ecs.Component;

class Label extends Component
{
	@save public var text:String;

	public function new(text:String)
	{
		this.text = text;
	}
}
