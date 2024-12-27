package screens.build;

import common.struct.Coordinate;
import core.Frame;
import core.Game;
import core.Screen;
import core.input.Command;
import data.input.groups.CameraInputGroup;
import domain.Spawner;
import domain.components.Building;
import domain.components.Collider;
import domain.components.Sprite;
import ecs.Entity;
import h2d.Graphics;

class BuildScreen extends Screen
{
	var e:Entity;
	var isValid:Bool;
	var isPlaced:Bool;
	var c:Collider;
	var g:Graphics;

	public function new()
	{
		inputDomain = INPUT_DOMAIN_PLAY;
		isPlaced = false;
		var pos = game.input.mouse.toWorld().floor().add(new Coordinate(.5, .5));
		e = Spawner.Spawn(GUILD_HALL, pos);
		c = e.get(Collider);
		e.remove(Collider);
	}

	override function onEnter()
	{
		g = new Graphics();
		game.render(GROUND, g);
	}

	override function onDestroy()
	{
		g.remove();

		if (!isPlaced)
		{
			e.destroy();
		}
	}

	override function update(frame:Frame)
	{
		world.updateSystems();

		var building = e.get(Building).building;

		var pos = e.pos.toPx();

		var extendedArea = world.systems.colliders.footprintHasCollisions(building.getFootprint(e, true), [FLG_BUILDING, FLG_OBJECT]);
		var immediateArea = world.systems.colliders.footprintHasCollisions(building.getFootprint(e, false), [FLG_BUILDING, FLG_OBJECT, FLG_UNIT]);
		isValid = !extendedArea && !immediateArea;

		var sprite = e.get(Sprite);
		sprite.bm.alpha = .5;
		g.clear();

		if (isValid)
		{
			sprite.bm.color = 0xffffff.toHxdColor(1);
			g.bevel = 1;
			g.lineStyle(4, 0xffffff, .25);
		}
		else
		{
			sprite.bm.color = 0xff0000.toHxdColor(1);
			g.lineStyle(4, 0xff0000, .25);
		}

		var rectWidth = (building.width + (building.placementPadding * 2)) * Game.TILE_SIZE;
		var rectHeight = (building.height + (building.placementPadding * 2)) * Game.TILE_SIZE;
		g.drawRect(pos.x - (rectWidth / 2).floor(), pos.y - (rectHeight / 2).floor(), rectWidth, rectHeight);

		while (game.commands.hasNext())
		{
			handle(game.commands.next());
		}
	}

	override function onMouseDown(pos:Coordinate)
	{
		if (game.input.rmb)
		{
			game.screens.pop();
			return;
		}

		if (game.input.lmb && isValid)
		{
			var building = e.get(Building).building;
			e.get(Sprite).bm.alpha = 1;
			e.add(c);
			world.terrain.splat(e.pos, building.width, building.height);
			isPlaced = true;
			game.screens.pop();
		}
	}

	override function onMouseMove(pos:Coordinate, previous:Coordinate)
	{
		CameraInputGroup.onMouseMove(pos, previous);

		e.pos = pos.toWorld().floor().add(new Coordinate(.5, .5));
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
			case CMD_CANCEL:
				game.screens.pop();
			case _:
				CameraInputGroup.handle(command);
		}
	}
}
