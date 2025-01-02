package domain.components.tasks;

import core.Frame;
import domain.ai.TaskStateType;
import ecs.Component;

abstract class TaskComponent extends Component
{
	@save public var state:TaskStateType = EXECUTING;

	public function update(frame:Frame) {}
}
