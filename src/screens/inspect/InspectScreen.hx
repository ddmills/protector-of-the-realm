package screens.inspect;

import common.struct.Coordinate;
import core.Data;
import core.Frame;
import core.Screen;
import core.input.Command;
import data.input.groups.CameraInputGroup;
import data.resources.FontResources;
import domain.components.ActionQueue;
import domain.components.Inspectable;
import domain.events.QueryActionsEvent;
import ecs.Entity;
import h2d.Bitmap;
import ui.components.Button;

typedef ActionBtn =
{
	actionType:EntityActionType,
	btnOb:Button,
}

typedef InspectScreenUi =
{
	rootOb:h2d.Object,
	titleOb:h2d.Object,
	actionsOb:h2d.Object,
	actions:Array<ActionBtn>,
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

		updateActionProgress();

		if (world.inspection.selected != inspectableEntity && world.inspection.isInspecting)
		{
			game.screens.replace(new InspectScreen(world.inspection.selected));
		}
	}

	override function onEnter()
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
			actions: [],
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
		y = 40;

		ui.actionsOb.removeChildren();
		ui.actions = [];

		var evt = inspectableEntity.fireEvent(new QueryActionsEvent());

		for (action in evt.actions)
		{
			var btn = new Button('test', ui.actionsOb);
			btn.width = width;
			btn.y = y;
			btn.onClick = (e) ->
			{
				var queue = inspectableEntity.get(ActionQueue);
				btn.disabled = true;
				queue.actions.push({
					actionType: action,
					current: .01,
					duration: 4,
				});
			};

			y += btn.height;

			ui.actions.push({
				actionType: action,
				btnOb: btn,
			});
		}
	}

	private function getActionTitle(actionType:EntityActionType):String
	{
		return switch actionType
		{
			case SELF_DESTRUCT: 'Self Destruct';
			case HIRE_ACTOR(actorType): {
					var actor = Data.Actors.get(actorType);
					return 'Hire ${actor.actorTypeName}';
				}
		}
	}

	function updateActionProgress()
	{
		var queue = inspectableEntity.get(ActionQueue);

		if (queue == null)
		{
			return;
		}

		for (x in ui.actions)
		{
			var cur = queue.actions.find(y -> y.actionType.equals(x.actionType));

			if (cur != null)
			{
				x.btnOb.disabled = true;
				x.btnOb.backgroundColor = 0xa36666;
				var t = getActionTitle(x.actionType);
				x.btnOb.text = '${t} ${cur.current.format(1)}/${cur.duration}';
			}
			else
			{
				x.btnOb.disabled = false;
				x.btnOb.backgroundColor = 0x679c67;
				x.btnOb.text = getActionTitle(x.actionType);
			}
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
