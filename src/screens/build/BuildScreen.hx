package screens.build;

import common.struct.Coordinate;
import core.Frame;
import core.Game;
import core.Screen;
import core.input.Command;
import domain.Spawner;
import domain.components.Building;
import domain.components.Collider;
import domain.components.Sprite;
import domain.systems.ColliderSystem.ColliderFlag;
import ecs.Entity;
import h2d.Graphics;

class BuildScreen extends Screen
{
	var e:Entity;
	var isValid:Bool;
	var c:Collider;
	var g:Graphics;

	public function new()
	{
		inputDomain = INPUT_DOMAIN_BUILD;
		e = Spawner.Spawn(GUILD_HALL, game.input.mouse);
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
	}

	override function update(frame:Frame)
	{
		world.updateSystems();
		while (game.commands.hasNext())
		{
			handle(game.commands.next());
		}

		var building = e.get(Building);

		var pos = e.pos.toPx();

		var flags = [FLG_BUILDING, FLG_OBJECT, FLG_UNIT];
		isValid = !world.systems.colliders.footprintHasCollisions(building.footprint, flags);

		var sprite = e.get(Sprite);
		sprite.bm.alpha = .5;
		g.clear();

		if (isValid)
		{
			sprite.bm.color = 0xffffff.toHxdColor(1);
			g.lineStyle(4, 0xffffff, .25);
		}
		else
		{
			sprite.bm.color = 0xff0000.toHxdColor(1);
			g.lineStyle(4, 0xff0000, .25);
		}

		var rectWidth = building.width * Game.TILE_SIZE;
		var rectHeight = building.height * Game.TILE_SIZE;
		g.drawRect(pos.x - (rectWidth / 2).floor(), pos.y - (rectHeight / 2).floor(), rectWidth, rectHeight);
	}

	override function onMouseDown(pos:Coordinate)
	{
		if (game.input.lmb && isValid)
		{
			var building = e.get(Building);
			e.get(Sprite).bm.alpha = 1;
			e.add(c);
			world.terrain.splat(e.pos, building.width, building.height);
			game.screens.pop();
		}
	}

	override function onMouseMove(pos:Coordinate, previous:Coordinate)
	{
		if (game.input.mmb)
		{
			var diff = previous.sub(pos).toFloatPoint().multiply(0.1);
			game.camera.pos = game.camera.pos.add(diff.asWorld());
		}
		else
		{
			e.pos = pos.toWorld().floor().add(new Coordinate(.5, .5));
		}
	}

	public function handle(command:Command) {}
}
