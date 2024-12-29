package domain.map;

import common.struct.Grid;
import core.Game;
import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;
import h2d.TileGroup;
import shaders.FogShader;

enum TerrainType
{
	GRASS;
	WATER;
}

class Terrain extends Object
{
	var width:Int;
	var height:Int;

	var terrain:Grid<TerrainType>;

	var tileGroup:TileGroup;
	var tiles:Array<Array<Tile>>;

	public function new(width:Int, height:Int, ?parent:Object)
	{
		super(parent);
		this.width = width;
		this.height = height;

		terrain = new Grid(width, height);
		terrain.fill(GRASS);

		var tex = hxd.Res.terrain.terrain_32.toTile();

		tiles = tex.divide(4, 2);
		tileGroup = new TileGroup(tex, this);

		var fogt = Tile.fromColor(0x000000);
		var fogbm = new Bitmap(fogt, this);

		fogbm.width = width * Game.TILE_WIDTH;
		fogbm.height = height * Game.TILE_HEIGHT;
		fogbm.x -= (width * Game.TILE_WIDTH_HALF);

		fogbm.addShader(new FogShader());

		generate();
	}

	private function generate()
	{
		var p = new common.rand.Perlin(1);
		var waterline = .4;

		for (x in 0...width)
		{
			for (y in 0...height)
			{
				if (p.get(x, y, 16, 3) < waterline)
				{
					setTerrain(x, y, WATER);
				}
				else
				{
					setTerrain(x, y, GRASS);
				}
			}
		}
	}

	function setTerrain(x:Int, y:Int, terrainType:TerrainType)
	{
		terrain.set(x, y, terrainType);
		var tile = getTile(terrainType);

		var px = ((x - y) * 16) - Game.TILE_WIDTH_HALF;
		var py = (x + y) * 8;

		tileGroup.add(px, py, tile);
	}

	function getTile(terrainType:TerrainType):Tile
	{
		return switch terrainType
		{
			case GRASS: tiles[0][2];
			case WATER: tiles[0][1];
		}
	}
}
