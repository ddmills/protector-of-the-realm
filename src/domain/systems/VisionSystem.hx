package domain.systems;

import common.util.Projection;
import core.Frame;
import core.Game;
import domain.components.IsDestroyed;
import domain.components.IsDetached;
import domain.components.IsExplorable;
import domain.components.IsExplored;
import domain.components.IsObservable;
import domain.components.IsPlayer;
import domain.components.IsVisible;
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

		var hidden = new Query({
			all: [IsObservable, Moved],
		});

		hidden.onEntityAdded(e ->
		{
			if (world.map.vision.isVisible(e.x.floor(), e.y.floor()))
			{
				e.add(new IsVisible());
				e.drawable.isVisible = true;
			}
			else
			{
				e.remove(IsVisible);
				e.drawable.isVisible = false;
			}
		});

		var shrouded = new Query({
			all: [IsExplored],
			none: [IsVisible],
		});

		shrouded.onEntityAdded(e ->
		{
			e.drawable.isVisible = true;
			e.drawable.shader.setShrouded(true);
		});

		var visible = new Query({
			all: [IsVisible],
		});

		visible.onEntityAdded(e ->
		{
			e.drawable.isVisible = true;
			e.drawable.shader.setShrouded(false);
		});

		visible.onEntityRemoved(e ->
		{
			if (!e.has(IsExplorable))
			{
				if (e.drawable != null)
				{
					e.drawable.isVisible = false;
				}
			}
			else
			{
				e.drawable.shader.setShrouded(true);
			}
		});

		// mark any unexplored tiles as invisible to start
		var unexplored = new Query({
			all: [IsExplorable],
			none: [IsExplored],
		});

		unexplored.onEntityAdded(e ->
		{
			if (e.drawable != null)
			{
				e.drawable.isVisible = false;
			}
		});

		var moved = new Query({
			all: [Vision, IsPlayer, Moved],
			none: [IsDestroyed, IsDetached],
		});

		var destroyed = new Query({
			all: [Vision, IsPlayer],
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

		var newFp = vision.getFootprint(moved.current.toIntPoint());
		var copyFp = newFp.copy();

		for (pos in vision.current)
		{
			var removed = newFp.findRemove(v -> v.equals(pos));

			if (!removed)
			{
				layer.removeVisibleForEntity(pos.x, pos.y, e.id);
			}
		}

		vision.current = copyFp;

		for (pos in newFp)
		{
			layer.markVisibleForEntity(pos.x, pos.y, e.id);
		}

		redrawDebug = true;
	}

	private function onEntityDestroyed(e:Entity)
	{
		var collider = e.get(Vision);

		for (pos in collider.current)
		{
			layer.removeVisibleForEntity(pos.x, pos.y, e.id);
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
					var pos = Projection.worldToPx(cell.x, cell.y);
					debugGraphics.beginFill(0xd9ff00, .2 * count);
					debugGraphics.drawRect(pos.x, pos.y, Game.TILE_WIDTH, Game.TILE_HEIGHT);
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
