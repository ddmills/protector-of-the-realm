package domain.components.behaviors;

import core.Game;
import domain.ai.tree.nodes.BehaviorNode;
import domain.ai.tree.nodes.NotNode;
import domain.ai.tree.nodes.TaskNode;

class WanderBehaviorScorer extends BehaviorScorerComponent
{
	public function score():Float
	{
		return Game.instance.world.rand.float(0, 100);
	}

	public function build():BehaviorNode
	{
		var duration = Game.instance.world.rand.integer(5, 10);

		return new NotNode(new TaskNode(TASK_SLEEP(duration)));
	}
}
