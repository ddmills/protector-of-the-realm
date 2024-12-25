package domain.components;

import core.Data;
import data.domain.BuildingType;
import domain.buildings.BuildingQueue.BuildingQueueJob;
import domain.events.QueryActionsEvent;
import domain.events.QueueBuildingJobEvent;
import ecs.Component;

class Building extends Component
{
	@save public var buildingType:BuildingType;
	@save public var queue:Array<BuildingQueueJob>;

	public var building(get, never):domain.buildings.Building;

	public function new(buildingType:BuildingType)
	{
		this.buildingType = buildingType;
		this.queue = [];

		addHandler(QueryActionsEvent, onQueryActions);
		addHandler(QueueBuildingJobEvent, onQueueBuildingJob);
	}

	private function onQueryActions(evt:QueryActionsEvent)
	{
		var actions = building.getActions(entity);

		evt.addAll(actions);
	}

	private function onQueueBuildingJob(evt:QueueBuildingJobEvent)
	{
		trace('JOB', evt.job.jobType);
		queue.push(evt.job);
	}

	function get_building():domain.buildings.Building
	{
		return Data.Buildings.get(buildingType);
	}
}
