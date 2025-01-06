package domain.components;

import domain.actors.TeamType;
import ecs.Component;

class Team extends Component
{
	public var teamType:TeamType;

	public function new(teamType:TeamType)
	{
		this.teamType = teamType;
	}
}
