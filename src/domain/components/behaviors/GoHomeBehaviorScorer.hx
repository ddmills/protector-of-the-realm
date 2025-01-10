package domain.components.behaviors;

import domain.ai.tree.nodes.BehaviorNode;
import domain.ai.tree.nodes.SequenceNode;
import domain.ai.tree.nodes.TaskNode;

class GoHomeBehaviorScorer extends BehaviorScorerComponent
{
	public function score():Float
	{
		var hasHome = entity.has(Resident);

		if (!hasHome)
		{
			return 0;
		}

		var hp = entity.get(Health);

		return (1 - hp.percent) * 100;
	}

	public function label()
	{
		return "Going home";
	}

	public function build():BehaviorNode
	{
		var resident = entity.get(Resident);
		var buildingEnt = resident.getBuilding();
		var building = buildingEnt.get(Building);
		var goals = building.getNeighborTiles();
		var bb = entity.get(Blackboard);

		bb.goals = goals;

		return new SequenceNode([
			new TaskNode(TASK_MOVE_TO(3)),
			new TaskNode(TASK_ENTER_BUILDING(buildingEnt.id)),
			new TaskNode(TASK_WAIT(20))
		]);
	}

	public function behaviorId():String
	{
		return "home";
	}
}
