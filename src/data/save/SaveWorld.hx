package data.save;

import core.Camera.SaveCamera;
import core.Clock.SaveClock;
import ecs.Entity.EntitySaveData;

typedef SaveWorld =
{
	seed:Int,
	entities:Array<EntitySaveData>,
	camera:SaveCamera,
	clock:SaveClock,
}
