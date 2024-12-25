package domain.buildings;

import data.domain.ActorType;

enum JobType
{
	HIRE_ACTOR(actorType:ActorType);
}

typedef BuildingQueueJob =
{
	jobType:JobType,
	current:Float,
	duration:Float,
}
