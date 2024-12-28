package domain.prefabs;

import common.struct.Coordinate;
import domain.prefabs.decorators.ActorDecorator;
import ecs.Entity;

class SkeletonPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var e = new Entity(pos);

		ActorDecorator.Decorate(e, {
			actorType: ACTOR_SKELETON,
			tileKey: TK_SKELETON,
		});

		return e;
	}
}
