package domain.systems;

import common.struct.Grid;
import common.struct.IntPoint;
import common.struct.Set;
import core.Frame;
import core.Game;
import domain.components.Collider;
import domain.components.IsDetached;
import domain.components.Moved;
import ecs.Entity;
import ecs.Query;
import ecs.System;
import h2d.Graphics;

enum abstract ColliderFlag(Int) to Int from Int
{
	var FLG_UNIT = 1;
	var FLG_OBJECT = 2;
	var FLG_BUILDING = 3;
}

class ColliderSystem extends System
{
	var resolution:Int = 1;

	public var grid:Grid<Set<String>>;
	public var debug(default, set):Bool;

	var debugGraphics:Graphics;
	var redrawDebug:Bool = false;

	public function new()
	{
		debugGraphics = new Graphics();
		game.render(OVERLAY, debugGraphics);

		grid = new Grid(world.mapWidth, world.mapHeight);
		grid.fillFn((i) -> new Set());

		var moved = new Query({
			all: [Collider, Moved],
			none: [IsDetached],
		});

		moved.onEntityAdded(onEntityMoved);
	}

	override function update(frame:Frame)
	{
		if (redrawDebug && frame.tick % 32 == 0)
		{
			updateDebug(debug);
		}
	}

	public function getEntityIdsAt(pos:IntPoint):Array<String>
	{
		var ids = grid.get(pos.x, pos.y);

		if (ids == null)
		{
			return [];
		}

		return ids.toArray();
	}

	public function getCollisionsAt(pos:IntPoint, flags:Array<ColliderFlag>):Array<String>
	{
		var collisions = new Set<String>();

		for (id in getEntityIdsAt(pos))
		{
			if (collisions.has(id))
			{
				continue;
			}

			var targetEntity = game.registry.getEntity(id);
			var targetCollider = targetEntity.get(Collider);
			if (targetCollider.hasAnyFlags(flags))
			{
				collisions.add(id);
			}
		}

		return collisions.toArray();
	}

	public function footprintHasCollisions(footprint:Array<IntPoint>, flags:Array<ColliderFlag>):Bool
	{
		for (pos in footprint)
		{
			var colliders = getCollidersAt(pos);

			if (colliders.length > 0)
			{
				if (colliders.exists((c) -> c.hasAnyFlags(flags)))
				{
					return true;
				}
			}
		}

		return false;
	}

	public function hasCollisions(collider:Collider, flags:Array<ColliderFlag>):Bool
	{
		var footprint = collider.getFootprint();

		for (pos in footprint)
		{
			var colliders = getCollidersAt(pos);

			if (colliders.exists(c -> c != collider && c.hasAnyFlags(flags)))
			{
				return true;
			}
		}

		return false;
	}

	private function getCollidersAt(pos:IntPoint):Array<Collider>
	{
		var m = grid.get(pos.x, pos.y);
		var colliders = new Array<Collider>();

		if (m == null)
		{
			return colliders;
		}

		return m.map((entityId) ->
		{
			var entity = game.registry.getEntity(entityId);
			return entity.get(Collider);
		});
	}

	private function onEntityMoved(e:Entity)
	{
		var moved = e.get(Moved);
		var collider = e.get(Collider);

		var oldFootprint = collider.getFootprint(moved.previous.toIntPoint());
		for (pos in oldFootprint)
		{
			removeGridId(pos, e.id);
		}

		var newFootprint = collider.getFootprint(moved.current.toIntPoint());
		for (pos in newFootprint)
		{
			addGridId(pos, e.id);
		}

		redrawDebug = true;
	}

	public function add(collider:Collider)
	{
		var footprint = collider.getFootprint();

		for (pos in footprint)
		{
			addGridId(pos, collider.entity.id);
		}

		redrawDebug = true;
	}

	public function remove(collider:Collider)
	{
		var footprint = collider.getFootprint();

		for (pos in footprint)
		{
			removeGridId(pos, collider.entity.id);
		}

		redrawDebug = true;
	}

	private function addGridId(pos:IntPoint, entityId:String)
	{
		var m = grid.get(pos.x, pos.y);
		if (m == null)
		{
			return;
		}

		m.add(entityId);
	}

	private function removeGridId(pos:IntPoint, entityId:String)
	{
		var m = grid.get(pos.x, pos.y);
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
			debugGraphics.beginFill(0xff00ee, .5);

			for (cell in grid)
			{
				var count = cell.value.count();
				if (count > 0)
				{
					debugGraphics.beginFill(0xff00ee, .2 * count);
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
}
