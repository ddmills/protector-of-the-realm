package domain.components.tasks;

class TaskSleep extends TaskComponent
{
	@save public var duration:Float;
	@save public var progress:Float;

	public function new(duration:Float)
	{
		this.duration = duration;
		this.progress = 0;
	}
}
