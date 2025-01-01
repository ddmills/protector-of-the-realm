package domain.systems;

import core.Data;
import core.Frame;
import domain.components.Actor;
import domain.components.Behavior;
import domain.components.Blackboard;
import domain.components.IsDestroyed;
import domain.components.IsDetached;
import ecs.Query;
import ecs.System;

class BehaviorScoringSystem extends System
{
	public var query:Query;

	public function new()
	{
		query = new Query({
			all: [Actor],
			none: [Behavior, IsDestroyed, IsDetached],
		});
	}

	override function update(frame:Frame)
	{
		for (entity in query)
		{
			var best = Data.Behaviors.max(b -> b.score(entity));

			var bhv = new Behavior(best.type);
			entity.add(bhv);

			var blackboard = entity.get(Blackboard);
			blackboard.reset();

			best.start(entity);
		}
	}
}
