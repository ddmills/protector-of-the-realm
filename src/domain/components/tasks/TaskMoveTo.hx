package domain.components.tasks;

class TaskMoveTo extends TaskComponent
{
	@save public var attempted:Bool = false;

	public function new()
	{
		super();
	}

	public function getLabel():String
	{
		var bb = entity.get(Blackboard);
		return 'Moving to ${bb?.goals[0]?.toString()}';
	}
}
