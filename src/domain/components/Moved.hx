package domain.components;

import common.struct.Coordinate;
import ecs.Component;

/**
 * Added when an entity moves across world tiles and removed on the next frame
 */
class Moved extends Component
{
	public var current:Coordinate;
	public var previous:Coordinate;

	public function new(current:Coordinate, previous:Coordinate)
	{
		this.current = current;
		this.previous = previous;
	}
}
