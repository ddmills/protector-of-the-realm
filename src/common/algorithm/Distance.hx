package common.algorithm;

import common.struct.FloatPoint;
import common.struct.IntPoint;

enum DistanceFormula
{
	MANHATTAN;
	DIAGONAL;
	EUCLIDEAN;
	EUCLIDEAN_SQ;
	CHEBYSHEV;
}

class Distance
{
	public overload extern inline static function Get(a:IntPoint, b:IntPoint, formula:DistanceFormula):Float
	{
		return switch formula
		{
			case MANHATTAN: Manhattan(a, b);
			case DIAGONAL: Diagonal(a, b);
			case EUCLIDEAN: Euclidean(a, b);
			case EUCLIDEAN_SQ: EuclideanSq(a, b);
			case CHEBYSHEV: Chebyshev(a, b);
		}
	}

	public overload extern inline static function Get(a:FloatPoint, b:FloatPoint, formula:DistanceFormula):Float
	{
		return switch formula
		{
			case MANHATTAN: Manhattan(a, b);
			case DIAGONAL: Diagonal(a, b);
			case EUCLIDEAN: Euclidean(a, b);
			case EUCLIDEAN_SQ: EuclideanSq(a, b);
			case CHEBYSHEV: Chebyshev(a, b);
		}
	}

	public overload extern inline static function Chebyshev(a:IntPoint, b:IntPoint):Int
	{
		return Math.max((a.x - b.x).abs(), (a.y - b.y).abs()).floor();
	}

	public overload extern inline static function Chebyshev(a:FloatPoint, b:FloatPoint):Float
	{
		return Math.max((a.x - b.x).abs(), (a.y - b.y).abs());
	}

	public overload extern inline static function Manhattan(a:IntPoint, b:IntPoint):Int
	{
		return (a.x - b.x).abs() + (a.y - b.y).abs();
	}

	public overload extern inline static function Manhattan(a:FloatPoint, b:FloatPoint):Float
	{
		return (a.x - b.x).abs() + (a.y - b.y).abs();
	}

	public overload extern inline static function Diagonal(a:IntPoint, b:IntPoint):Float
	{
		var dx = (a.x - b.x).abs();
		var dy = (a.y - b.y).abs();

		return (dx + dy) - (0.59 * Math.min(dx, dy));
	}

	public overload extern inline static function Diagonal(a:FloatPoint, b:FloatPoint):Float
	{
		var dx = (a.x - b.x).abs();
		var dy = (a.y - b.y).abs();

		return (dx + dy) - (0.59 * Math.min(dx, dy));
	}

	public overload extern inline static function EuclideanSq(a:IntPoint, b:IntPoint):Int
	{
		var dx = a.x - b.x;
		var dy = a.y - b.y;

		return dx * dx + dy * dy;
	}

	public overload extern inline static function EuclideanSq(a:FloatPoint, b:FloatPoint):Float
	{
		var dx = a.x - b.x;
		var dy = a.y - b.y;

		return dx * dx + dy * dy;
	}

	public overload extern inline static function Euclidean(a:IntPoint, b:IntPoint):Float
	{
		return Math.sqrt(EuclideanSq(a, b));
	}

	public overload extern inline static function Euclidean(a:FloatPoint, b:FloatPoint):Float
	{
		return Math.sqrt(EuclideanSq(a, b));
	}
}
