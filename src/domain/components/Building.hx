package domain.components;

import common.struct.Coordinate;
import common.struct.IntPoint;
import common.struct.Set;
import core.Data;
import core.Game;
import data.domain.BuildingType;
import domain.events.HireActorEvent;
import domain.events.QueryActionsEvent;
import ecs.Component;
import ecs.Entity;

class Building extends Component
{
	@save public var buildingType:BuildingType;
	@save public var residents:Set<String>;
	@save public var guests:Set<String>;

	public var building(get, never):domain.buildings.Building;

	public function new(buildingType:BuildingType)
	{
		this.buildingType = buildingType;
		this.residents = new Set();
		this.guests = new Set();

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
		var w = building.width;
		var h = building.height;

		var squares = [];

		for (x in 0...w)
		{
			squares.push(new IntPoint(x, -1));
			squares.push(new IntPoint(x, h));
		}

		for (y in 0...h)
		{
			squares.push(new IntPoint(-1, y));
			squares.push(new IntPoint(w, y));
		}

		var sq = Game.instance.world.rand.pick(squares);

		var middleX = (w / 2).floor();
		var middleY = (h / 2).floor();
		var pos = entity.pos
			.sub(new Coordinate(middleX, middleY))
			.add(sq.asWorld()).floor()
			.add(new Coordinate(.5, .5));

		var actor = Data.Actors.get(evt.actorType);
		var e = Spawner.Spawn(actor.spawnableType, pos);
		addResident(e);
	}

	public function addResident(e:Entity)
	{
		residents.add(e.id);
		e.add(new Resident(entity.id));
	}

	override function onRemove()
	{
		for (residentId in residents)
		{
			var e = Game.instance.registry.getEntity(residentId);

			e.remove(Resident);
		}
	}

	function get_building():domain.buildings.Building
	{
		return Data.Buildings.get(buildingType);
	}
}
