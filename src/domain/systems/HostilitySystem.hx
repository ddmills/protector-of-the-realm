package domain.systems;

import core.Frame;
import domain.components.Moved;
import domain.components.Team;
import ecs.Query;
import ecs.System;

class HostilitySystem extends System
{
	var query:Query;

	public function new()
	{
		var teams = new Query({
			all: [Team],
		});

		teams.onEntityAdded((e) ->
		{
			var t = e.get(Team);
			world.map.hostility.updateEntityPosition(e.id, t.teamType, e.x.floor(), e.y.floor());
		});

		teams.onEntityRemoved((e) ->
		{
			world.map.hostility.removeEntity(e.id);
		});

		query = new Query({
			all: [Team, Moved],
		});
	}

	override function update(frame:Frame)
	{
		for (e in query)
		{
			var t = e.get(Team);
			var m = e.get(Moved);

			var previous = world.map.hostility.getPartitionIdx(m.previous.x.floor(), m.previous.y.floor());
			var current = world.map.hostility.getPartitionIdx(m.current.x.floor(), m.current.y.floor());

			if (previous != current)
			{
				world.map.hostility.updateEntityPosition(e.id, t.teamType, e.x.floor(), e.y.floor());
			}
		}
	}
}
