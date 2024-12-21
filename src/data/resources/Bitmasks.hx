package data.resources;

import common.struct.Cardinal;
import common.struct.DataRegistry;
import common.util.BitUtil;

enum BitmaskStyle
{
	BITMASK_STYLE_2D;
	BITMASK_STYLE_SIMPLE;
}

typedef BitmaskData =
{
	style:BitmaskStyle,
	tiles:Array<TileKey>,
};

class Bitmasks
{
	static var registry:DataRegistry<BitmaskType, BitmaskData>;

	public static function Init()
	{
		registry = new DataRegistry();
	}

	public static function Get(bitmaskType:BitmaskType)
	{
		return registry.get(bitmaskType);
	}

	public static function SumMask(fn:(x:Int, y:Int) -> Bool):Int
	{
		var directions:Array<Cardinal> = [NORTH_WEST, NORTH, NORTH_EAST, WEST, EAST, SOUTH_WEST, SOUTH, SOUTH_EAST];
		return directions.foldi((direction, sum, idx) ->
		{
			var offset = direction.toOffset();
			var countCell = fn(offset.x, offset.y);

			return countCell ? sum + 2.pow(idx) : sum;
		}, 0);
	}

	public static function GetTileKey(bitmaskType:BitmaskType, mask:Int)
	{
		var bm = Get(bitmaskType);

		if (bm.style == BITMASK_STYLE_SIMPLE)
		{
			mask = BitUtil.subtractBit(mask, 0);
			mask = BitUtil.subtractBit(mask, 2);
			mask = BitUtil.subtractBit(mask, 5);
			mask = BitUtil.subtractBit(mask, 7);
			var idx = switch mask
			{
				case 66: 0;
				case 0: 1;
				case 80: 2;
				case 72: 3;
				case 2: 4;
				case 24: 5;
				case 18: 6;
				case 10: 7;
				case 88: 8;
				case 26: 9;
				case 90: 10;
				case 74: 11;
				case 82: 12;
				case 16: 13;
				case 8: 14;
				case 64: 15;
				case _: 1;
			};
			return bm.tiles[idx];
		}

		if (bm.style == BITMASK_STYLE_2D)
		{
			mask = BitUtil.subtractBit(mask, 0);
			mask = BitUtil.subtractBit(mask, 2);
			mask = BitUtil.subtractBit(mask, 5);
			mask = BitUtil.subtractBit(mask, 7);

			var idx = switch mask
			{
				case 66: 1;
				case 0: 0;
				case 2: 1;
				case 24: 0;
				case 16: 0;
				case 8: 0;
				case 64: 1;
				case _: 1;
			};
			return bm.tiles[idx];
		}

		return TK_UNKNOWN;
	}
}
