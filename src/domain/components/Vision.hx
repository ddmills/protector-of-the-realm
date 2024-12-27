package domain.components;

import common.struct.IntPoint;
import common.struct.Shape;
import ecs.Component;

class Vision extends Component
{
	@save public var range:Int;
	@save public var current(default, default):Array<IntPoint>;

	public function new(range:Int)
	{
		this.range = range;
		this.current = [];
	}

	public function getFootprint(?pos:IntPoint):Array<IntPoint>
	{
		pos ??= entity.pos.toIntPoint();

		return Shape.CIRCLE(range).getFootprint(pos);
	}
}
