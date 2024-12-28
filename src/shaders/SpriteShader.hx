package shaders;

class SpriteShader extends hxsl.Shader
{
	static var SRC =
		{
			var pixelColor:Vec4;
			@param var isShrouded:Int;
			@param var shroudTint:Vec3;
			function fragment()
			{
				if (isShrouded == 1 && pixelColor.a != 0)
				{
					pixelColor.rgb = mix(pixelColor.rgb, shroudTint, .6);
				}
			}
		};

	public function new()
	{
		super();
		isShrouded = 0;
		shroudTint = 0xFF191E24.toVector();
	}

	public function setShrouded(value:Bool)
	{
		isShrouded = value ? 1 : 0;
	}
}
