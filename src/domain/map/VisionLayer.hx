package domain.map;

import common.struct.Set;

class VisionLayer extends MapLayer<Set<String>>
{
	public function init()
	{
		grid.fillFn(i -> new Set());
	}
}
