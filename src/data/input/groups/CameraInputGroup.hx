package data.input.groups;

import common.struct.Coordinate;
import core.Frame;
import core.Game;
import core.input.Command;
import ecs.Entity;

class CameraInputGroup
{
	var follow:Null<Entity>;

	public function new()
	{
		follow = null;
	}

	public function onMouseMove(pos:Coordinate, previous:Coordinate)
	{
		var game = Game.instance;

		if (game.input.mmb)
		{
			var diff = previous
				.sub(pos)
				.toFloatPoint()
				.multiply(1);

			game.camera.scroller.x -= diff.x;
			game.camera.scroller.y -= diff.y;

			follow = null;
		}
	}

	public function onMouseWheelDown(wheelDelta:Float)
	{
		var game = Game.instance;
		var z = (game.camera.zoom + .1).clamp(.1, 4);
		game.camera.zoomTo(game.input.mouse, z);
	}

	public function onMouseWheelUp(wheelDelta:Float)
	{
		var game = Game.instance;
		var z = (game.camera.zoom - .1).clamp(.1, 4);
		game.camera.zoomTo(game.input.mouse, z);
	}

	public function followEntity(entity:Entity)
	{
		follow = entity;
	}

	public function update()
	{
		if (follow != null)
		{
			if (follow.isDestroyed)
			{
				follow = null;
			}
			else
			{
				Game.instance.camera.focus = follow.pos;
			}
		}
	}

	public function handle(command:Command)
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
