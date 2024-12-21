package domain.components;

import common.struct.IntPoint;
import common.struct.Shape;
import ecs.Component;

class Building extends Component
{
	@save public var name:String;
	@save public var bufferRadius:Int = 7;
	public var bufferRadiusX(get, never):Int;
	public var bufferRadiusY(get, never):Int;

	public var footprint(get, never):Array<IntPoint>;

	public function new(name:String, bufferRadius:Int)
	{
		this.name = name;
		this.bufferRadius = bufferRadius;
	}

	function get_footprint():Array<IntPoint>
	{
		return Shape.ELLIPSE(bufferRadiusX, bufferRadiusY).getFootprint(entity.pos.toIntPoint());
	}

	inline function get_bufferRadiusX():Int
	{
		return bufferRadius;
	}

	inline function get_bufferRadiusY():Int
	{
		return bufferRadius - 2;
	}
}
