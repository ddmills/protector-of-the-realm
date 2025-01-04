package domain.events;

import ecs.EntityEvent;

class QueryTaskLabelEvent extends EntityEvent
{
	public var label(default, null):String;

	public function new()
	{
		label = "None";
	}

	public function setLabel(label:String)
	{
		this.label = label;
	}
}
