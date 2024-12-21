package screens.play;

import common.struct.Coordinate;
import core.Frame;
import core.Game;
import core.Screen;
import core.input.Command;
import core.input.KeyCode;
import data.resources.TextResources;
import domain.Spawner;
import domain.components.Monster;
import ecs.Query;
import h2d.Object;
import h2d.Text;
import screens.build.BuildScreen;
import screens.save.SaveScreen;

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

class PlayScreen extends Screen
{
	var debugInfo:DebugInfo;
	var monsters:Query;

	public function new() {}

	public override function onEnter()
	{
		inputDomain = INPUT_DOMAIN_PLAY;
		renderDebugInfo();
		monsters = new Query({
			all: [Monster],
		});
	}

	override function onDestroy()
	{
		debugInfo.ob.remove();
		debugInfo = null;
	}

	public override function update(frame:Frame)
	{
		world.updateSystems();

		debugInfo.fps.text = frame.fps.floor().toString();

		var px = game.input.mouse.toPx().floor().toString();
		var w = game.input.mouse.toWorld().floor().toString();
		debugInfo.pos.text = '$w $px';
		debugInfo.monster.text = 'monsters ${monsters.count().toString()}';
		debugInfo.entities.text = 'entities ${game.registry.size.toString()}';
		debugInfo.clock.text = '${game.clock.tick.floor()} (${game.clock.speed})';

		while (game.commands.hasNext())
		{
			handle(game.commands.next());
		}
	}

	public override function onMouseMove(pos:Coordinate, previous:Coordinate)
	{
		if (game.input.mmb)
		{
			var diff = previous.sub(pos).toFloatPoint().multiply((1 / game.camera.zoom) * .1);
			game.camera.pos = game.camera.pos.add(diff.asWorld());
		}
	}

	public override function onMouseDown(pos:Coordinate)
	{
		var offset = new Coordinate(.5, .5, WORLD);

		if (game.input.lmb)
		{
			Spawner.Spawn(HERO, pos.toWorld().floor().add(offset));
		}
		if (game.input.rmb)
		{
			Spawner.Spawn(TREE_PINE, pos.toWorld().floor().add(offset));
		}
	}

	public override function onMouseWheelDown(wheelDelta:Float)
	{
		game.camera.zoomTo(game.input.mouse, game.camera.zoom * 1.20);
	}

	public override function onMouseWheelUp(wheelDelta:Float)
	{
		game.camera.zoomTo(game.input.mouse, game.camera.zoom * .8);
	}

	function handle(command:Command)
	{
		switch (command.type)
		{
			case CMD_SAVE:
				game.screens.push(new SaveScreen(true));
			case CMD_PAUSE:
				game.clock.isPaused = !game.clock.isPaused;
			case CMD_SPEED_1:
				game.clock.speed = .5;
			case CMD_SPEED_2:
				game.clock.speed = 1;
			case CMD_SPEED_3:
				game.clock.speed = 2;
			case CMD_SPEED_4:
				game.clock.speed = 3;
			case _:
		}
	}

	public override function onKeyDown(key:KeyCode)
	{
		if (key == KEY_D)
		{
			world.systems.sprites.debug = !world.systems.sprites.debug;
		}
		if (key == KEY_G)
		{
			debugInfo.grid.visible = !debugInfo.grid.visible;
		}
		if (key == KEY_C)
		{
			world.systems.colliders.debug = !world.systems.colliders.debug;
		}
		if (key == KEY_P)
		{
			world.systems.pathing.debug = !world.systems.pathing.debug;
		}
		if (key == KEY_B)
		{
			game.screens.push(new BuildScreen());
		}
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
