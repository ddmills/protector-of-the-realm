package domain.components.behaviors;

import domain.ai.tree.nodes.BehaviorNode;
import domain.events.ScoreBehaviorsEvent;
import ecs.Component;

abstract class BehaviorScorerComponent extends Component
{
	public function new()
	{
		addHandler(ScoreBehaviorsEvent, onScoreBehaviors);
	}

	function onScoreBehaviors(evt:ScoreBehaviorsEvent)
	{
		evt.add({
			scorer: this,
			score: this.score(),
		});
	}

	public abstract function score():Float;

	public abstract function build():BehaviorNode;
}
