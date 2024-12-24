package domain.systems;

import domain.components.Inspectable;
import ecs.Query;
import ecs.System;
import h2d.col.Circle;

class InspectionSystem extends System
{
	public function new()
	{
		var q = new Query({
			all: [Inspectable],
		});

		q.onEntityAdded((e) ->
		{
			var i = e.get(Inspectable);
			var draw = e.drawable;
			var inter = new h2d.Interactive(draw.width, draw.height, draw.ob);
			inter.shape = new Circle(0, 0, i.radius);
			inter.onClick = ((evt) ->
			{
				world.inspection.select(e);
			});
		});
	}
}
