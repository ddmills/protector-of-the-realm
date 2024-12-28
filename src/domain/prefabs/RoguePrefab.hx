package domain.prefabs;

import common.struct.Coordinate;
import domain.prefabs.decorators.ActorDecorator;
import ecs.Entity;

class RoguePrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var e = new Entity(pos);

		ActorDecorator.Decorate(e, {
			actorType: ACTOR_ROGUE,
			tileKey: TK_ROGUE,
			isPlayer: true,
		});

		return e;
	}
}
