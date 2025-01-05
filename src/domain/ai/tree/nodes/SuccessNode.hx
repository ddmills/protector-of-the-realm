package domain.ai.tree.nodes;

import ecs.Entity;

class SuccessNode extends BehaviorNode
{
	public function new() {}

	function reset(entity:Entity)
	{
		result = NOT_STARTED;
	}

	function run(entity:Entity):BehaviorNodeResultType
	{
		return SUCCESS;
	}
}
