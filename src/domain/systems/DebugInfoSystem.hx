package domain.systems;

import core.Frame;
import core.Game;
import data.resources.FontResources;
import domain.components.Label;
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
	cursor:Text,
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
		var w = game.input.mouse.toWorld().toIntPoint();
		var px = game.input.mouse.toPx().floor().toString();
		var wtext = w.toString();
		var fps = frame.fps.floor();

		var entities = world.map.getEntitiesAt(w.x, w.y);
		var eString = entities
			.map(x -> x.get(Label)?.text ?? 'Unknown')
			.join(', ');

		debugInfo.fps.text = fps.toString();
		debugInfo.fps.color = getFpsColor(fps).toHxdColor();
		debugInfo.pos.text = '$wtext $px';
		debugInfo.monster.text = 'monsters ${monsters.count().toString()}';
		debugInfo.entities.text = 'entities ${game.registry.size.toString()}';
		debugInfo.cursor.text = eString;
		debugInfo.clock.text = '${game.clock.tick.floor()} (${game.clock.speed})';
	}

	override function teardown()
	{
		debugInfo.ob.remove();
		debugInfo.grid.remove();
	}

	function getFpsColor(fps:Int):Int
	{
		if (fps < 60)
		{
			return 0xbe7474;
		}

		if (fps < 100)
		{
			return 0xe0de62;
		}

		return 0x92e08b;
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

		var fps = new Text(FontResources.BIZCAT, ob);
		fps.color = game.TEXT_COLOR_FOCUS.toHxdColor();
		fps.y = 0;

		var pos = new Text(FontResources.BIZCAT, ob);
		pos.color = game.TEXT_COLOR.toHxdColor();
		pos.y = 16;

		var monster = new Text(FontResources.BIZCAT, ob);
		monster.color = game.TEXT_COLOR.toHxdColor();
		monster.y = 32;

		var entities = new Text(FontResources.BIZCAT, ob);
		entities.color = game.TEXT_COLOR.toHxdColor();
		entities.y = 48;

		var clock = new Text(FontResources.BIZCAT, ob);
		clock.color = game.TEXT_COLOR.toHxdColor();
		clock.y = 64;

		var cursor = new Text(FontResources.BIZCAT, ob);
		cursor.color = game.TEXT_COLOR.toHxdColor();
		cursor.y = 80;

		var grid = new h2d.Graphics();
		grid.visible = false;
		grid.beginFill(0x00FF00, 0);

		for (x in 0...world.map.width)
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
			grid.lineTo(x * Game.TILE_SIZE, world.map.height * Game.TILE_SIZE);
		}

		for (y in 0...world.map.height)
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
			grid.lineTo(world.map.width * Game.TILE_SIZE, y * Game.TILE_SIZE);
		}

		debugInfo = {
			ob: ob,
			fps: fps,
			pos: pos,
			clock: clock,
			monster: monster,
			entities: entities,
			cursor: cursor,
			grid: grid,
		};

		game.render(OBJECTS, grid);
		game.render(HUD, ob);
	}
}
