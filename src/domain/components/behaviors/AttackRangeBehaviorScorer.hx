package domain.components.behaviors;

import core.Game;
import domain.actors.TeamType;
import domain.ai.tree.nodes.BehaviorNode;
import domain.ai.tree.nodes.SequenceNode;
import domain.ai.tree.nodes.TaskNode;

class AttackRangeBehaviorScorer extends BehaviorScorerComponent
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

		var closest = Game.instance.world.map.hostility
			.getWithinRange(enemyTeamType, entity.x.floor(), entity.y.floor(), vision)
			.min((v) -> v.distance);

		if (closest == null)
		{
			return 0;
		}

		targetId = closest.entityId;

		return 100 - (closest.distance * 5);
	}

	public function build():BehaviorNode
	{
		var blackboard = entity.get(Blackboard);

		blackboard.targetId = targetId;

		var sleep = Game.instance.world.rand.float(.5, 1.5);

		return new SequenceNode([new TaskNode(TASK_ATTACK_RANGE), new TaskNode(TASK_WAIT(sleep))]);
	}

	public function label():String
	{
		return 'Range Fighting';
	}

	public function behaviorId():String
	{
		return 'range-$targetId';
	}
}
