package domain.prefabs;

import common.struct.Coordinate;
import domain.prefabs.decorators.ActorDecorator;
import ecs.Entity;

class PaladinPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var e = new Entity(pos);

		ActorDecorator.Decorate(e, {
			actorType: ACTOR_PALADIN,
			tileKey: TK_PALADIN,
			isPlayer: true,
			visionRange: 5,
		});

		return e;
	}
}
