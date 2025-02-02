package domain.ai.tree.nodes;

import domain.ai.tree.BehaviorNodeResultType;
import ecs.Entity;

abstract class BehaviorNode
{
	public var result:BehaviorNodeResultType = NOT_STARTED;

	abstract private function run(entity:Entity):BehaviorNodeResultType;

	abstract public function reset(entity:Entity):Void;

	public function execute(entity:Entity):BehaviorNodeResultType
	{
		result = run(entity);
		return result;
	}
}
