package domain.components.behaviors;

import core.Game;
import domain.ai.tree.nodes.BehaviorNode;
import domain.ai.tree.nodes.FailNode;
import domain.ai.tree.nodes.RetryNode;
import domain.ai.tree.nodes.SequenceNode;
import domain.ai.tree.nodes.TaskNode;
import domain.ai.tree.nodes.TryNode;

class FollowBehaviorScorer extends BehaviorScorerComponent
{
	var targetId:String;

	public function score():Float
	{
		var team = entity.get(Team);

		if (team == null)
		{
			return 0;
		}

		var nearby = Game.instance.world.map.hostility
			.getWithinRange(team.teamType, entity.x.floor(), entity.y.floor(), 6)
			.filter(x ->
			{
				if (x.entityId == entity.id)
				{
					return false;
				}

				var e = Game.instance.registry.getEntity(x.entityId);

				if (e == null)
				{
					return false;
				}

				if (!e.has(Actor))
				{
					return false;
				}

				return true;
			});

		var rand = Game.instance.world.rand.pick(nearby);

		if (rand == null)
		{
			return 0;
		}

		targetId = rand.entityId;

		return Game.instance.world.rand.float(50, 100);
	}

	public function build():BehaviorNode
	{
		var blackboard = entity.get(Blackboard);

		blackboard.targetId = targetId;

		var sleep = Game.instance.world.rand.float(0, 1);

		return new SequenceNode([
			new RetryNode(new TryNode(new TaskNode(TASK_MOVE_TO), new SequenceNode([new TaskNode(TASK_SLEEP(sleep)), new FailNode()])), 5),
			new TaskNode(TASK_SLEEP(2))
		]);
	}

	public function label():String
	{
		return 'Following ${targetId}';
	}
}
