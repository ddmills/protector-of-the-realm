package domain.components;

import domain.ai.tree.BehaviorNodeResultType;
import domain.ai.tree.nodes.BehaviorNode;
import domain.ai.tree.nodes.TaskNode;
import domain.components.behaviors.BehaviorScorerComponent;
import domain.events.QueryTaskLabelEvent;
import ecs.Component;

typedef BehaviorLabels =
{
	behavior:String,
	task:String,
}

class Behavior extends Component
{
	@save public var tree:BehaviorNode;
	@save public var label:String;
	@save public var lastCheckTick:Float;
	@save public var updateRate:Float;
	@save public var currentId:String;
	@save public var score:Float;

	public var result(get, never):BehaviorNodeResultType;

	public function new()
	{
		this.updateRate = 2; // check every other second for update
		completed();
	}

	public inline function run():BehaviorNodeResultType
	{
		tree.execute(entity);

		return result;
	}

	public function assign(scorer:BehaviorScorerComponent, score:Float)
	{
		tree.reset(entity);
		tree = scorer.build();
		label = scorer.label();
		currentId = scorer.behaviorId();
		this.score = score;
	}

	public function completed()
	{
		tree = defaultBehavior();
		label = 'Nothing';
		currentId = 'Nothing';
		lastCheckTick = 0;
		score = -100;
	}

	private function defaultBehavior()
	{
		return new TaskNode(TASK_WAIT(10));
	}

	public function getLabels():BehaviorLabels
	{
		var evt = entity.fireEvent(new QueryTaskLabelEvent());

		return {
			behavior: label,
			task: evt.label,
		};
	}

	public inline function get_result():BehaviorNodeResultType
	{
		return tree.result;
	}
}
