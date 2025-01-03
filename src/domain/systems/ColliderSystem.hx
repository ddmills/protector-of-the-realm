package domain.systems;

import common.struct.IntPoint;
import common.struct.Set;
import common.util.BitUtil;
import core.Frame;
import domain.components.Collider;
import domain.components.IsDestroyed;
import domain.components.IsDetached;
import domain.components.Move;
import domain.components.Moved;
import domain.map.CollisionLayer;
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
	public var debug(default, set):Bool;
	public var layer(get, never):CollisionLayer;

	var debugGraphics:Graphics;
	var redrawDebug:Bool = false;

	public function new()
	{
		debugGraphics = new Graphics();
		game.render(OVERLAY, debugGraphics);

		var created = new Query({
			all: [Collider],
			none: [IsDetached],
		});

		var moved = new Query({
			all: [Collider, Moved],
			none: [IsDetached],
		});

		var move = new Query({
			all: [Collider, Move],
			none: [IsDetached],
		});

		var destroyed = new Query({
			all: [Collider],
			any: [IsDestroyed, IsDetached],
		});

		moved.onEntityAdded(onEntityMoved);
		move.onEntityAdded(onEntityMove);
		created.onEntityAdded(onEntityCreated);
		destroyed.onEntityAdded(onEntityDestroyed);
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
		var ids = layer.get(pos.x, pos.y);

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

	public function hasCollisions(collider:Collider, flags:Array<ColliderFlag>, ?pos:IntPoint):Bool
	{
		var footprint = collider.getFootprint(pos);

		for (fp in footprint)
		{
			var colliders = getCollidersAt(fp);

			if (colliders.exists(c -> c != collider && c.hasAnyFlags(flags)))
			{
				return true;
			}
		}

		return false;
	}

	private function getCollidersAt(pos:IntPoint):Array<Collider>
	{
		var m = layer.get(pos.x, pos.y);
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

	private function onEntityDestroyed(e:Entity)
	{
		var collider = e.get(Collider);

		for (pos in collider.spots)
		{
			removeGridId(pos, e.id);
		}

		collider.spots = [];
	}

	public function hasCollisionFastNav(pos:IntPoint, entityId:String):Bool
	{
		var fm = layer.fastNavGrid.get(pos.x, pos.y);

		if (fm == null)
		{
			return false;
		}

		// return fm.exists(e -> e != entityId);
		return !fm.isEmpty;
	}

	private function onEntityMoved(e:Entity)
	{
		var moved = e.get(Moved);
		var collider = e.get(Collider);

		for (pos in collider.spots)
		{
			removeGridId(pos, e.id);
		}

		collider.spots = collider.getFootprint(moved.current.toIntPoint());

		for (pos in collider.spots)
		{
			addGridId(pos, e.id, collider.flags);
		}

		redrawDebug = true;
	}

	private function onEntityCreated(e:Entity)
	{
		var collider = e.get(Collider);

		for (pos in collider.spots)
		{
			removeGridId(pos, e.id);
		}

		collider.spots = collider.getFootprint(e.pos.toIntPoint());

		for (pos in collider.spots)
		{
			addGridId(pos, e.id, collider.flags);
		}

		redrawDebug = true;
	}

	private function onEntityMove(e:Entity)
	{
		var move = e.get(Move);
		var collider = e.get(Collider);

		var newFootprint = collider.getFootprint(move.goal.toIntPoint());
		for (pos in newFootprint)
		{
			addGridId(pos, e.id, collider.flags);
			collider.spots.push(pos);
		}

		redrawDebug = true;
	}

	public function add(collider:Collider)
	{
		var footprint = collider.getFootprint();

		for (pos in footprint)
		{
			addGridId(pos, collider.entity.id, collider.flags);
			collider.spots.push(pos);
		}

		redrawDebug = true;
	}

	public function remove(collider:Collider)
	{
		for (pos in collider.spots)
		{
			removeGridId(pos, collider.entity.id);
		}

		collider.spots = [];

		redrawDebug = true;
	}

	private function addGridId(pos:IntPoint, entityId:String, flags:Int)
	{
		var m = layer.get(pos.x, pos.y);

		if (m == null)
		{
			return;
		}

		m.add(entityId);

		if (BitUtil.hasBit(flags, FLG_OBJECT) || BitUtil.hasBit(flags, FLG_BUILDING))
		{
			var fm = layer.getFastNavValue(pos.x, pos.y);
			fm.add(entityId);
		}
	}

	private function removeGridId(pos:IntPoint, entityId:String)
	{
		var m = layer.get(pos.x, pos.y);
		if (m == null)
		{
			return;
		}

		m.remove(entityId);

		var fm = layer.fastNavGrid.get(pos.x, pos.y);

		if (fm == null)
		{
			return;
		}

		fm.remove(entityId);
	}

	private function updateDebug(value:Bool)
	{
		if (value)
		{
			debugGraphics.clear();
			debugGraphics.beginFill(0xff00ee, .5);

			for (cell in layer.grid)
			{
				var count = cell.value.count();
				if (count > 0)
				{
					debugGraphics.beginFill(0xff00ee, .2 * count);
					debugGraphics.drawIsometricTile(cell.x, cell.y);
					debugGraphics.endFill();
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

	function get_layer():CollisionLayer
	{
		return world.map.collision;
	}
}
