package domain.map;

import common.struct.Grid;
import core.Game;
import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;
import h2d.TileGroup;
import hxd.Rand;
import shaders.FogShader;

enum TerrainType
{
	GRASS;
	DIRT;
	WATER;
}

class Terrain extends Object
{
	var width:Int;
	var height:Int;

	public var terrain:Grid<TerrainType>;

	var tileGroup:TileGroup;
	var tiles:Array<Array<Tile>>;

	var rand:Rand;

	public function new(width:Int, height:Int, ?parent:Object)
	{
		super(parent);
		this.width = width;
		this.height = height;
		this.rand = Rand.create();

		terrain = new Grid(width, height);
		terrain.fill(GRASS);

		var tex = hxd.Res.terrain.terrain_64.toTile();

		tiles = tex.divide(4, 4);
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
		var dirtline = .5;

		for (x in 0...width)
		{
			for (y in 0...height)
			{
				var h = p.get(x, y, 14, 3);
				if (h < waterline)
				{
					setTerrain(x, y, WATER);
				}
				else if (h < dirtline)
				{
					setTerrain(x, y, DIRT);
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

		var px = ((x - y) * Game.TILE_WIDTH_HALF) - Game.TILE_WIDTH_HALF;
		var py = ((x + y) * Game.TILE_HEIGHT_HALF) - Game.TILE_HEIGHT;

		tileGroup.add(px, py, tile);
	}

	function getTile(terrainType:TerrainType):Tile
	{
		return switch terrainType
		{
			case GRASS: rand.pick(tiles[0]);
			case DIRT: rand.pick(tiles[1]);
			case WATER: rand.pick(tiles[2]);
		}
	}
}
