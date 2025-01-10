package domain.components.behaviors;

import core.Game;
import domain.ai.tree.nodes.BehaviorNode;
import domain.ai.tree.nodes.SequenceNode;
import domain.ai.tree.nodes.TaskNode;

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

		return Game.instance.world.rand.float(20, 30);
	}

	public function build():BehaviorNode
	{
		var blackboard = entity.get(Blackboard);

		blackboard.targetId = targetId;

		return new SequenceNode([new TaskNode(TASK_MOVE_TO(3)), new TaskNode(TASK_WAIT(2))]);
	}

	public function label():String
	{
		return 'Following ${targetId}';
	}

	public function behaviorId():String
	{
		return "follow";
	}
}
