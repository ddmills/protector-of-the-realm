package shaders;

import h3d.mat.Texture;
import hxsl.Shader;

class TerrainShader extends Shader
{
	static var SRC =
		{
			var pixelColor:Vec4;
			var calculatedUV:Vec2;
			@param var scale:Float;
			@param var splat0:Sampler2D;
			@param var splat1:Sampler2D;
			@param var splat2:Sampler2D;
			@param var splat3:Sampler2D;
			@param var splat4:Sampler2D;
			function fragment()
			{
				var offsetUV = calculatedUV * scale;
				var s0 = splat0.get(offsetUV);
				var s1 = splat1.get(offsetUV);
				var s2 = splat2.get(offsetUV);
				var s3 = splat3.get(offsetUV);
				var s4 = splat4.get(offsetUV);

				var sum = pixelColor.r + pixelColor.g + pixelColor.b + (1 - pixelColor.a);
				var v0 = 1 - min(1, sum);

				var c0 = s0 * v0;
				var c1 = s1 * pixelColor.r;
				var c2 = s2 * pixelColor.g;
				var c3 = s3 * pixelColor.b;
				var c4 = s4 * (1 - pixelColor.a);

				pixelColor = (c0 + c1 + c2 + c3 + c4) / (sum + v0);
				pixelColor = mix(pixelColor, vec4(0, 0, 0, 1), .2);
			}
		}

	public function new(splat0:Texture, splat1:Texture, splat2:Texture, splat3:Texture, splat4:Texture, scale:Float)
	{
		this.splat0 = splat0;
		this.splat1 = splat1;
		this.splat2 = splat2;
		this.splat3 = splat3;
		this.splat4 = splat4;
		this.scale = scale;
		super();
	}
}
