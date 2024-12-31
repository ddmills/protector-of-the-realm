package core;

import common.struct.Coordinate;
import common.util.Projection;
import h2d.Object;

typedef SaveCamera =
{
	x:Float,
	y:Float,
	zoom:Float,
}

class Camera
{
	public var width(get, null):Float;
	public var height(get, null):Float;
	public var zoom(get, set):Float;
	public var pos(get, set):Coordinate;
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var focus(get, set):Coordinate;
	public var scroller(get, null):h2d.Object;

	public function new()
	{
		zoom = 1;
	}

	inline function get_width():Float
	{
		return hxd.Window.getInstance().width;
	}

	inline function get_height():Float
	{
		return hxd.Window.getInstance().height;
	}

	public function save():SaveCamera
	{
		return {
			zoom: zoom,
			x: x,
			y: y,
		}
	}

	public function load(save:SaveCamera)
	{
		zoom = save.zoom;
		x = save.x;
		y = save.y;
	}

	function get_scroller():Object
	{
		return Game.instance.layers.scroller;
	}

	function get_x():Float
	{
		var c = Projection.pxToWorld(-scroller.x / zoom, -scroller.y / zoom);

		return c.x;
	}

	function get_y():Float
	{
		var c = Projection.pxToWorld(-scroller.x / zoom, -scroller.y / zoom);

		return c.y;
	}

	function set_x(value:Float):Float
	{
		var p = Projection.worldToPx(value, y);

		scroller.x = -(p.x * zoom).floor();
		scroller.y = -(p.y * zoom).floor();

		return value;
	}

	function set_y(value:Float):Float
	{
		var p = Projection.worldToPx(x, value);

		scroller.x = -(p.x * zoom).floor();
		scroller.y = -(p.y * zoom).floor();

		return value;
	}

	function get_pos():Coordinate
	{
		return new Coordinate(x, y, WORLD);
	}

	function set_pos(value:Coordinate):Coordinate
	{
		var w = value.toWorld();
		x = w.x;
		y = w.y;
		return w;
	}

	function get_zoom():Float
	{
		return scroller.scaleX;
	}

	function set_zoom(value:Float):Float
	{
		scroller.setScale(value);

		return value;
	}

	public function zoomTo(tpos:Coordinate, value:Float):Float
	{
		var ratio = 1 - (value / zoom);
		var screenPos = tpos.toScreen();

		scroller.x += (screenPos.x - scroller.x) * ratio;
		scroller.y += (screenPos.y - scroller.y) * ratio;

		scroller.setScale(value);

		return value;
	}

	function set_focus(value:Coordinate):Coordinate
	{
		var mid = new Coordinate(width / 2, height / 2, SCREEN);

		pos = value.sub(mid).add(pos);

		return pos;
	}

	function get_focus():Coordinate
	{
		return new Coordinate(width / 2, height / 2, SCREEN);
	}
}
