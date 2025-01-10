package domain.systems;

import core.Frame;
import domain.components.Guest;
import domain.components.Health;
import ecs.Query;
import ecs.System;

class GuestSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [Guest]
		});

		query.onEntityAdded((e) ->
		{
			e.drawable.isVisible = false;
		});

		query.onEntityRemoved((e) ->
		{
			e.drawable.isVisible = true;
		});
	}

	override function update(frame:Frame)
	{
		var healRatePerS = 8;

		for (e in query)
		{
			var health = e.get(Health);

			if (health != null)
			{
				health.value += game.clock.deltaTick * healRatePerS;
			}
		}
	}
}
