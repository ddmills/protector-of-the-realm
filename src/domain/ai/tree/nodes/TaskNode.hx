package domain.ai.tree.nodes;

import core.Data;
import domain.ai.tasks.TaskType;
import ecs.Entity;

class TaskNode extends BehaviorNode
{
	var task:TaskType;

	public function new(task:TaskType)
	{
		this.task = task;
	}

	public function reset(entity:Entity)
	{
		var t = Data.Tasks.get(task);
		var c = entity.get(t);

		if (c != null)
		{
			c.reset();
			entity.remove(c);
		}

		result = NOT_STARTED;
	}

	public function run(entity:Entity):BehaviorNodeResultType
	{
		return switch result
		{
			case NOT_STARTED:
				{
					var t = Data.Tasks.build(task);
					entity.add(t);
					return EXECUTING;
				}
			case EXECUTING: {
					var t = Data.Tasks.get(task);
					var c = entity.get(t);

					return switch c.state
					{
						case SUCCESS: {
								entity.remove(t);
								return SUCCESS;
							}
						case FAILED: {
								entity.remove(t);
								return FAILED;
							}
						case EXECUTING: EXECUTING;
					}
				};
			case SUCCESS: SUCCESS;
			case FAILED: FAILED;
		}
	}
}
