package domain.ai.tree.nodes;

import ecs.Entity;
import haxe.EnumTools.EnumValueTools;

class RetryNode extends BehaviorNode
{
	private var child:BehaviorNode;
	private var maxAttempts:Int;
	private var attempts:Int = 0;

	public function new(child:BehaviorNode, maxAttempts:Int)
	{
		this.child = child;
		this.maxAttempts = maxAttempts;
	}

	function reset(entity:Entity)
	{
		this.child.reset(entity);
		result = NOT_STARTED;
	}

	function run(entity:Entity):BehaviorNodeResultType
	{
		if (attempts >= maxAttempts)
		{
			return FAILED;
		}

		return switch result
		{
			case SUCCESS: SUCCESS;
			case FAILED: FAILED;
			case NOT_STARTED, EXECUTING: {
					return switch child.execute(entity)
					{
						case SUCCESS: SUCCESS;
						case FAILED: {
								attempts++;
								child.reset(entity);
								return EXECUTING;
							};
						case EXECUTING: EXECUTING;
						case NOT_STARTED: {
								trace('child tryNode did not start!');
								return FAILED;
							};
					}
				};
		}
	}
}
