package domain.map;

import common.struct.Coordinate;
import common.struct.IntPoint;
import core.Game;
import h2d.Bitmap;
import h2d.Object;
import hxd.res.Image;
import shaders.SplatShader;
import shaders.TerrainShader;

class Terrain extends Object
{
	var bm:Bitmap;
	var img:Image;
	var splats:Array<Bitmap>;
	var textureScale = 4;

	public function new(width:Int, height:Int, ?parent:Object)
	{
		super(parent);
		img = hxd.Res.terrain.Control;
		bm = new Bitmap(img.toTile());

		var splat0 = hxd.Res.terrain.Dirt_02.toTexture();
		splat0.wrap = Repeat;
		var splat1 = hxd.Res.terrain.Grass_01.toTexture();
		splat1.wrap = Repeat;
		var splat2 = hxd.Res.terrain.Grass_04.toTexture();
		splat2.wrap = Repeat;
		var splat3 = hxd.Res.terrain.Ground_04.toTexture();
		splat3.wrap = Repeat;
		var splat4 = hxd.Res.terrain.Dirt_05.toTexture();
		splat4.wrap = Repeat;

		bm.width = width * Game.TILE_SIZE;
		bm.height = height * Game.TILE_SIZE;

		var shader = new TerrainShader(splat0, splat1, splat2, splat3, splat4, width / textureScale);
		bm.addShader(shader);
		addChild(bm);
	}

	public function splat(pos:Coordinate, worldWidth:Int, worldHeight:Int)
	{
		var splat = hxd.Res.terrain.Splat_01.toTile();
		var splatBm = new Bitmap(splat, bm);
		splatBm.width = worldWidth * Game.TILE_SIZE;
		splatBm.height = worldHeight * Game.TILE_SIZE;
		var offset = new IntPoint((splatBm.width / 2).round(), (splatBm.height / 2).round());
		var targetPos = pos.toPx().toIntPoint().sub(offset);
		splatBm.x = targetPos.x;
		splatBm.y = targetPos.y;

		var grnd = hxd.Res.terrain.Ground_04.toTexture();
		grnd.wrap = Repeat;
		splatBm.addShader(new SplatShader(grnd, worldWidth / textureScale));
	}
}
