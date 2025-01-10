package domain.ai.tasks;

import domain.components.tasks.TaskAttackMelee;
import domain.components.tasks.TaskAttackRange;
import domain.components.tasks.TaskComponent;
import domain.components.tasks.TaskEnterBuilding;
import domain.components.tasks.TaskMoveTo;
import domain.components.tasks.TaskPickRandomSpot;
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
			case TASK_ATTACK_MELEE: new TaskAttackMelee();
			case TASK_ATTACK_RANGE: new TaskAttackRange();
			case TASK_ENTER_BUILDING(buildingEntityId): new TaskEnterBuilding(buildingEntityId);
		}
	}

	public function get(taskType:TaskType):Class<TaskComponent>
	{
		return switch taskType
		{
			case TASK_WAIT(_): TaskWait;
			case TASK_PICK_RAND_SPOT(_): TaskPickRandomSpot;
			case TASK_MOVE_TO(_): TaskMoveTo;
			case TASK_ATTACK_MELEE: TaskAttackMelee;
			case TASK_ATTACK_RANGE: TaskAttackRange;
			case TASK_ENTER_BUILDING(_): TaskEnterBuilding;
		}
	}
}
