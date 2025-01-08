package domain.components.tasks;

import core.Game;

class TaskTryMelee extends TaskComponent
{
	@save public var duration:Float;
	@save public var progress:Float;

	public function new()
	{
		super();
		this.duration = 1;
		this.progress = 0;
	}

	public function getLabel():String
	{
		var bb = entity.get(Blackboard);
		var target = Game.instance.registry.getEntity(bb.targetId);
		var label = target?.get(Label)?.text ?? 'Unknown';

		return 'Attacking ${label} ${progress.format(1)}';
	}
}
