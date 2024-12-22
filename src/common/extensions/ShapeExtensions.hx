package common.extensions;

import common.algorithm.Bresenham;
import common.struct.IntPoint;
import common.struct.Shape;

class ShapeExtensions
{
	public static function getFootprint(shape:Shape, ?source:IntPoint):Array<IntPoint>
	{
		source = source ?? new IntPoint(0, 0);
		switch shape
		{
			case POINT:
				return [source];
			case ELLIPSE(radius1, radiu2):
				return Bresenham.getEllipse(source, radius1, radiu2);
			case CIRCLE(radius):
				return Bresenham.getCircle(source, radius, true);
			case RECTANGLE(w, h):
				var offset = source.sub((w / 2).floor(), (h / 2).floor());
				return Bresenham.getRect(offset, w, h);
		}
	}
}
