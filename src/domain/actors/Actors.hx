package domain.actors;

import common.struct.DataRegistry;
import data.domain.ActorType;

class Actors extends DataRegistry<ActorType, Actor>
{
	public function new()
	{
		super();

		register(ACTOR_OGRE, new ActorOgre());
		register(ACTOR_PALADIN, new ActorPaladin());
	}
}
