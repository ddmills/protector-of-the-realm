package domain.components.tasks;

class TaskPickRandomSpot extends TaskComponent
{
	@save public var radius:Int;

	public function new(radius:Int)
	{
		this.radius = radius;
	}
}
