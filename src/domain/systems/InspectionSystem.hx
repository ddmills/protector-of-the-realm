package domain.systems;

import domain.components.Inspectable;
import ecs.Query;
import ecs.System;
import h2d.col.Circle;

class InspectionSystem extends System
{
	private var interactives:Map<String, h2d.Interactive>;

	public function new()
	{
		interactives = new Map();

		var q = new Query({
			all: [Inspectable],
		});

		q.onEntityAdded((e) ->
		{
			var i = e.get(Inspectable);
			var draw = e.drawable;
			var inter = new h2d.Interactive(draw.width, draw.height, draw.ob);
			interactives.set(e.id, inter);
			inter.shape = new Circle(0, 0, i.radius);
			inter.onClick = ((evt) ->
			{
				world.inspection.select(e);
			});
		});

		q.onEntityRemoved((e) ->
		{
			var inter = interactives.get(e.id);
			inter?.remove();
		});
	}
}
