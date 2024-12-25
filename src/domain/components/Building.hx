package domain.components;

import core.Data;
import data.domain.BuildingType;
import domain.events.HireActorEvent;
import domain.events.QueryActionsEvent;
import ecs.Component;

class Building extends Component
{
	@save public var buildingType:BuildingType;

	public var building(get, never):domain.buildings.Building;

	public function new(buildingType:BuildingType)
	{
		this.buildingType = buildingType;

		addHandler(QueryActionsEvent, onQueryActions);
		addHandler(HireActorEvent, onHireActor);
	}

	private function onQueryActions(evt:QueryActionsEvent)
	{
		var actions = building.getActions(entity);

		evt.addAll(actions);
	}

	private function onHireActor(evt:HireActorEvent)
	{
		trace('SPAWN ACTOR', evt.actorType);
	}

	function get_building():domain.buildings.Building
	{
		return Data.Buildings.get(buildingType);
	}
}
