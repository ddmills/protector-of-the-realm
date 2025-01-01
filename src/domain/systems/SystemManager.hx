package domain.systems;

import core.Frame;

class SystemManager
{
	public var behaviorScoring(default, null):BehaviorScoringSystem;
	public var behavior(default, null):BehaviorSystem;
	public var actionQueue(default, null):ActionQueueSystem;
	public var vision(default, null):VisionSystem;
	public var pathing(default, null):PathFollowSystem;
	public var monsters(default, null):MonsterSystem;
	public var movement(default, null):MovementSystem;
	public var sprites(default, null):SpriteSystem;
	public var colliders(default, null):ColliderSystem;
	public var destroy(default, null):DestroySystem;
	public var inspection(default, null):InspectionSystem;
	public var debugInfo(default, null):DebugInfoSystem;

	public function new() {}

	public function initialize()
	{
		behaviorScoring = new BehaviorScoringSystem();
		behavior = new BehaviorSystem();
		actionQueue = new ActionQueueSystem();
		vision = new VisionSystem();
		pathing = new PathFollowSystem();
		monsters = new MonsterSystem();
		movement = new MovementSystem();
		sprites = new SpriteSystem();
		colliders = new ColliderSystem();
		destroy = new DestroySystem();
		inspection = new InspectionSystem();
		debugInfo = new DebugInfoSystem();
	}

	public function update(frame:Frame)
	{
		behaviorScoring.update(frame);
		behavior.update(frame);
		actionQueue.update(frame);
		vision.update(frame);
		pathing.update(frame);
		monsters.update(frame);
		movement.update(frame);
		sprites.update(frame);
		colliders.update(frame);
		destroy.update(frame);
		inspection.update(frame);
		debugInfo.update(frame);
	}

	public function teardown()
	{
		behaviorScoring.teardown();
		behavior.teardown();
		actionQueue.teardown();
		vision.teardown();
		pathing.teardown();
		monsters.teardown();
		movement.teardown();
		sprites.teardown();
		colliders.teardown();
		destroy.teardown();
		inspection.teardown();
		debugInfo.teardown();
	}
}
