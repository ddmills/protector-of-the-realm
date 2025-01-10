package domain.systems;

import common.struct.Coordinate;
import core.Frame;
import domain.components.Guest;
import domain.components.IsDestroyed;
import domain.components.Move;
import domain.components.MoveComplete;
import domain.components.Moved;
import ecs.Query;
import ecs.System;

class MovementSystem extends System
{
	var movers:Query;
	var completed:Query;
	var moved:Query;

	public function new()
	{
		movers = new Query({
			all: [Move],
			none: [MoveComplete, IsDestroyed]
		});

		var guests = new Query({
			all: [Move, Guest],
		});

		guests.onEntityAdded((e) ->
		{
			e.remove(Guest);
		});

		completed = new Query({
			all: [MoveComplete],
			none: [IsDestroyed],
		});
		moved = new Query({
			all: [Moved],
			none: [IsDestroyed],
		});
	}

	inline function getDelta(pos:Coordinate, goal:Coordinate, speed:Float, tween:Tween, tmod:Float):Coordinate
	{
		switch tween
		{
			case LINEAR:
				var direction = pos.direction(goal);
				var dx = direction.x * tmod * speed * game.clock.speed;
				var dy = direction.y * tmod * speed * game.clock.speed;
				return new Coordinate(dx, dy, WORLD);
			case LERP:
				return pos.lerp(goal, tmod * speed * game.clock.speed).sub(pos);
			case INSTANT:
				return goal.sub(pos);
		}
	}

	public override function update(frame:Frame)
	{
		for (entity in completed)
		{
			entity.remove(MoveComplete);
		}

		for (entity in moved)
		{
			entity.remove(Moved);
		}

		for (entity in movers)
		{
			var start = entity.pos;
			var move = entity.get(Move);

			var delta = getDelta(start, move.goal, move.speed, move.tween, frame.tmod);

			var deltaSq = delta.lengthSq();
			var distanceSq = start.distance(move.goal, WORLD, EUCLIDEAN_SQ);

			start.lerp(move.goal, frame.tmod * move.speed);

			if (distanceSq < Math.max(deltaSq, move.epsilon * move.epsilon))
			{
				entity.pos = move.goal;
				entity.remove(move);
				entity.add(new MoveComplete());
			}
			else
			{
				entity.pos = start.add(delta);
			}
		}
	}
}
