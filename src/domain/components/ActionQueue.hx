package domain.components;

import domain.events.QueryActionsEvent.EntityAction;
import domain.events.QueueActionEvent;
import ecs.Component;

class ActionQueue extends Component
{
	@save public var actions:Array<EntityAction>;

	public function new()
	{
		this.actions = [];
		addHandler(QueueActionEvent, onQueueAction);
	}

	function onQueueAction(evt:QueueActionEvent)
	{
		trace('queue action');
		actions.push(evt.action);
	}

	public function updateActions(delta:Float)
	{
		var completed = [];

		for (action in actions)
		{
			action.current += delta;

			if (action.current > action.duration)
			{
				trace('ACTION COMPLETED', action.name);
				entity.fireEvent(action.evt);
				completed.push(action);
			}
		}

		for (action in completed)
		{
			actions.remove(action);
		}
	}
}
