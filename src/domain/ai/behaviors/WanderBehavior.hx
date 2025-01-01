package domain.ai.behaviors;

import domain.components.Blackboard;
import ecs.Entity;

class WanderBehavior extends Behavior
{
	public function new()
	{
		super(BHV_WANDER);
		this.label = "Wandering";
	}

	override function start(entity:Entity)
	{
		var blackboard = entity.get(Blackboard);
		blackboard.timer = world.rand.integer(100, 5000);
		trace('wander');
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
