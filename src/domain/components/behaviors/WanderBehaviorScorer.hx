package domain.components.behaviors;

import core.Game;
import domain.ai.tree.nodes.BehaviorNode;
import domain.ai.tree.nodes.FailNode;
import domain.ai.tree.nodes.RetryNode;
import domain.ai.tree.nodes.SequenceNode;
import domain.ai.tree.nodes.TaskNode;
import domain.ai.tree.nodes.TryNode;

class WanderBehaviorScorer extends BehaviorScorerComponent
{
	public function score():Float
	{
		return Game.instance.world.rand.float(20, 100);
	}

	public function label()
	{
		return "Wandering";
	}

	public function build():BehaviorNode
	{
		var radius = Game.instance.world.rand.integer(5, 200);
		var sleep = Game.instance.world.rand.float(0, 2);

		return new SequenceNode([
			new TaskNode(TASK_PICK_RAND_SPOT(radius)),
			new RetryNode(new TryNode(new TaskNode(TASK_MOVE_TO), new SequenceNode([new TaskNode(TASK_SLEEP(sleep)), new FailNode()])), 5),
			new TaskNode(TASK_SLEEP(2))
		]);
	}
}
