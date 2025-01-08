package domain.components.behaviors;

import core.Game;
import domain.actors.TeamType;
import domain.ai.tree.nodes.BehaviorNode;
import domain.ai.tree.nodes.SequenceNode;
import domain.ai.tree.nodes.TaskNode;

class MeleeFightBehaviorScorer extends BehaviorScorerComponent
{
	var targetId:String;

	public function score():Float
	{
		var team = entity.get(Team);

		if (team == null)
		{
			return 0;
		}

		var enemyTeamType = team.teamType == PLAYER ? TeamType.MONSTER : TeamType.PLAYER;

		var vision = entity.get(Vision).range;

		var nearby = Game.instance.world.map.hostility
			.getWithinRange(enemyTeamType, entity.x.floor(), entity.y.floor(), vision)
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

				return true;
			});

		// var rand = Game.instance.world.rand.pick(nearby);
		var rand = nearby.min((v) -> v.distance);

		if (rand == null)
		{
			return 0;
		}

		targetId = rand.entityId;

		return 100;
	}

	public function build():BehaviorNode
	{
		var blackboard = entity.get(Blackboard);

		blackboard.targetId = targetId;

		var sleep = Game.instance.world.rand.float(.5, 1.5);

		return new SequenceNode([
			new TaskNode(TASK_MOVE_TO(3)),
			new TaskNode(TASK_TRY_MELEE),
			new TaskNode(TASK_WAIT(sleep))
		]);
	}

	public function label():String
	{
		return 'Melee Fighting';
	}
}
