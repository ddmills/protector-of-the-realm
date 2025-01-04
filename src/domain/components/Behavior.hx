package domain.components;

import domain.ai.tree.BehaviorNodeResultType;
import domain.ai.tree.nodes.BehaviorNode;
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

	public var result(get, never):BehaviorNodeResultType;

	public function new(tree:BehaviorNode, label:String)
	{
		this.tree = tree;
		this.label = label;
	}

	public inline function run():BehaviorNodeResultType
	{
		tree.execute(entity);

		return result;
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
