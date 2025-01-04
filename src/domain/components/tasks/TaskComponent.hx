package domain.components.tasks;

import domain.ai.TaskStateType;
import domain.events.QueryTaskLabelEvent;
import ecs.Component;

abstract class TaskComponent extends Component
{
	@save public var state:TaskStateType = EXECUTING;

	public function new()
	{
		addHandler(QueryTaskLabelEvent, onQueryTaskLabel);
	}

	private function onQueryTaskLabel(evt:QueryTaskLabelEvent)
	{
		evt.setLabel(getLabel());
	}

	public abstract function getLabel():String;
}
