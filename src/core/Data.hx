package core;

import domain.actors.Actors;
import domain.ai.behaviors.Behaviors;
import domain.buildings.Buildings;

class Data
{
	public static var Buildings(default, null):Buildings;
	public static var Actors(default, null):Actors;
	public static var Behaviors(default, null):Behaviors;

	// TODO: add fonts, tiles, etc here.

	public static function Init()
	{
		Buildings = new Buildings();
		Actors = new Actors();
		Behaviors = new Behaviors();
	}
}
