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

			for (s in evt.scores)
			{
				trace('${s.scorer.type} - ${s.score}');
			}

			if (evt.best != null)
			{
				trace('best ${evt.best.scorer.type} - ${evt.best.score}');

				var scorer = evt.best.scorer;
				var bhv = new Behavior(scorer.build());

				entity.add(bhv);
			}
			else
			{
				trace('NO SCORERS FOUND!!');
			}
		}
	}
}
