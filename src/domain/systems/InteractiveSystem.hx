package domain.systems;

import domain.components.Interactive;
import ecs.Query;
import ecs.System;
import h2d.col.Circle;

class InteractiveSystem extends System
{
	public function new()
	{
		var q = new Query({
			all: [Interactive],
		});

		q.onEntityAdded((e) ->
		{
			var i = e.get(Interactive);
			var draw = e.drawable;
			var inter = new h2d.Interactive(draw.width, draw.height, draw.ob);
			inter.shape = new Circle(0, 0, i.radius);
			inter.onClick = ((evt) ->
			{
				trace('CLICK', e.id);
			});
		});
	}
}
