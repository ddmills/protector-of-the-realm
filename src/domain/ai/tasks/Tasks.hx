package domain.ai.tasks;

import domain.components.tasks.TaskComponent;
import domain.components.tasks.TaskMoveTo;
import domain.components.tasks.TaskPickRandomSpot;
import domain.components.tasks.TaskSleep;

class Tasks
{
	public function new() {}

	public function build(taskType:TaskType):TaskComponent
	{
		return switch taskType
		{
			case TASK_SLEEP(duration): new TaskSleep(duration);
			case TASK_PICK_RAND_SPOT(radius):
				new TaskPickRandomSpot(radius);
			case TASK_MOVE_TO: new TaskMoveTo();
		}
	}

	public function get(taskType:TaskType):Class<TaskComponent>
	{
		return switch taskType
		{
			case TASK_SLEEP(_): TaskSleep;
			case TASK_PICK_RAND_SPOT(_): TaskPickRandomSpot;
			case TASK_MOVE_TO: TaskMoveTo;
		}
	}
}
