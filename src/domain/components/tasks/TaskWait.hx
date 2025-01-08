package domain.components.tasks;

class TaskWait extends TaskComponent
{
	@save public var duration:Float;
	@save public var progress:Float;

	public function new(duration:Float)
	{
		super();
		this.duration = duration;
		this.progress = 0;
	}

	public function getLabel():String
	{
		var percent = (progress / duration) * 100;
		return 'Waiting ${percent.floor()}%';
	}
}
