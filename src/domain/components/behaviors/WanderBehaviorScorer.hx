package domain.components.behaviors;

import core.Game;
import domain.ai.tree.nodes.BehaviorNode;
import domain.ai.tree.nodes.TaskNode;

class WanderBehaviorScorer extends BehaviorScorerComponent
{
	public function score():Float
	{
		return Game.instance.world.rand.float(20, 100);
	}

	public function build():BehaviorNode
	{
		var radius = Game.instance.world.rand.integer(5, 10);

		return new TaskNode(TASK_MOVE_TO);
	}
}
