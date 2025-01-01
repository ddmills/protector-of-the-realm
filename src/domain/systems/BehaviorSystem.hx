package domain.systems;

import core.Data;
import core.Frame;
import domain.components.Actor;
import domain.components.Behavior;
import domain.components.IsDestroyed;
import ecs.Query;
import ecs.System;

class BehaviorSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [Actor, Behavior],
			none: [IsDestroyed]
		});
	}

	override function update(frame:Frame)
	{
		for (e in query)
		{
			var bhvType = e.get(Behavior).behaviorType;
			var bhv = Data.Behaviors.get(bhvType);

			if (!bhv.act(e))
			{
				e.remove(Behavior);
			}
		}
	}
}
