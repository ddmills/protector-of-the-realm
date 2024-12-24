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
			@param var scale:Float;
			function fragment()
			{
				var a = pixelColor.a;
				var c = texture.get(calculatedUV * scale);
				c.a = a;

				pixelColor = mix(c, vec4(0, 0, 0, 1), .2);
			}
		}

	public function new(texture:Texture, scale:Float)
	{
		this.texture = texture;
		this.scale = scale;
		super();
	}
}
