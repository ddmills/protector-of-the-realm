package domain.systems;

import core.Frame;
import core.Game;
import data.resources.TextResources;
import domain.components.Monster;
import ecs.Query;
import ecs.System;
import h2d.Object;
import h2d.Text;

typedef DebugInfo =
{
	ob:Object,
	fps:Text,
	pos:Text,
	clock:Text,
	monster:Text,
	entities:Text,
	grid:h2d.Graphics,
}

class DebugInfoSystem extends System
{
	public var debugInfo:DebugInfo;

	var monsters:Query;

	public function new()
	{
		monsters = new Query({
			all: [Monster],
		});

		renderDebugInfo();
	}

	override function update(frame:Frame)
	{
		var px = game.input.mouse.toPx().floor().toString();
		var w = game.input.mouse.toWorld().floor().toString();

		debugInfo.fps.text = frame.fps.floor().toString();
		debugInfo.pos.text = '$w $px';
		debugInfo.monster.text = 'monsters ${monsters.count().toString()}';
		debugInfo.entities.text = 'entities ${game.registry.size.toString()}';
		debugInfo.clock.text = '${game.clock.tick.floor()} (${game.clock.speed})';
	}

	public function toggleGridVisibility():Bool
	{
		debugInfo.grid.visible = !debugInfo.grid.visible;
		return debugInfo.grid.visible;
	}

	private function renderDebugInfo()
	{
		var ob = new Object();
		ob.x = 16;
		ob.y = 16;

		var fps = new Text(TextResources.BIZCAT, ob);
		fps.color = game.TEXT_COLOR_FOCUS.toHxdColor();
		fps.y = 0;

		var pos = new Text(TextResources.BIZCAT, ob);
		pos.color = game.TEXT_COLOR.toHxdColor();
		pos.y = 16;

		var monster = new Text(TextResources.BIZCAT, ob);
		monster.color = game.TEXT_COLOR.toHxdColor();
		monster.y = 32;

		var entities = new Text(TextResources.BIZCAT, ob);
		entities.color = game.TEXT_COLOR.toHxdColor();
		entities.y = 48;

		var clock = new Text(TextResources.BIZCAT, ob);
		clock.color = game.TEXT_COLOR.toHxdColor();
		clock.y = 64;

		var grid = new h2d.Graphics();
		grid.visible = false;
		grid.beginFill(0x00FF00, 0);

		for (x in 0...world.mapWidth)
		{
			if (x % 16 == 0)
			{
				grid.lineStyle(3, 0x4373D1, .6);
			}
			else if (x % 4 == 0)
			{
				grid.lineStyle(3, 0xFFFFFF, .3);
			}
			else
			{
				grid.lineStyle(2, 0xFFFFFF, .1);
			}

			grid.moveTo(x * Game.TILE_SIZE, 0);
			grid.lineTo(x * Game.TILE_SIZE, world.mapHeight * Game.TILE_SIZE);
		}

		for (y in 0...world.mapHeight)
		{
			if (y % 16 == 0)
			{
				grid.lineStyle(3, 0x4373D1, .6);
			}
			else if (y % 4 == 0)
			{
				grid.lineStyle(3, 0xFFFFFF, .3);
			}
			else
			{
				grid.lineStyle(2, 0xFFFFFF, .1);
			}

			grid.moveTo(0, y * Game.TILE_SIZE);
			grid.lineTo(world.mapWidth * Game.TILE_SIZE, y * Game.TILE_SIZE);
		}

		debugInfo = {
			ob: ob,
			fps: fps,
			pos: pos,
			clock: clock,
			monster: monster,
			entities: entities,
			grid: grid,
		};

		game.render(OBJECTS, grid);
		game.render(HUD, ob);
	}
}
