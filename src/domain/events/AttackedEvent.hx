package domain.events;

import ecs.Entity;
import ecs.EntityEvent;

typedef Attack =
{
	attacker:Entity,
	defender:Entity,
	damage:Int,
}

class AttackedEvent extends EntityEvent
{
	public var attack:Attack;

	public function new(attack:Attack)
	{
		this.attack = attack;
	}
}
