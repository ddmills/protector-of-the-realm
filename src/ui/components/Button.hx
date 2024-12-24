package ui.components;

import data.resources.FontResources;
import h2d.Bitmap;
import h2d.Interactive;
import h2d.Text;

class Button extends h2d.Object
{
	public var width(default, set):Int;
	public var height(default, set):Int;
	public var text(default, set):String;
	public var backgroundColor(default, set):Int;
	public var textColor(default, set):Int;
	public var textOb(default, null):Text;

	var bm:h2d.Bitmap;
	var interactive:h2d.Interactive;

	public function new(?text:String, ?parent:h2d.Object)
	{
		super(parent);

		bm = new Bitmap(h2d.Tile.fromColor(0x000000, 0, 0), this);

		textOb = new h2d.Text(FontResources.BIZCAT, this);
		textOb.text = '';
		textOb.textAlign = Center;

		interactive = new Interactive(0, 0, this);
		interactive.onClick = (e) -> onClick(e);

		width = 128;
		height = 28;
		backgroundColor = 0x57723a;
		this.text = text ?? '';
	}

	function set_width(value:Int):Int
	{
		bm.width = value;
		interactive.width = value;
		textOb.x = value / 2;
		width = value;
		return value;
	}

	function set_height(value:Int):Int
	{
		bm.height = value;
		interactive.height = value;
		textOb.y = (value / 2) - 8;
		height = value;
		return value;
	}

	function set_text(value:String):String
	{
		textOb.text = value;
		text = value;
		width = textOb.textWidth.round() + 32;
		return value;
	}

	function set_backgroundColor(value:Int):Int
	{
		bm.tile = h2d.Tile.fromColor(value, width, height);
		backgroundColor = value;
		return value;
	}

	function set_textColor(value:Int):Int
	{
		textOb.color = value.toHxdColor();
		textColor = value;
		return value;
	}

	public dynamic function onClick(e:hxd.Event) {}
}
