package domain.buildings;

import common.struct.IntPoint;
import common.struct.Shape;
import domain.events.QueryActionsEvent.EntityActionType;
import ecs.Entity;

class Building
{
	public var name(get, never):String;
	public var width(get, never):Int;
	public var height(get, never):Int;
	public var placementPadding(get, never):Int;

	public function getActions(entity:Entity):Array<EntityActionType>
	{
		return [];
	}

	public function getFootprint(entity:Entity, ?includePadding:Bool):Array<IntPoint>
	{
		var w = width;
		var h = height;

		if (includePadding)
		{
			w += placementPadding * 2;
			h += placementPadding * 2;
		}

		return Shape.RECTANGLE(w, h).getFootprint(entity.pos.toIntPoint());
	}

	function get_name():String
	{
		return "UNKNOWN";
	}

	function get_width():Int
	{
		return 1;
	}

	function get_height():Int
	{
		return 1;
	}

	function get_placementPadding():Int
	{
		return 2;
	}
}
