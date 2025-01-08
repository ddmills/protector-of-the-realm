package domain.ai.tasks;

enum TaskType
{
	TASK_WAIT(duration:Float);
	TASK_PICK_RAND_SPOT(radius:Int);
	TASK_MOVE_TO(retryAttempts:Int);
	TASK_TRY_MELEE;
}
