package domain.map;

import common.struct.Grid;
import common.struct.Set;
import core.Game;

typedef SaveVisionLayer =
{
	var grid:GridSave<Array<String>>;
	var exploration:GridSave<Bool>;
}

class VisionLayer extends MapLayer<Set<String>>
{
	public var exploration:Grid<Bool>;

	var fow(get, never):FogOfWar;

	public function init()
	{
		grid = new Grid(map.width, map.height);
		grid.fillFn(i -> new Set());
		exploration = new Grid(map.width, map.height);
		exploration.fill(false);
	}

	public function save():SaveVisionLayer
	{
		return {
			grid: grid.save(x -> x.items),
			exploration: exploration.save(x -> x),
		};
	}

	public function load(data:SaveVisionLayer)
	{
		grid.load(data.grid, x -> new Set(x));
		exploration.load(data.exploration, x -> x);

		for (cell in exploration)
		{
			if (cell.value)
			{
				fow.markExplored(cell.x, cell.y);
			}
		}
	}

	public function update()
	{
		fow.update();
	}

	public function addEntity(x:Int, y:Int, entityId:String)
	{
		var m = get(x, y);

		if (m != null)
		{
			m.add(entityId);
			exploration.set(x, y, true);
			fow.markVisible(x, y);
		}
	}

	public function removeEntity(x:Int, y:Int, entityId:String)
	{
		var m = get(x, y);

		if (m != null)
		{
			m.remove(entityId);

			if (m.isEmpty)
			{
				fow.markExplored(x, y);
			}
		}
	}

	inline function get_fow():FogOfWar
	{
		return Game.instance.world.fow;
	}
}
