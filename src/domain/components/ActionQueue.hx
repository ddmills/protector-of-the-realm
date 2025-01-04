package domain.components;

import core.Game;
import domain.events.HireActorEvent;
import domain.events.QueryActionsEvent;
import ecs.Component;

class ActionQueue extends Component
{
	@save public var actions:Array<EntityAction>;

	public function new()
	{
		this.actions = [];
		addHandler(QueryActionsEvent, onQueryActions);
	}

	function onQueryActions(evt:QueryActionsEvent)
	{
		evt.actions.push(SELF_DESTRUCT);
		evt.actions.push(FOLLOW);
	}

	public function updateActions(delta:Float)
	{
		var completed = [];

		for (action in actions)
		{
			action.current += delta;

			if (action.current > action.duration)
			{
				completed.push(action);
			}
		}

		for (action in completed)
		{
			actions.remove(action);

			switch action.actionType
			{
				case VISIT_HOME:
					{
						var building = entity.get(Resident)?.getBuilding();

						if (building != null)
						{
							Game.instance.world.input.camera.followEntity(building);
						}
					}
				case FOLLOW:
					{
						Game.instance.world.input.camera.followEntity(entity);
					}
				case SELF_DESTRUCT:
					{
						entity.add(new IsDestroyed());
					}
				case HIRE_ACTOR(actorType):
					{
						entity.fireEvent(new HireActorEvent(actorType));
					};
			}
		}
	}
}
