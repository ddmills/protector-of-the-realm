package domain.components;

import core.Game;
import domain.events.QueryActionsEvent;
import ecs.Component;
import ecs.Entity;

class Resident extends Component
{
	@save public var buildingEntityId(default, null):String;

	public function new(buildingEntityId:String)
	{
		this.buildingEntityId = buildingEntityId;

		addHandler(QueryActionsEvent, onQueryActions);
	}

	public function onQueryActions(evt:QueryActionsEvent)
	{
		evt.add(VISIT_HOME);
	}

	public function getBuilding():Null<Entity>
	{
		return Game.instance.registry.getEntity(buildingEntityId);
	}

	override function onRemove()
	{
		var e = getBuilding();

		if (e != null)
		{
			var b = e.get(Building);

			if (b != null)
			{
				b.residents.remove(entity.id);
			}
		}
	}
}
