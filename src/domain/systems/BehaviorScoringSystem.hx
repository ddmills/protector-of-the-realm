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
			all: [Actor],
			none: [Behavior, IsDestroyed, IsDetached],
		});
	}

	override function update(frame:Frame)
	{
		for (entity in query)
		{
			var evt = entity.fireEvent(new ScoreBehaviorsEvent());

			if (evt.best != null)
			{
				var scorer = evt.best.scorer;
				var label = scorer.label();
				var bhv = new Behavior(scorer.build(), label);

				entity.add(bhv);
			}
			else
			{
				trace('NO SCORERS FOUND!!');
			}
		}
	}
}
