package screens.inspect;

import common.struct.Coordinate;
import core.Frame;
import core.Screen;
import core.input.Command;
import data.input.groups.CameraInputGroup;
import data.resources.FontResources;
import domain.components.Inspectable;
import domain.events.QueryActionsEvent;
import ecs.Entity;
import h2d.Bitmap;
import ui.components.Button;

typedef InspectScreenUi =
{
	rootOb:h2d.Object,
	titleOb:h2d.Object,
	actionsOb:h2d.Object,
}

class InspectScreen extends Screen
{
	var ui:InspectScreenUi;
	var inspectableEntity:Entity;
	var inspectable:Inspectable;
	var width = 240;
	var y = 0;

	public function new(inspectableEntity:Entity)
	{
		inputDomain = INPUT_DOMAIN_PLAY;
		this.inspectableEntity = inspectableEntity;
		this.inspectable = inspectableEntity.get(Inspectable);
	}

	override function update(frame:Frame)
	{
		world.updateSystems();

		while (game.commands.hasNext())
		{
			handle(game.commands.next());
		}

		if (world.inspection.selected != inspectableEntity && world.inspection.isInspecting)
		{
			game.screens.replace(new InspectScreen(world.inspection.selected));
		}
	}

	override function onEnter()
	{
		reRenderUi();
	}

	function reRenderUi()
	{
		y = 0;

		if (ui?.rootOb != null)
		{
			ui.rootOb.remove();
		}

		var rootOb = new Bitmap();
		rootOb.tile = h2d.Tile.fromColor(0x242529, 1, 1);
		rootOb.width = width;
		rootOb.height = width;

		var blocker = new h2d.Interactive(width, width, rootOb);
		blocker.cursor = null;

		var titleOb = new h2d.Object(rootOb);
		var actionsOb = new h2d.Object(rootOb);

		ui = {
			rootOb: rootOb,
			titleOb: titleOb,
			actionsOb: actionsOb,
		};

		renderTitle();
		renderActions();

		game.render(HUD, ui.rootOb);
	}

	override function onDestroy()
	{
		world.inspection.clear();
		ui.rootOb.remove();
	}

	function renderTitle()
	{
		ui.titleOb.removeChildren();

		var title = new h2d.Text(FontResources.BIZCAT, ui.titleOb);
		title.y = y;
		title.text = inspectable.displayName;
		title.textAlign = Center;
		title.maxWidth = width;

		y = title.textHeight.ciel();
	}

	function renderActions()
	{
		ui.actionsOb.removeChildren();

		var evt = inspectableEntity.fireEvent(new QueryActionsEvent());

		for (action in evt.actions)
		{
			var btn = new Button(action.name, ui.actionsOb);
			btn.width = width;
			btn.y = y;
			btn.onClick = (e) ->
			{
				inspectableEntity.fireEvent(action.evt);
				reRenderUi();
			};
			y += btn.height;
		}
	}

	public override function onMouseDown(pos:Coordinate)
	{
		if (game.input.rmb)
		{
			game.screens.pop();
		}
	}

	public override function onMouseMove(pos:Coordinate, previous:Coordinate)
	{
		CameraInputGroup.onMouseMove(pos, previous);
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
