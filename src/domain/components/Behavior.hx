package domain.components;

import domain.ai.tree.BehaviorNodeResultType;
import domain.ai.tree.nodes.BehaviorNode;
import ecs.Component;

class Behavior extends Component
{
	@save public var tree:BehaviorNode;
	public var result(get, never):BehaviorNodeResultType;

	public function new(tree:BehaviorNode)
	{
		this.tree = tree;
	}

	public inline function run():BehaviorNodeResultType
	{
		tree.execute(entity);

		return result;
	}

	public inline function get_result():BehaviorNodeResultType
	{
		return tree.result;
	}
}
