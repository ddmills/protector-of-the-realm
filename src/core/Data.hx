package core;

import domain.buildings.Buildings;

class Data
{
	public static var Buildings(default, null):Buildings;

	// TODO: add fonts, tiles, etc here.

	public static function Init()
	{
		Buildings = new Buildings();
	}
}
