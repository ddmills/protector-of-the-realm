package domain.systems;

import core.Frame;
import domain.components.ActionQueue;
import ecs.Query;
import ecs.System;

class ActionQueueSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [ActionQueue],
		});
	}

	override function update(frame:Frame)
	{
		for (e in query)
		{
			var queue = e.get(ActionQueue);
			queue.updateActions(frame.dt);
		}
	}
}
