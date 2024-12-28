package domain.prefabs;

import common.struct.Coordinate;
import domain.components.Sprite;
import domain.prefabs.decorators.ActorDecorator;
import ecs.Entity;

class GoblinPrefab extends Prefab
{
	public function Create(options:Dynamic, pos:Coordinate):Entity
	{
		var e = new Entity(pos);

		ActorDecorator.Decorate(e, {
			actorType: ACTOR_GOBLIN,
			tileKey: TK_GOBLIN,
		});

		var sprite = e.get(Sprite);

		return e;
	}
}
