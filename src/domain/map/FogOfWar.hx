package domain.map;

import core.Game;
import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;
import haxe.io.Bytes;
import hxd.Pixels;
import hxsl.Types.Texture;

class FogOfWar extends Object
{
	public var renderTexture:Texture;
	public var isDirty:Bool;

	var pixels:Pixels;

	var colorVisible:Int = 0x00000000;
	var colorExplored:Int = 0xAB0C1C30;
	var colorUnexplored:Int = 0xFF030911;

	public function new(width:Int, height:Int)
	{
		super();

		var bytes = Bytes.alloc(width * height * 4);
		pixels = new Pixels(width, height, bytes, RGBA);

		for (x in 0...width)
		{
			for (y in 0...height)
			{
				pixels.setPixel(x, y, colorUnexplored);
			}
		}

		renderTexture = Texture.fromPixels(pixels);

		var t = Tile.fromTexture(renderTexture);
		var bm = new Bitmap(t);
		var blur = new h2d.filter.Blur(60, 1, 1, 1);
		bm.filter = blur;

		bm.width = width * Game.TILE_SIZE;
		bm.height = height * Game.TILE_SIZE;

		addChild(bm);
	}

	public function update()
	{
		if (isDirty)
		{
			isDirty = false;
			renderTexture.uploadPixels(pixels);
		}
	}

	public function markExplored(x:Int, y:Int)
	{
		pixels.setPixel(x, y, colorExplored);
		isDirty = true;
	}

	public function markVisible(x:Int, y:Int)
	{
		pixels.setPixel(x, y, colorVisible);
		isDirty = true;
	}
}
