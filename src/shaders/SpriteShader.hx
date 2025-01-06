package shaders;

class SpriteShader extends hxsl.Shader
{
	static var SRC =
		{
			@:import h3d.shader.Base2d;
			@borrow(h3d.shader.Base2d)
			var texture:Sampler2D;
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
