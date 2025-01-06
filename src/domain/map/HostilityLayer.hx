package domain.map;

import common.algorithm.Distance;
import common.struct.GridMap;
import common.struct.IntPoint;
import domain.actors.TeamType;

typedef NearbyResult =
{
	entityId:String,
	distance:Int,
}

class HostilityLayer extends MapLayer
{
	public var players:GridMap<String>;
	public var monsters:GridMap<String>;
	public var partitionSize:Int;
	public var partitionCountX:Int;
	public var partitionCountY:Int;

	public function init()
	{
		partitionSize = map.partitionSize;
		partitionCountX = (map.width / map.partitionSize).ciel();
		partitionCountY = (map.height / map.partitionSize).ciel();

		players = new GridMap(partitionCountX, partitionCountY);
		monsters = new GridMap(partitionCountX, partitionCountY);
	}

	public inline function getPartitionCoords(wx:Int, wy:Int):IntPoint
	{
		return new IntPoint((wx / partitionSize).floor(), (wy / partitionSize).floor());
	}

	public function updateEntityPosition(entityId:String, teamType:TeamType, x:Int, y:Int)
	{
		var g = getGrid(teamType);
		var c = getPartitionCoords(x, y);
		g.set(c.x, c.y, entityId);
	}

	public function getPartitionIdx(wx:Int, wy:Int):Int
	{
		var c = getPartitionCoords(wx, wy);
		var idx = players.idx(c.x, c.y);

		return idx;
	}

	public function removeEntity(entityId:String)
	{
		players.remove(entityId);
		monsters.remove(entityId);
	}

	public function getEntityIdsInPartition(teamType:TeamType, wx:Int, wy:Int):Array<String>
	{
		var g = getGrid(teamType);
		var c = getPartitionCoords(wx, wy);

		return g.get(c.x, c.y);
	}

	public function getWithinRange(teamType:TeamType, wx:Int, wy:Int, range:Int):Array<NearbyResult>
	{
		var source = new IntPoint(wx, wy);
		var g = getGrid(teamType);

		var left = ((wx - range) / partitionSize).clamp(0, partitionCountX).floor();
		var top = ((wy - range) / partitionSize).clamp(0, partitionCountY).floor();
		var right = ((wx + range) / partitionSize).clamp(0, partitionCountX).floor();
		var bottom = ((wy + range) / partitionSize).clamp(0, partitionCountY).floor();

		var results = [];

		for (x in left...(right + 1))
		{
			for (y in top...(bottom + 1))
			{
				for (e in g.get(x, y))
				{
					var pos = map.position.getPosition(e);
					var dist = Distance.Diagonal(source, pos).round();

					if (dist <= range)
					{
						results.push({
							entityId: e,
							distance: dist,
						});
					}
				}
			}
		}

		return results;
	}

	public inline function getGrid(team:TeamType):GridMap<String>
	{
		if (team == PLAYER)
		{
			return players;
		}

		return monsters;
	}
}
