package screens.play;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import core.input.Command;
import core.input.KeyCode;
import domain.Spawner;
import screens.build.BuildScreen;
import screens.play.components.InspectBuildingView;
import screens.save.SaveScreen;

class PlayScreen extends Screen
{
	public function new() {}

	public override function onEnter()
	{
		inputDomain = INPUT_DOMAIN_PLAY;
	}

	public override function update(frame:Frame)
	{
		world.updateSystems();

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
			var view = new InspectBuildingView("hello world?");
			game.render(HUD, view);
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
			world.systems.debugInfo.toggleGridVisibility();
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
}
