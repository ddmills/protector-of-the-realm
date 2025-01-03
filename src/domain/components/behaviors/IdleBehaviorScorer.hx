package domain.components.behaviors;

import core.Game;
import domain.ai.tree.nodes.BehaviorNode;
import domain.ai.tree.nodes.TaskNode;

class IdleBehaviorScorer extends BehaviorScorerComponent
{
	public function score():Float
	{
		return Game.instance.world.rand.float(0, 50);
	}

	public function build():BehaviorNode
	{
		var duration = Game.instance.world.rand.float(1, 10);

		return new TaskNode(TASK_SLEEP(duration));
	}
}
