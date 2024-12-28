package domain.prefabs;

import common.struct.Coordinate;
import common.struct.FloatPoint;
import domain.components.Sprite;
import domain.prefabs.decorators.ActorDecorator;
import ecs.Entity;

class OgrePrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var e = new Entity(pos);

		ActorDecorator.Decorate(e, {
			actorType: ACTOR_OGRE,
			tileKey: TK_OGRE,
		});

		var sprite = e.get(Sprite);

		sprite.width = 40;
		sprite.height = 40;
		sprite.origin = new FloatPoint(.5, .5);

		return e;
	}
}
