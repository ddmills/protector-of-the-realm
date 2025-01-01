package domain.ai.behaviors;

import domain.components.Blackboard;
import ecs.Entity;

class IdleBehavior extends Behavior
{
	public function new()
	{
		super(BHV_IDLE);
		this.label = "Idling";
	}

	override function start(entity:Entity)
	{
		var blackboard = entity.get(Blackboard);
		blackboard.timer = world.rand.integer(400, 5000);
		trace('idle');
	}

	override function act(entity:Entity):Bool
	{
		var blackboard = entity.get(Blackboard);

		blackboard.timer -= 1;

		return blackboard.timer >= 0;
	}

	override function score(entity:Entity):Float
	{
		return world.rand.float(0, 100);
	}
}
