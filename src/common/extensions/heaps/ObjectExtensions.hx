package common.extensions.heaps;

import common.struct.FloatPoint;
import h2d.Object;

class ObjectExtension
{
	public static function pos(o:Object):FloatPoint
	{
		return new FloatPoint(o.x, o.y);
	}
}
