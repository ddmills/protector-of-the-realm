package domain.components;

import domain.events.AttackedEvent;
import ecs.Component;

class Health extends Component
{
	@save var _value:Int;

	@save public var max:Int;

	public var value(get, set):Int;
	public var percent(get, never):Float;

	public function new(max:Int)
	{
		this.max = max;
		_value = max;

		addHandler(AttackedEvent, onAttacked);
	}

	public function onAttacked(evt:AttackedEvent)
	{
		value -= evt.attack.damage;

		if (value <= 0)
		{
			entity.add(new IsDead('Killed by ${evt.attack.attacker.id}'));
		}
	}

	function set_value(value:Int):Int
	{
		_value = value.clamp(0, max);

		return _value;
	}

	function get_percent():Float
	{
		return _value / max;
	}

	function get_value():Int
	{
		return _value;
	}
}
