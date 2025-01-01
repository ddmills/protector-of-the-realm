package domain.ai.behaviors;

import common.struct.DataRegistry;

class Behaviors extends DataRegistry<BehaviorType, Behavior>
{
	public function new()
	{
		super();

		register(BHV_IDLE, new IdleBehavior());
		register(BHV_WANDER, new WanderBehavior());
	}
}
