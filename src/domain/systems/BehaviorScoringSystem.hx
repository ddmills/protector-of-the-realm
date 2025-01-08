package domain.systems;

import core.Frame;
import domain.components.Actor;
import domain.components.Behavior;
import domain.components.IsDestroyed;
import domain.components.IsDetached;
import domain.events.ScoreBehaviorsEvent;
import ecs.Query;
import ecs.System;

class BehaviorScoringSystem extends System
{
	public var query:Query;

	public function new()
	{
		query = new Query({
			all: [Actor, Behavior],
			none: [IsDestroyed, IsDetached],
		});
	}

	override function update(frame:Frame)
	{
		var tick = game.clock.tick;

		for (entity in query)
		{
			var bhv = entity.get(Behavior);

			if ((tick - bhv.lastCheckTick) < bhv.updateRate)
			{
				continue;
			}

			bhv.lastCheckTick = tick;

			var evt = entity.fireEvent(new ScoreBehaviorsEvent());

			if (evt.best != null)
			{
				if (evt.best.scorer.behaviorId() != bhv.currentId)
				{
					var diff = evt.best.score - bhv.score;

					if (diff > 10)
					{
						// trace('Change what ur doin! $diff', bhv.currentId, '->', evt.best.scorer.behaviorId());

						bhv.assign(evt.best.scorer, evt.best.score);
					}
				}
			}
			else
			{
				trace('NO SCORERS FOUND!!');
			}
		}
	}
}
