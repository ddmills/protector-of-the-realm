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
		register(ACTOR_ROGUE, new ActorRogue());
		register(ACTOR_WIZARD, new ActorWizard());
		register(ACTOR_RANGER, new ActorRanger());
		register(ACTOR_GOBLIN, new ActorGoblin());
		register(ACTOR_SKELETON, new ActorSkeleton());
	}
}
