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
			removeGridId(pos, e.id);
		}

		vision.current = vision.getFootprint(moved.current.toIntPoint());

		for (pos in vision.current)
		{
			addGridId(pos, e.id);
		}

		redrawDebug = true;
	}

	private function onEntityDestroyed(e:Entity)
	{
		var collider = e.get(Vision);

		for (pos in collider.current)
		{
			removeGridId(pos, e.id);
		}

		collider.current = [];
	}

	private function addGridId(pos:IntPoint, entityId:String)
	{
		var m = layer.get(pos.x, pos.y);

		if (m == null)
		{
			return;
		}

		m.add(entityId);
	}

	private function removeGridId(pos:IntPoint, entityId:String)
	{
		var m = layer.get(pos.x, pos.y);

		if (m == null)
		{
			return;
		}

		m.remove(entityId);
	}

	private function updateDebug(value:Bool)
	{
		if (value)
		{
			debugGraphics.clear();
			debugGraphics.beginFill(0x00ff22, .5);

			for (cell in layer.grid)
			{
				var count = cell.value.count();
				if (count > 0)
				{
					debugGraphics.beginFill(0x00ff22, .2 * count);
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
