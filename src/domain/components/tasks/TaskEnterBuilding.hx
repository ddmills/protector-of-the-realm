package domain.components.tasks;

class TaskEnterBuilding extends TaskComponent
{
	public var buildingEntityId:String;

	public function new(buildingEntityId:String)
	{
		super();
		this.buildingEntityId = buildingEntityId;
	}

	public function getLabel():String
	{
		return "Entering building";
	}
}
