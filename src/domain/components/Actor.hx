package domain.components;

import data.domain.ActorType;
import domain.ai.behaviors.BehaviorType;
import ecs.Component;

class Actor extends Component
{
	@save public var actorType:ActorType;
	@save public var behaviorTypes:Array<BehaviorType>;

	public function new(actorType:ActorType, behaviorTypes:Array<BehaviorType>)
	{
		this.actorType = actorType;
		this.behaviorTypes = behaviorTypes;
	}
}
