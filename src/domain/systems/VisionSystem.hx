package domain.systems;

import common.struct.IntPoint;
import core.Frame;
import core.Game;
import domain.components.IsDestroyed;
import domain.components.IsDetached;
import domain.components.Moved;
import domain.components.Vision;
import domain.map.VisionLayer;
import ecs.Entity;
import ecs.Query;
import ecs.System;
import h2d.Graphics;

class VisionSystem extends System
{
	public var debug(default, set):Bool;
	public var layer(get, never):VisionLayer;

	var debugGraphics:Graphics;
	var redrawDebug:Bool = false;

	public function new()
	{
		debugGraphics = new Graphics();
		game.render(OVERLAY, debugGraphics);

		var moved = new Query({
			all: [Vision, Moved],
			none: [IsDestroyed, IsDetached],
		});

		var destroyed = new Query({
			all: [Vision],
			any: [IsDestroyed, IsDetached],
		});

		moved.onEntityAdded(onEntityMoved);
		destroyed.onEntityAdded(onEntityDestroyed);
	}

	override function update(frame:Frame)
	{
		layer.update();
		if (redrawDebug && frame.tick % 32 == 0)
		{
			updateDebug(debug);
		}
	}

	private function onEntityMoved(e:Entity)
	{
		var moved = e.get(Moved);
		var vision = e.get(Vision);

		for (pos in vision.current)
		{
			layer.removeEntity(pos.x, pos.y, e.id);
		}

		vision.current = vision.getFootprint(moved.current.toIntPoint());

		for (pos in vision.current)
		{
			layer.addEntity(pos.x, pos.y, e.id);
		}

		redrawDebug = true;
	}

	private function onEntityDestroyed(e:Entity)
	{
		var collider = e.get(Vision);

		for (pos in collider.current)
		{
			layer.removeEntity(pos.x, pos.y, e.id);
		}

		collider.current = [];
	}

	private function updateDebug(value:Bool)
	{
		if (value)
		{
			debugGraphics.clear();
			debugGraphics.beginFill(0xd9ff00, .5);

			for (cell in layer.visible)
			{
				var count = cell.value.count();
				if (count > 0)
				{
					debugGraphics.beginFill(0xd9ff00, .2 * count);
					debugGraphics.drawRect(cell.x * Game.TILE_SIZE, cell.y * Game.TILE_SIZE, Game.TILE_SIZE, Game.TILE_SIZE);
				}
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

	function get_layer():VisionLayer
	{
		return world.map.vision;
	}
}
