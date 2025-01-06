package domain.prefabs;

import common.struct.Coordinate;
import domain.prefabs.decorators.ActorDecorator;
import ecs.Entity;

class RangerPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var e = new Entity(pos);

		ActorDecorator.Decorate(e, {
			actorType: ACTOR_RANGER,
			tileKey: TK_RANGER,
			visionRange: 10,
			team: PLAYER,
		});

		return e;
	}
}
