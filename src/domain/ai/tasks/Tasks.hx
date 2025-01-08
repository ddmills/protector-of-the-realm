package domain.ai.tasks;

import domain.components.tasks.TaskComponent;
import domain.components.tasks.TaskMoveTo;
import domain.components.tasks.TaskPickRandomSpot;
import domain.components.tasks.TaskTryMelee;
import domain.components.tasks.TaskWait;

class Tasks
{
	public function new() {}

	public function build(taskType:TaskType):TaskComponent
	{
		return switch taskType
		{
			case TASK_WAIT(duration): new TaskWait(duration);
			case TASK_PICK_RAND_SPOT(radius): new TaskPickRandomSpot(radius);
			case TASK_MOVE_TO(retryAttempts): new TaskMoveTo(retryAttempts);
			case TASK_TRY_MELEE: new TaskTryMelee();
		}
	}

	public function get(taskType:TaskType):Class<TaskComponent>
	{
		return switch taskType
		{
			case TASK_WAIT(_): TaskWait;
			case TASK_PICK_RAND_SPOT(_): TaskPickRandomSpot;
			case TASK_MOVE_TO(_): TaskMoveTo;
			case TASK_TRY_MELEE: TaskTryMelee;
		}
	}
}
