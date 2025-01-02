package domain.ai.tree;

import domain.ai.tree.BehaviorNode.BehaviorNodeState;

class BehaviorStateBuilder
{
	public static function build(node:BehaviorNode):BehaviorNodeState
	{
		return switch node
		{
			case TASK(task): BehaviorNodeState.TASK(NOT_STARTED, task);
			case NOT(node): BehaviorNodeState.NOT(NOT_STARTED, build(node));
		}
	}
}
