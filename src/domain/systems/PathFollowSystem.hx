package domain.systems;

import common.struct.Coordinate;
import common.struct.IntPoint;
import core.Frame;
import domain.components.Move;
import domain.components.Path;
import ecs.Query;
import ecs.System;
import h2d.Graphics;

class PathFollowSystem extends System
{
	var query:Query;
	var pathers:Query;

	public var debug(default, set):Bool;

	var debugGraphics:Graphics;
	var redrawDebug:Bool = false;

	public function new()
	{
		debugGraphics = new Graphics();
		game.render(OVERLAY, debugGraphics);

		query = new Query({
			all: [Path],
			none: [Move]
		});
		pathers = new Query({
			all: [Path],
		});
	}

	override function update(frame:Frame)
	{
		if (redrawDebug && frame.tick % 16 == 0)
		{
			updateDebug(debug);
		}

		for (e in query)
		{
			var path = e.get(Path);

			if (path.hasNext())
			{
				var next = path.next();

				var collisions = world.systems.colliders.getCollisionsAt(next, path.collider_flags);

				if (collisions.exists(v -> v != e.id))
				{
					e.remove(path);
					continue;
				}

				var target = new Coordinate(next.x + .5, next.y + .5, WORLD);
				var speed = .03;

				e.add(new Move(target, speed));
				redrawDebug = true;
			}
			else
			{
				e.remove(path);
			}
		}
	}

	private function updateDebug(value:Bool)
	{
		if (value)
		{
			debugGraphics.clear();
			var offset = new Coordinate(.5, .5);

			for (e in pathers)
			{
				var p = e.get(Path);
				var prev = e.pos.toPx();

				for (i in p.curIdx...(p.length))
				{
					var next = p.instructions[i].asWorld().add(offset).toPx();

					if (i > p.curIdx)
					{
						debugGraphics.lineStyle(2, 0xF08C49, .75);
					}
					else
					{
						debugGraphics.lineStyle(2, 0xF08C49, .75);
					}

					debugGraphics.moveTo(prev.x, prev.y);
					debugGraphics.lineTo(next.x, next.y);
					prev = next;
				}

				debugGraphics.beginFill(0x00AEFF);
				debugGraphics.drawCircle(prev.x, prev.y, 3);
				debugGraphics.endFill();
			}
		}
		else
		{
			debugGraphics.clear();
		}
		redrawDebug = false;
	}

	function set_debug(value:Bool):Bool
	{
		return debug = value;
	}
}
