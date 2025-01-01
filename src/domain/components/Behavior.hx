package domain.components;

import domain.ai.behaviors.BehaviorType;
import ecs.Component;

class Behavior extends Component
{
	public var behaviorType:BehaviorType;

	public function new(behaviorType:BehaviorType)
	{
		this.behaviorType = behaviorType;
	}
}
