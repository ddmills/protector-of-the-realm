package domain.components;

import common.struct.IntPoint;
import common.struct.Shape;
import ecs.Component;

class Building extends Component
{
	@save public var width:Int;
	@save public var height:Int;

	public var footprint(get, never):Array<IntPoint>;

	public function new(width:Int, height:Int)
	{
		this.width = width;
		this.height = height;
	}

	function get_footprint():Array<IntPoint>
	{
		return Shape.RECTANGLE(width, height).getFootprint(entity.pos.toIntPoint());
	}
}
