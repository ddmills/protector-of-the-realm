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
				e.get(Blackboard).reset();
			}

			if (result == FAILED)
			{
				e.remove(bhv);
				e.get(Blackboard).reset();
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

		for (e in spotters)
		{
			var task = e.get(TaskPickRandomSpot);
			var blackboard = e.get(Blackboard);

			var p = tryGetRandPoint(e.pos.toIntPoint(), task.radius);

			if (p != null)
			{
				blackboard.goals = [p];
				task.state = SUCCESS;
			}
			else
			{
				task.state = FAILED;
			}
		}

		for (e in movers)
		{
			var blackboard = e.get(Blackboard);
			var cpos = e.pos.toIntPoint();
			var task = e.get(TaskMoveTo);

			if (blackboard.targetId != null)
			{
				var tpos = world.map.position.getPosition(blackboard.targetId);
				if (tpos == null)
				{
					task.state = FAILED;
					continue;
				}

				blackboard.goals = [
					new IntPoint(tpos.x, tpos.y - 1),
					new IntPoint(tpos.x - 1, tpos.y),
					new IntPoint(tpos.x + 1, tpos.y),
					new IntPoint(tpos.x, tpos.y + 1)
				];
			}

			if (blackboard.goals == null || blackboard.goals.isEmpty())
			{
				task.state = FAILED;
				continue;
			}

			if (task.state != EXECUTING || blackboard.goals.exists(g -> cpos.equals(g)))
			{
				task.state = SUCCESS;
				continue;
			}

			if (e.has(Move))
			{
				continue;
			}

			var path = e.get(Path);

			if (path != null && !blackboard.goals.exists(g -> path.goal.equals(g)))
			{
				task.retryAttempts = 0;
				e.remove(Path);
			}

			if (path == null)
			{
				task.retryAttempts++;
				if (task.retryAttempts >= task.maxRetryAttempts)
				{
					task.state = FAILED;
					continue;
				}

				var result = getPath(e, blackboard.goals);
				if (result.success)
				{
					e.add(new Path(result.path, [FLG_OBJECT, FLG_BUILDING, FLG_UNIT]));
					task.retryAttempts = 0;
				}
				else
				{
					trace('FAILURE! no path found from ${e.pos.toIntPoint().toString()} to ${blackboard.goals.toString()}');
					task.state = FAILED;
				}
			}
		}
	}

	function getPath(e:Entity, goals:Array<IntPoint>):AStarResult
	{
		var start = e.pos.toIntPoint();
		return AStar.GetPath({
			start: start,
			goals: goals,
			maxDepth: 20000,
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

				var dist = Distance.Chebyshev(start, b);

				if (dist == 1)
				{
					var hasCollisionSlow = world.systems.colliders.hasCollisionsAt(b, e.id);

					if (hasCollisionSlow)
					{
						return Math.POSITIVE_INFINITY;
					}
				}
				else
				{
					var hasCollisions = world.systems.colliders.hasCollisionFastNav(b, e.id);

					if (hasCollisions)
					{
						return Math.POSITIVE_INFINITY;
					}
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

	function tryGetRandPoint(pos:IntPoint, radius:Int):IntPoint
	{
		for (attempt in 0...10)
		{
			var point = getRandPointInCircle(pos, radius);

			if (world.map.isOutOfBounds(point))
			{
				continue;
			}

			var terrain = world.terrain.terrain.get(point.x, point.y);

			if (terrain != WATER)
			{
				var nav = world.map.collision.getFastNavValue(point.x, point.y);
				if (nav.length == 0)
				{
					return point;
				}
			}
		}

		return null;
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
