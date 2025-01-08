package domain.components.behaviors;

import core.Game;
import domain.ai.tree.nodes.BehaviorNode;
import domain.ai.tree.nodes.SequenceNode;
import domain.ai.tree.nodes.TaskNode;

class WanderBehaviorScorer extends BehaviorScorerComponent
{
	public function score():Float
	{
		return Game.instance.world.rand.float(10, 30);
	}

	public function label()
	{
		return "Wandering";
	}

	public function build():BehaviorNode
	{
		var radius = Game.instance.world.rand.integer(5, 50);

		return new SequenceNode([
			new TaskNode(TASK_PICK_RAND_SPOT(radius)),
			new TaskNode(TASK_MOVE_TO(3)),
			new TaskNode(TASK_WAIT(2))
		]);
	}

	public function behaviorId():String
	{
		return "wander";
	}
}
