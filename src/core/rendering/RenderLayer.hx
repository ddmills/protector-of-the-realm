package core.rendering;

enum RenderLayerSpace
{
	SCREEN;
	WORLD;
}

class RenderLayer
{
	public var space(default, null):RenderLayerSpace;
	public var visible(get, set):Bool;
	public var ob(default, null):SortableLayer;

	public function new(space:RenderLayerSpace)
	{
		this.space = space;
		ob = new SortableLayer();

		visible = true;
	}

	inline function set_visible(value:Bool):Bool
	{
		return ob.visible = value;
	}

	inline function get_visible():Bool
	{
		return ob.visible;
	}
}
