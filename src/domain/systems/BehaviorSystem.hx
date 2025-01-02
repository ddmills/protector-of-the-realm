package domain.systems;

import core.Frame;
import domain.components.Actor;
import domain.components.Behavior;
import domain.components.IsDestroyed;
import domain.components.tasks.SleepTask;
import ecs.Query;
import ecs.System;

class BehaviorSystem extends System
{
	var query:Query;
	var sleepers:Query;

	public function new()
	{
		query = new Query({
			all: [Actor, Behavior],
			none: [IsDestroyed]
		});

		sleepers = new Query({
			all: [SleepTask]
		});
	}

	override function update(frame:Frame)
	{
		for (e in query)
		{
			var bhv = e.get(Behavior);
			var result = bhv.run();

			if (result == SUCCESS)
			{
				trace('SUCCESS');
				e.remove(bhv);
			}

			if (result == FAILED)
			{
				trace('FAILED');
				e.remove(bhv);
			}
		}

		for (e in sleepers)
		{
			var task = e.get(SleepTask);
			task.progress += game.clock.deltaTick;
			if (task.progress > task.duration)
			{
				task.state = SUCCESS;
			}
		}
	}
}
