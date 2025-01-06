package screens.build;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import core.input.Command;
import data.input.groups.CameraInputGroup;
import domain.Spawner;
import domain.components.Building;
import domain.components.Collider;
import domain.components.IsDestroyed;
import domain.components.Sprite;
import domain.components.Team;
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
			e.add(new IsDestroyed());
		}
	}

	override function update(frame:Frame)
	{
		world.updateSystems();

		var building = e.get(Building).building;

		var pos = e.pos.toWorld();

		var footprint = building.getFootprint(e, false);
		var footprintExtended = building.getFootprint(e, true);

		var hasWater = footprintExtended.exists(p ->
		{
			var t = world.terrain.terrain.get(p.x, p.y);
			return t == WATER;
		});

		if (hasWater)
		{
			isValid = false;
		}
		else
		{
			var extendedArea = world.systems.colliders.footprintHasCollisions(footprintExtended, [FLG_BUILDING, FLG_OBJECT]);
			var immediateArea = world.systems.colliders.footprintHasCollisions(footprint, [FLG_BUILDING, FLG_OBJECT, FLG_UNIT]);

			isValid = !extendedArea && !immediateArea;
		}

		var sprite = e.get(Sprite);
		g.clear();

		if (isValid)
		{
			sprite.bm.color = 0xffffff.toHxdColor(1);
			sprite.bm.alpha = 1;
			g.lineStyle(4, 0xffffff, .25);
		}
		else
		{
			sprite.bm.color = 0xff0000.toHxdColor(1);
			sprite.bm.alpha = .25;
			g.lineStyle(4, 0xff0000, .25);
		}

		var rectWidth = (building.width + (building.placementPadding * 2));
		var rectHeight = (building.height + (building.placementPadding * 2));

		var x = pos.x - (rectWidth / 2).floor();
		var y = pos.y - (rectHeight / 2).floor();
		g.drawIsometricTile(x - .5, y - .5, rectWidth, rectHeight);
		world.input.camera.update();

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
			e.get(Sprite).bm.alpha = 1;
			e.add(c);
			e.add(new Team(PLAYER));
			isPlaced = true;
			game.screens.pop();
		}
	}

	override function onMouseMove(pos:Coordinate, previous:Coordinate)
	{
		world.input.camera.onMouseMove(pos, previous);

		e.pos = pos.toWorld().floor().add(new Coordinate(.5, .5));
	}

	public override function onMouseWheelDown(wheelDelta:Float)
	{
		world.input.camera.onMouseWheelDown(wheelDelta);
	}

	public override function onMouseWheelUp(wheelDelta:Float)
	{
		world.input.camera.onMouseWheelUp(wheelDelta);
	}

	function handle(command:Command)
	{
		switch (command.type)
		{
			case CMD_CANCEL:
				game.screens.pop();
			case _:
				world.input.camera.handle(command);
		}
	}
}
