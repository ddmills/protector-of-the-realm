package domain.systems;

import common.algorithm.AStar;
import common.algorithm.Distance;
import common.struct.IntPoint;
import domain.components.Collider;
import domain.components.IsDestroyed;
import domain.components.Monster;
import domain.components.Path;
import ecs.Query;
import ecs.System;

class MonsterSystem extends System
{
	var query:Query;

	public function new()
	{
		query = new Query({
			all: [Monster, Collider],
			none: [IsDestroyed, Path],
		});

		query.onEntityAdded(e ->
		{
			var collider = e.get(Collider);
			var p = AStar.GetPath({
				start: e.pos.toIntPoint(),
				goal: getRandGoal(e.pos.toIntPoint()),
				allowDiagonals: true,
				cost: (a, b) ->
				{
					if (world.isOutOfBounds(b))
					{
						return Math.POSITIVE_INFINITY;
					}

					var hasCollisions = world.systems.colliders.hasCollisions(collider, [FLG_BUILDING, FLG_OBJECT], b);

					if (hasCollisions)
					{
						return Math.POSITIVE_INFINITY;
					}

					return Distance.Diagonal(a, b);
				}
			});

			if (p.success)
			{
				e.add(new Path(p.path, [FLG_UNIT, FLG_BUILDING, FLG_OBJECT]));
			}
			else
			{
				trace('no path found');
				e.remove(Path);
			}
		});
	}

	function getRandGoal(pos:IntPoint):IntPoint
	{
		for (i in 0...10)
		{
			var p = getRandPointInCircle(pos, 25);
			if (world.systems.colliders.grid.isOutOfBounds(p.x, p.y))
			{
				continue;
			}

			var entities = world.systems.colliders.getEntityIdsAt(p);

			if (entities.length <= 0)
			{
				return p;
			}
		}
		return pos;
	}

	function getRandPointInCircle(pos:IntPoint, radius:Int):IntPoint
	{
		var r = radius * Math.sqrt(world.rand.rand());
		var theta = world.rand.rand() * 2 * Math.PI;
		var x = pos.x + r * Math.cos(theta);
		var y = pos.y + r * Math.sin(theta);
		return new IntPoint(x.round(), y.round());
	}
}
