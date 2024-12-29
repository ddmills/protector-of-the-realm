package shaders;

import core.Game;

class FogShader extends hxsl.Shader
{
	static var SRC =
		{
			@input var input:
				{
					var position:Vec2;
					var uv:Vec2;
					var color:Vec4;
				};
			var output:
				{
					var position:Vec4;
					var color:Vec4;
				};
			var pixelColor:Vec4;
			var textureColor:Vec4;
			@param var fow:Sampler2D;
			@global var mapWidth:Int;
			@global var mapHeight:Int;
			@global var tileWidth:Int;
			@global var tileWidthHalf:Int;
			@global var tileHeight:Int;
			@global var tileHeightHalf:Int;
			@global var clearColor:Vec3;
			function fragment()
			{
				var px = (input.uv.x * tileWidth * mapWidth) - (mapWidth * tileWidthHalf);
				var py = input.uv.y * tileHeight * mapHeight;

				var wx = ((px / tileWidthHalf) + (py / tileHeightHalf)) / 2.;
				var wy = ((py / tileHeightHalf) - (px / tileWidthHalf)) / 2.;

				var sx = wx / mapWidth;
				var sy = wy / mapHeight;

				var fog = fow.get(vec2(sx, sy));

				output.color.rgb = clearColor;
				output.color.a = fog.a;
			}
		};

	public function new()
	{
		super();
		fow = Game.instance.world.fow.renderTexture;
	}
}
