package domain.ai.tree.nodes;

import ecs.Entity;

class SequenceNode extends BehaviorNode
{
	private var children:Array<BehaviorNode>;
	private var idx:Int;

	public function new(children:Array<BehaviorNode>)
	{
		this.children = children;
		this.idx = 0;
	}

	function reset(entity:Entity)
	{
		idx = 0;

		for (child in children)
		{
			child.reset(entity);
		}

		result = NOT_STARTED;
	}

	function run(entity:Entity):BehaviorNodeResultType
	{
		return switch result
		{
			case NOT_STARTED: {
					idx = 0;

					if (this.children.length == 0)
					{
						return SUCCESS;
					}

					result = EXECUTING;
					return run(entity);
				}
			case EXECUTING:
				{
					var child = children[idx];

					return switch child.execute(entity)
					{
						case NOT_STARTED: {
								trace('Child node of sequence did not start!');
								FAILED;
							}
						case EXECUTING: EXECUTING;
						case FAILED: FAILED;
						case SUCCESS: {
								idx++;

								if (idx >= children.length)
								{
									return SUCCESS;
								}

								return execute(entity);
							}
					};
				}
			case SUCCESS: SUCCESS;
			case FAILED: FAILED;
		}
	}
}
