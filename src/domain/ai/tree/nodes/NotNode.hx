package domain.ai.tree.nodes;

import ecs.Entity;
import haxe.EnumTools.EnumValueTools;

class NotNode extends BehaviorNode
{
	private var child:BehaviorNode;

	public function new(child:BehaviorNode)
	{
		this.child = child;
	}

	function reset(entity:Entity)
	{
		this.child.reset(entity);
		result = NOT_STARTED;
	}

	function run(entity:Entity):BehaviorNodeResultType
	{
		return switch child.result
		{
			case SUCCESS: FAILED;
			case FAILED: SUCCESS;
			case EXECUTING, NOT_STARTED: {
					if (child.execute(entity) != EXECUTING)
					{
						trace('child state changed... ${EnumValueTools.getName(child.result)}');
						return run(entity);
					}

					return EXECUTING;
				}
		}
	}
}
