package data.resources;

import core.Game;
import h2d.Tile;

class TileResources
{
	public static var tiles:Map<TileKey, Tile> = [];

	public static function Get(key:TileKey):Tile
	{
		if (key.isNull())
		{
			return null;
		}

		var tile = tiles.get(key);

		if (tile.isNull())
		{
			return tiles.get(TK_UNKNOWN);
		}

		return tile;
	}

	public static function Init()
	{
		var env = hxd.Res.environment;

		tiles.set(TK_UNKNOWN, Tile.fromColor(0xff00ff, Game.TILE_SIZE, Game.TILE_SIZE, .25));
		tiles.set(TK_WEED_01, env.Weed_01.toTile());
		tiles.set(TK_WEED_02, env.Weed_02.toTile());
		tiles.set(TK_WEED_03, env.Weed_03.toTile());

		var act = hxd.Res.actors;

		tiles.set(TK_WIZARD, act.wizard.toTile());
		tiles.set(TK_PALADIN, act.paladin.toTile());
		tiles.set(TK_ROGUE, act.rogue.toTile());
		tiles.set(TK_OGRE, act.ogre.toTile());

		var bld = hxd.Res.buildings;

		tiles.set(TK_GUILD_HALL, bld.guild_hall.toTile());
	}
}
