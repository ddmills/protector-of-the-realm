package domain.systems;

import common.struct.Coordinate;
import common.struct.Set;
import core.Frame;
import data.resources.FontResources;
import domain.components.Actor;
import domain.components.Label;
import ecs.Query;
import ecs.System;
import h2d.Object;
import h2d.Text;
import haxe.EnumTools;

typedef DebugInfo =
{
	ob:Object,
	fps:Text,
	pos:Text,
	clock:Text,
	entities:Text,
	actors:Text,
	cursor:Text,
	drawCalls:Text,
	grid:h2d.Graphics,
}

class DebugInfoSystem extends System
{
	public var debugInfo:DebugInfo;

	var actors:Query;

	public function new()
	{
		actors = new Query({
			all: [Actor],
		});

		renderDebugInfo();
	}

	override function update(frame:Frame)
	{
		var w = game.input.mouse.toWorld().toIntPoint();
		var px = game.input.mouse.toPx().floor().toString();
		var wtext = w.toString();
		var fps = frame.fps.floor();
		var terrain = world.terrain.terrain.get(w.x, w.y);
		var terrainString = terrain != null ? EnumValueTools.getName(terrain) : "OOB";

		var entities = world.map.getEntitiesAt(w.x, w.y);
		var eString = entities
			.map(x -> x.get(Label)?.text ?? 'Unknown')
			.join(', ');

		var pentities = world.map.hostility.getWithinRange(PLAYER, w.x, w.y, 12);
		var pString = pentities
			.map(x ->
			{
				var e = game.registry.getEntity(x.entityId);
				var lbl = e.get(Label)?.text ?? 'Unknown';

				return '$lbl (${x.distance})';
			})
			.join(', ');

		debugInfo.fps.text = game.app.engine.fps.floor().toString() + ' ' + frame.fps.floor().toString();
		debugInfo.fps.color = getFpsColor(fps).toHxdColor();
		debugInfo.pos.text = '$wtext $px Z(${game.camera.zoom})';
		debugInfo.actors.text = 'actors ${actors.count().toString()}';
		debugInfo.entities.text = 'entities ${game.registry.size.toString()}';
		debugInfo.cursor.text = '${terrainString} ${eString} --- ${pString}';
		debugInfo.clock.text = '${game.clock.tick.floor()} (${game.clock.speed})';
		debugInfo.drawCalls.text = 'draw ${game.app.engine.drawCalls}';
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

		var actors = new Text(FontResources.BIZCAT, ob);
		actors.color = game.TEXT_COLOR.toHxdColor();
		actors.y = 32;

		var entities = new Text(FontResources.BIZCAT, ob);
		entities.color = game.TEXT_COLOR.toHxdColor();
		entities.y = 48;

		var clock = new Text(FontResources.BIZCAT, ob);
		clock.color = game.TEXT_COLOR.toHxdColor();
		clock.y = 64;

		var drawCalls = new Text(FontResources.BIZCAT, ob);
		drawCalls.color = game.TEXT_COLOR.toHxdColor();
		drawCalls.y = 80;

		var cursor = new Text(FontResources.BIZCAT, ob);
		cursor.color = game.TEXT_COLOR.toHxdColor();
		cursor.y = 96;

		var grid = new h2d.Graphics();
		grid.visible = false;
		grid.beginFill(0x00FF00, 0);

		for (x in 0...world.map.width)
		{
			if (x % 8 == 0)
			{
				grid.lineStyle(2, 0x4373D1, .6);
			}
			else if (x % 4 == 0)
			{
				grid.lineStyle(2, 0xFFFFFF, .3);
			}
			else
			{
				grid.lineStyle(1, 0xFFFFFF, .1);
			}

			var start = new Coordinate(x, 0, WORLD);
			var end = new Coordinate(x, world.map.height, WORLD);

			var startPx = start.toPx();
			var endPx = end.toPx();

			grid.moveTo(startPx.x, startPx.y);
			grid.lineTo(endPx.x, endPx.y);
		}

		for (y in 0...world.map.height)
		{
			if (y % 8 == 0)
			{
				grid.lineStyle(2, 0x4373D1, .6);
			}
			else if (y % 4 == 0)
			{
				grid.lineStyle(2, 0xFFFFFF, .3);
			}
			else
			{
				grid.lineStyle(1, 0xFFFFFF, .1);
			}

			var start = new Coordinate(0, y, WORLD);
			var end = new Coordinate(world.map.width, y, WORLD);

			var startPx = start.toPx();
			var endPx = end.toPx();

			grid.moveTo(startPx.x, startPx.y);
			grid.lineTo(endPx.x, endPx.y);
		}

		debugInfo = {
			ob: ob,
			fps: fps,
			pos: pos,
			clock: clock,
			actors: actors,
			entities: entities,
			cursor: cursor,
			grid: grid,
			drawCalls: drawCalls,
		};

		game.render(OVERLAY, grid);
		game.render(HUD, ob);
	}
}
