package domain.map;

import h2d.Object;
import haxe.io.Bytes;
import hxd.Pixels;
import hxsl.Types.Texture;

class FogOfWar extends Object
{
	public var renderTexture:Texture;
	public var isDirty:Bool;

	var pixels:Pixels;

	var colorVisible:Int = 0x00000000;
	var colorExplored:Int = 0x7e1c2020;
	var colorUnexplored:Int = 0xff1C2020;

	public function new(width:Int, height:Int)
	{
		super();

		this.y = 300;

		var bytes = Bytes.alloc(width * height * 4);
		pixels = new Pixels(width, height, bytes, RGBA);

		for (x in 0...width)
		{
			for (y in 0...height)
			{
				pixels.setPixel(x, y, colorUnexplored);
			}
		}

		renderTexture = new Texture(width, height, [Dynamic]);
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
		if (x > 0 && y > 0 && x < (pixels.width - 1) && y < (pixels.height - 1))
		{
			pixels.setPixel(x, y, colorExplored);
			isDirty = true;
		}
	}

	public function markVisible(x:Int, y:Int)
	{
		if (x > 0 && y > 0 && x < (pixels.width - 1) && y < (pixels.height - 1))
		{
			pixels.setPixel(x, y, colorVisible);
			isDirty = true;
		}
	}
}
