package domain.events;

import domain.buildings.BuildingQueue.BuildingQueueJob;
import ecs.EntityEvent;

class QueueBuildingJobEvent extends EntityEvent
{
	public var job:BuildingQueueJob;

	public function new(job:BuildingQueueJob)
	{
		this.job = job;
	}
}
