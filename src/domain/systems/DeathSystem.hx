package domain.systems;

import common.struct.Coordinate;
import core.Frame;
import domain.components.IsDead;
import domain.components.IsDestroyed;
import ecs.Query;
import ecs.System;

class DeathSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [IsDead],
			none: [IsDestroyed],
		});
	}

	override function update(frame:Frame)
	{
		for (e in query)
		{
			e.add(new IsDestroyed());
			Spawner.Spawn(WEED, new Coordinate(e.x.floor() + .5, e.y.floor() + .5));
		}
	}
}
