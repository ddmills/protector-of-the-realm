package domain.components;

import common.struct.IntPoint;
import common.struct.Shape;
import common.util.BitUtil;
import core.Game;
import domain.systems.ColliderSystem.ColliderFlag;
import ecs.Component;

class Collider extends Component
{
	@save public var shape(default, set):Shape = CIRCLE(1);
	@save public var offset(default, set):IntPoint = new IntPoint(0, 0);
	@save public var flags(default, default):Int = 0;
	@save public var spots(default, default):Array<IntPoint>;

	public function new(shape:Shape, offset:IntPoint, flags:Array<ColliderFlag>)
	{
		this.shape = shape;
		this.offset = offset;
		this.spots = [];
		flags?.each(addFlag);
	}

	public function addFlag(flag:ColliderFlag)
	{
		flags = BitUtil.addBit(flags, flag);
	}

	public function removeFlag(flag:ColliderFlag)
	{
		flags = BitUtil.subtractBit(flags, flag);
	}

	public function hasFlag(flag:ColliderFlag):Bool
	{
		return BitUtil.hasBit(flags, flag);
	}

	public function hasAnyFlags(flags:Array<ColliderFlag>):Bool
	{
		return flags.exists(hasFlag);
	}

	override function onAttach()
	{
		Game.instance.world.systems.colliders.add(this);
	}

	override function onRemove()
	{
		Game.instance.world.systems.colliders.remove(this);
	}

	function set_shape(value:Shape):Shape
	{
		return shape = value;
	}

	function set_offset(value:IntPoint):IntPoint
	{
		return offset = value;
	}

	public function getFootprint(?pos:IntPoint):Array<IntPoint>
	{
		pos ??= entity.pos.toIntPoint();

		return shape.getFootprint(pos.add(offset));
	}
}
