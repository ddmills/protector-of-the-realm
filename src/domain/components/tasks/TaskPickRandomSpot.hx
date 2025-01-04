package domain.components.tasks;

class TaskPickRandomSpot extends TaskComponent
{
	@save public var radius:Int;

	public function new(radius:Int)
	{
		super();
		this.radius = radius;
	}

	public function getLabel():String
	{
		return "Picking a random spot";
	}
}
