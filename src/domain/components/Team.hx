package domain.components;

import ecs.Component;

class Team extends Component
{
	public var team:String;

	public function new(team:String)
	{
		this.team = team;
	}
}
