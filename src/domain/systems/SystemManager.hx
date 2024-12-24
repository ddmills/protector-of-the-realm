package domain.systems;

import core.Frame;

class SystemManager
{
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
		pathing.update(frame);
		monsters.update(frame);
		movement.update(frame);
		sprites.update(frame);
		colliders.update(frame);
		destroy.update(frame);
		inspection.update(frame);
		debugInfo.update(frame);
	}
}
