package domain.ai.tasks;

import domain.components.tasks.SleepTask;
import domain.components.tasks.TaskComponent;

class Tasks
{
	public function new() {}

	public function build(taskType:TaskType):TaskComponent
	{
		return switch taskType
		{
			case TASK_SLEEP(duration): new SleepTask(duration);
		}
	}

	public function get(taskType:TaskType):Class<TaskComponent>
	{
		return switch taskType
		{
			case TASK_SLEEP(_): SleepTask;
		}
	}
}
