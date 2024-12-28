package domain.components;

import data.domain.ActorType;
import ecs.Component;

class Actor extends Component
{
	@save public var actorType:ActorType;

	public function new(actorType:ActorType)
	{
		this.actorType = actorType;
	}
}
