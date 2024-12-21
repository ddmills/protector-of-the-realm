package core.rendering;

class SortableLayer extends h2d.Layers
{
	public override function ysort(layer:Int)
	{
		if (layer >= layerCount)
			return;
		var start = layer == 0 ? 0 : layersIndexes[layer - 1];
		var max = layersIndexes[layer];
		if (start == max)
			return;
		var pos = start;
		var ymax = children[pos++].y;
		while (pos < max)
		{
			var c = children[pos];
			if (c.y < ymax)
			{
				var p = pos - 1;
				while (p >= start)
				{
					var c2 = children[p];
					if (c.y >= c2.y)
						break;
					children[p + 1] = c2;
					p--;
				}
				children[p + 1] = c;
			}
			else
				ymax = c.y;
			pos++;
		}
	}
}
