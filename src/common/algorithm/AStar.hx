package common.algorithm;

import common.algorithm.Distance.DistanceFormula;
import common.struct.IntPoint;
import common.struct.PriorityQueue;

typedef AStarSettings =
{
	start:IntPoint,
	goals:Array<IntPoint>,
	allowDiagonals:Bool,
	?includeGoal:Bool,
	cost:(current:IntPoint, next:IntPoint) -> Float,
	?maxDepth:Null<Int>,
};

typedef AStarResult =
{
	var success:Bool;
	var path:Array<IntPoint>;
	var costs:Array<Float>;
	var cost:Float;
	var start:IntPoint;
	var goal:Null<IntPoint>;
};

class AStar
{
	public static function GetPath(settings:AStarSettings)
	{
		var heuristic:DistanceFormula = settings.allowDiagonals ? DIAGONAL : MANHATTAN;
		var start = settings.start;
		var goals = settings.goals;
		var cost = settings.cost;
		var maxDepth = settings.maxDepth.or(10000);
		var includeGoal = settings.includeGoal ?? true;
		var depth = 0;

		var open = new PriorityQueue<{key:String, pos:IntPoint}>();
		var from = new Map<String, IntPoint>();
		var costs = new Map<String, Float>();
		var startKey = Key(start);
		var goalKeys = goals.map(g -> Key(g));
		var result:AStarResult = {
			success: false,
			path: new Array(),
			costs: new Array(),
			cost: Math.POSITIVE_INFINITY,
			start: start,
			goal: null,
		};

		// if (cost(start, goal) == Math.POSITIVE_INFINITY)
		// {
		// 	return result;
		// }

		open.put({
			key: startKey,
			pos: start,
		}, 0);

		costs[startKey] = 0;

		var resultGoalKey = '';

		while (!open.isEmpty)
		{
			depth++;
			if (depth >= maxDepth)
			{
				trace('max depth reached');
				break;
			}
			var d = open.pop();
			var current = d.pos;
			var currentKey = d.key;

			if (goalKeys.contains(currentKey))
			{
				result.success = true;
				result.goal = current;
				resultGoalKey = currentKey;
				break;
			}

			var neighbors = Neighbors(current, settings.allowDiagonals);

			for (next in neighbors)
			{
				var nextKey = Key(next);

				var graphCost = (!includeGoal && goalKeys.contains(nextKey)) ? 0 : cost(current, next);

				if (graphCost == Math.POSITIVE_INFINITY)
				{
					continue;
				}

				var newCost = costs[currentKey] + graphCost;

				if (!costs.exists(nextKey) || newCost < costs[nextKey])
				{
					costs[nextKey] = newCost;

					var minDist = goals.minValue(g -> Distance.Get(next, g, heuristic));
					var priority = newCost + minDist;

					open.put({
						key: nextKey,
						pos: next,
					}, priority);

					from[nextKey] = current;
				}
			}
		}

		if (!result.success)
		{
			return result;
		}

		result.path = [result.goal];
		result.cost = costs[resultGoalKey];
		result.costs = [costs[resultGoalKey]];

		var previous = from[resultGoalKey];

		while (previous != null)
		{
			var previousKey = Key(previous);

			result.path.unshift(previous);
			result.costs.unshift(costs[previousKey]);

			previous = from[previousKey];
		}

		return result;
	}

	inline static function Key(point:IntPoint)
	{
		return '${point.x},${point.y}';
	}

	inline static function Neighbors(point:IntPoint, allowDiagonals:Bool)
	{
		var x = point.x;
		var y = point.y;

		var neighbors:Array<IntPoint> = [{x: x, y: y - 1}, {x: x, y: y + 1}, {x: x - 1, y: y}, {x: x + 1, y: y}];

		if (allowDiagonals)
		{
			neighbors.push({
				x: x - 1,
				y: y - 1,
			});
			neighbors.push({
				x: x + 1,
				y: y - 1,
			});
			neighbors.push({
				x: x - 1,
				y: y + 1,
			});
			neighbors.push({
				x: x + 1,
				y: y + 1,
			});
		}
		return neighbors;
	}
}
