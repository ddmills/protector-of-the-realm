package shaders;

import h3d.mat.Texture;
import hxsl.Shader;

class SplatShader extends Shader
{
	static var SRC =
		{
			var pixelColor:Vec4;
			var calculatedUV:Vec2;
			@param var texture:Sampler2D;
			function fragment()
			{
				var a = pixelColor.a;
				var c = texture.get(calculatedUV);
				c.a = a;

				pixelColor = mix(c, vec4(0, 0, 0, 1), .2);
			}
		}

	public function new(texture:Texture)
	{
		this.texture = texture;
		super();
	}
}
