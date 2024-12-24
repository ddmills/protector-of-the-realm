package data.resources;

import h2d.Font;

class FontResources
{
	public static var BIZCAT:Font;

	public static function Init()
	{
		BIZCAT = hxd.Res.fnt.bizcat.toFont();
	}
}
