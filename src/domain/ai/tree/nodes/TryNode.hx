package domain.ai.tree.nodes;

import ecs.Entity;

class TryNode extends BehaviorNode
{
	private var tryNode:BehaviorNode;
	private var catchNode:BehaviorNode;

	public function new(tryNode:BehaviorNode, catchNode:BehaviorNode)
	{
		this.tryNode = tryNode;
		this.catchNode = catchNode;
	}

	public function reset(entity:Entity)
	{
		tryNode.reset(entity);
		catchNode.reset(entity);
		result = NOT_STARTED;
	}

	function run(entity:Entity):BehaviorNodeResultType
	{
		return switch tryNode.execute(entity)
		{
			case SUCCESS: SUCCESS;
			case FAILED: {
					return switch catchNode.execute(entity)
					{
						case SUCCESS: SUCCESS;
						case FAILED: FAILED;
						case EXECUTING: EXECUTING;
						case NOT_STARTED: {
								trace('child catchNode did not start!');
								return FAILED;
							}
					}
				};
			case EXECUTING: EXECUTING;
			case NOT_STARTED: {
					trace('child tryNode did not start!');
					return FAILED;
				};
		}
	}
}
