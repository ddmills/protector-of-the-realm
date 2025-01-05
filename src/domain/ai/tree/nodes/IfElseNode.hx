package domain.ai.tree.nodes;

import ecs.Entity;

class IfElseNode extends BehaviorNode
{
	private var ifNode:BehaviorNode;
	private var elseNode:BehaviorNode;
	private var conditionNode:BehaviorNode;

	public function new(conditionNode:BehaviorNode, ifNode:BehaviorNode, elseNode:BehaviorNode)
	{
		this.ifNode = ifNode;
		this.elseNode = elseNode;
		this.conditionNode = conditionNode;
	}

	function reset(entity:Entity)
	{
		this.ifNode.reset(entity);
		this.elseNode.reset(entity);
		result = NOT_STARTED;
	}

	function run(entity:Entity):BehaviorNodeResultType
	{
		return switch conditionNode.result
		{
			case SUCCESS: {
					return ifNode.execute(entity);
				};
			case FAILED: {
					return elseNode.execute(entity);
				};
			case EXECUTING, NOT_STARTED: {
					if (conditionNode.execute(entity) != EXECUTING)
					{
						return run(entity);
					}

					return EXECUTING;
				}
		}
	}
}
