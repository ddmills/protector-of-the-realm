package screens.play;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import core.input.Command;
import core.input.KeyCode;
import data.input.groups.CameraInputGroup;
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
		CameraInputGroup.onMouseMove(pos, previous);
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
		CameraInputGroup.onMouseWheelDown(wheelDelta);
	}

	public override function onMouseWheelUp(wheelDelta:Float)
	{
		CameraInputGroup.onMouseWheelUp(wheelDelta);
	}

	function handle(command:Command)
	{
		switch (command.type)
		{
			case CMD_SAVE:
				game.screens.push(new SaveScreen(true));
			case _:
				CameraInputGroup.handle(command);
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
