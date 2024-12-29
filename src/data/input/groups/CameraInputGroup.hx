package data.input.groups;

import common.struct.Coordinate;
import core.Game;
import core.input.Command;

class CameraInputGroup
{
	public static function onMouseMove(pos:Coordinate, previous:Coordinate)
	{
		var game = Game.instance;

		if (game.input.mmb)
		{
			var diff = previous.sub(pos).toFloatPoint().multiply((1 / game.camera.zoom));

			game.camera.scroller.x -= diff.x * 10;
			game.camera.scroller.y -= diff.y * 10;
		}
	}

	public static function onMouseWheelDown(wheelDelta:Float)
	{
		var game = Game.instance;
		game.camera.zoomTo(game.input.mouse, game.camera.zoom + .1);
	}

	public static function onMouseWheelUp(wheelDelta:Float)
	{
		var game = Game.instance;
		game.camera.zoomTo(game.input.mouse, game.camera.zoom - .1);
	}

	public static function handle(command:Command)
	{
		var game = Game.instance;

		switch (command.type)
		{
			case CMD_PAUSE:
				game.clock.isPaused = !game.clock.isPaused;
			case CMD_SPEED_1:
				game.clock.speed = .5;
				game.clock.isPaused = false;
			case CMD_SPEED_2:
				game.clock.speed = 1;
				game.clock.isPaused = false;
			case CMD_SPEED_3:
				game.clock.speed = 2;
				game.clock.isPaused = false;
			case CMD_SPEED_4:
				game.clock.speed = 3;
				game.clock.isPaused = false;
			case _:
		}
	}
}
