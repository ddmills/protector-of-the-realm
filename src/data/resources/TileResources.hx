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

		tiles.set(TK_UNKNOWN, Tile.fromColor(0xff00ff, Game.TILE_WIDTH, Game.TILE_HEIGHT, .25));
		tiles.set(TK_WEED_01, env.weed_01.toTile());
		tiles.set(TK_WEED_02, env.weed_02.toTile());
		tiles.set(TK_WEED_03, env.weed_03.toTile());

		var trees = hxd.Res.environment.trees;

		tiles.set(TK_TREE_PINE_01, trees.pine_01.toTile());
		tiles.set(TK_TREE_PINE_02, trees.pine_02.toTile());
		tiles.set(TK_TREE_PINE_03, trees.pine_03.toTile());
		tiles.set(TK_TREE_PINE_04, trees.pine_04.toTile());
		tiles.set(TK_TREE_PINE_05, trees.pine_05.toTile());
		tiles.set(TK_TREE_PINE_06, trees.pine_06.toTile());
		tiles.set(TK_TREE_PINE_07, trees.pine_07.toTile());
		tiles.set(TK_TREE_PINE_08, trees.pine_08.toTile());
		tiles.set(TK_TREE_PINE_09, trees.pine_09.toTile());
		tiles.set(TK_TREE_PINE_10, trees.pine_10.toTile());

		var act = hxd.Res.actors;

		tiles.set(TK_WIZARD, act.wizard.toTile());
		tiles.set(TK_PALADIN, act.paladin.toTile());
		tiles.set(TK_ROGUE, act.rogue.toTile());
		tiles.set(TK_RANGER, act.ranger.toTile());

		tiles.set(TK_OGRE, act.ogre.toTile());
		tiles.set(TK_GOBLIN, act.goblin.toTile());
		tiles.set(TK_SKELETON, act.skeleton.toTile());

		var bld = hxd.Res.buildings;

		tiles.set(TK_GUILD_HALL, bld.guild_hall.toTile());
	}
}
