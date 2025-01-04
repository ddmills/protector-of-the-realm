package domain.prefabs.decorators;

import common.struct.FloatPoint;
import common.struct.IntPoint;
import core.Data;
import data.domain.ActorType;
import data.resources.TileKey;
import domain.components.ActionQueue;
import domain.components.Actor;
import domain.components.Blackboard;
import domain.components.Collider;
import domain.components.Inspectable;
import domain.components.IsObservable;
import domain.components.IsPlayer;
import domain.components.Label;
import domain.components.Sprite;
import domain.components.Vision;
import domain.components.behaviors.IdleBehaviorScorer;
import domain.components.behaviors.WanderBehaviorScorer;
import ecs.Entity;

typedef ActorOptions =
{
	?actorType:ActorType,
	?tileKey:Null<TileKey>,
	?visionRange:Null<Int>,
	?clickRadius:Null<Int>,
	?isPlayer:Bool,
}

class ActorDecorator
{
	public static function Decorate(entity:Entity, options:ActorOptions)
	{
		var actor = Data.Actors.get(options.actorType);

		entity.add(new Actor(options.actorType));

		// BEHAVIORS
		// entity.add(new IdleBehaviorScorer());
		entity.add(new WanderBehaviorScorer());

		if (options.isPlayer == true)
		{
			entity.add(new IsPlayer());
		}

		var sprite = new Sprite(options.tileKey.or(TK_UNKNOWN), OBJECTS);
		sprite.width = 32;
		sprite.height = 32;
		sprite.origin = new FloatPoint(.5, .9);

		entity.add(sprite);
		entity.add(new Label(actor.actorTypeName));
		entity.add(new Blackboard());
		entity.add(new Collider(POINT, new IntPoint(0, 0), [FLG_UNIT]));
		entity.add(new Vision(options.visionRange.or(6)));
		entity.add(new Inspectable(actor.actorTypeName, options.clickRadius.or(16)));
		entity.add(new ActionQueue());
		entity.add(new IsObservable());
	}
}
