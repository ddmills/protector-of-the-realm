package domain.buildings;

import common.struct.DataRegistry;
import data.domain.BuildingType;

class Buildings extends DataRegistry<BuildingType, Building>
{
	public function new()
	{
		super();

		register(BLDG_GUILD_HALL, new BuildingGuildHall());
	}
}
