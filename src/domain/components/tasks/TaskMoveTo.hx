package domain.components.tasks;

class TaskMoveTo extends TaskComponent
{
	@save public var retryAttempts:Int;
	@save public var maxRetryAttempts:Int;

	public function new(retryAttempts:Int)
	{
		super();
		this.maxRetryAttempts = retryAttempts;
		this.retryAttempts = 0;
	}

	override function reset()
	{
		entity.remove(Path);
	}

	public function getLabel():String
	{
		var bb = entity.get(Blackboard);
		return 'Moving to ${bb?.goals[0]?.toString()}';
	}
}
