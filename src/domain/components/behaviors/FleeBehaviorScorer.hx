package domain.components.behaviors;

import core.Game;
import domain.actors.TeamType;
import domain.ai.tree.nodes.BehaviorNode;
import domain.ai.tree.nodes.SequenceNode;
import domain.ai.tree.nodes.TaskNode;

class FleeBehaviorScorer extends BehaviorScorerComponent
{
	public function score():Float
	{
		var hp = entity.get(Health);

		if (hp.percent > .4)
		{
			return 0;
		}

		var team = entity.get(Team);

		if (team == null)
		{
			return 0;
		}

		var enemyTeamType = team.teamType == PLAYER ? TeamType.MONSTER : TeamType.PLAYER;
		var nearby = Game.instance.world.map.hostility.getWithinRange(enemyTeamType, entity.x.floor(), entity.y.floor(), 5);

		if (nearby.length == 0)
		{
			return 0;
		}

		return (1 - hp.percent) * 100 * nearby.length;
	}

	public function label()
	{
		return "Fleeing!";
	}

	public function build():BehaviorNode
	{
		var radius = Game.instance.world.rand.integer(5, 50);

		return new SequenceNode([new TaskNode(TASK_PICK_RAND_SPOT(radius)), new TaskNode(TASK_MOVE_TO(3))]);
	}

	public function behaviorId():String
	{
		return "flee";
	}
}
