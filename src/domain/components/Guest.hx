package domain.components;

import core.Game;
import ecs.Component;
import ecs.Entity;

class Guest extends Component
{
	@save public var buildingEntityId(default, null):String;

	public function new(buildingEntityId:String)
	{
		this.buildingEntityId = buildingEntityId;
	}

	public function getBuilding():Null<Entity>
	{
		return Game.instance.registry.getEntity(buildingEntityId);
	}

	override function onRemove()
	{
		var e = getBuilding();

		if (e != null)
		{
			var b = e.get(Building);

			if (b != null)
			{
				b.guests.remove(entity.id);
			}
		}
	}
}
