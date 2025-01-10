package domain.ai.tasks;

enum TaskType
{
	TASK_WAIT(duration:Float);
	TASK_PICK_RAND_SPOT(radius:Int);
	TASK_MOVE_TO(retryAttempts:Int);
	TASK_ENTER_BUILDING(buildingEntityId:String);
	TASK_ATTACK_MELEE;
	TASK_ATTACK_RANGE;
}
