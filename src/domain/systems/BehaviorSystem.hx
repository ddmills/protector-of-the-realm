package domain.systems;

import common.algorithm.AStar;
import common.algorithm.Distance;
import common.struct.IntPoint;
import core.Frame;
import domain.components.Actor;
import domain.components.Behavior;
import domain.components.Blackboard;
import domain.components.IsDestroyed;
import domain.components.Move;
import domain.components.Path;
import domain.components.tasks.TaskMoveTo;
import domain.components.tasks.TaskPickRandomSpot;
import domain.components.tasks.TaskSleep;
import ecs.Entity;
import ecs.Query;
import ecs.System;

class BehaviorSystem extends System
{
	var query:Query;
	var sleepers:Query;
	var spotters:Query;
	var movers:Query;

	public function new()
	{
		query = new Query({
			all: [Actor, Behavior],
			none: [IsDestroyed]
		});

		sleepers = new Query({
			all: [TaskSleep]
		});

		spotters = new Query({
			all: [TaskPickRandomSpot, Blackboard]
		});

		movers = new Query({
			all: [TaskMoveTo, Blackboard],
		});

		movers.onEntityAdded((e) ->
		{
			var bb = e.get(Blackboard);
			bb.goal = getRandPointInCircle(e.pos.toIntPoint(), 10);
		});
	}

	override function update(frame:Frame)
	{
		for (e in query)
		{
			var bhv = e.get(Behavior);
			var result = bhv.run();

			if (result == SUCCESS)
			{
				e.remove(bhv);
			}

			if (result == FAILED)
			{
				e.remove(bhv);
			}
		}

		for (e in sleepers)
		{
			var task = e.get(TaskSleep);
			task.progress += game.clock.deltaTick;
			if (task.progress > task.duration)
			{
				task.state = SUCCESS;
			}
		}

		// for (e in spotters)
		// {
		// 	var task = e.get(TaskPickRandomSpot);
		// 	var blackboard = e.get(Blackboard);

		// 	blackboard.goal = getRandPointInCircle(e.pos.toIntPoint(), task.radius);
		// 	task.state = SUCCESS;
		// }

		for (e in movers)
		{
			var blackboard = e.get(Blackboard);
			var cpos = e.pos.toIntPoint();
			var task = e.get(TaskMoveTo);

			if (task.state != EXECUTING || cpos.equals(blackboard.goal))
			{
				task.state = SUCCESS;
			}

			if (e.has(Move))
			{
				continue;
			}

			var path = e.get(Path);

			if (path == null)
			{
				var result = getPath(e, blackboard.goal);

				if (result.success)
				{
					trace('Found path!', result.path.length);
					e.add(new Path(result.path, [FLG_OBJECT, FLG_BUILDING]));
				}
				else
				{
					trace('FAILURE! no path found');
					task.state = FAILED;
				}
			}
		}
	}

	function getPath(e:Entity, target:IntPoint):AStarResult
	{
		return AStar.GetPath({
			start: e.pos.toIntPoint(),
			goal: target,
			maxDepth: 600,
			allowDiagonals: true,
			cost: (a, b) ->
			{
				if (world.map.isOutOfBounds(b))
				{
					return Math.POSITIVE_INFINITY;
				}

				var t = world.terrain.terrain.get(b.x, b.y);

				if (t == WATER)
				{
					return Math.POSITIVE_INFINITY;
				}

				var hasCollisions = world.systems.colliders.hasCollisionFastNav(b, e.id);

				if (hasCollisions)
				{
					return Math.POSITIVE_INFINITY;
				}

				if (a.x != b.x && a.y != b.y)
				{
					var c1 = new IntPoint(a.x, b.y);
					var c2 = new IntPoint(b.x, a.y);

					var t1 = world.terrain.terrain.get(c1.x, c1.y);
					var t2 = world.terrain.terrain.get(c2.x, c2.y);

					if (t1 == WATER || t2 == WATER)
					{
						return Math.POSITIVE_INFINITY;
					}

					var hasCollisions1 = world.systems.colliders.hasCollisionFastNav(c1, e.id);

					if (hasCollisions1)
					{
						return Math.POSITIVE_INFINITY;
					}

					var hasCollisions2 = world.systems.colliders.hasCollisionFastNav(c2, e.id);
					if (hasCollisions2)
					{
						return Math.POSITIVE_INFINITY;
					}
				}

				return Distance.Diagonal(a, b);
			}
		});
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
