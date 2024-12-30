package common.extensions.heaps;

import common.util.Projection;
import core.Game;
import h2d.Graphics;

class GraphicsExtensions
{
	public static function drawIsometricTile(g:Graphics, wx:Float, wy:Float, width:Float = 1, height:Float = 1)
	{
		var px = Projection.worldToPx(wx, wy);

		var h = Game.TILE_HEIGHT_HALF;
		var w = Game.TILE_WIDTH_HALF;

		g.lineTo(px.x, px.y);
		g.lineTo((px.x) + (width * w), (px.y) + (height * h));
		g.lineTo(px.x, (px.y + (Game.TILE_HEIGHT * height)));
		g.lineTo(px.x - (width * w), px.y + (height * h));
		g.lineTo(px.x, px.y);
	}
}
