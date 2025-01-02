package domain.events;

import domain.components.behaviors.BehaviorScorerComponent;
import ecs.EntityEvent;

typedef BehaviorScore =
{
	scorer:BehaviorScorerComponent,
	score:Float,
}

class ScoreBehaviorsEvent extends EntityEvent
{
	public var best(default, null):Null<BehaviorScore>;
	public var scores(default, null):Array<BehaviorScore>;

	public function new()
	{
		scores = new Array();
	}

	public function add(score:BehaviorScore)
	{
		if (best.isNull())
		{
			best = score;
		}
		else
		{
			if (score.score > best.score)
			{
				best = score;
			}
		}

		scores.push(score);
	}
}
