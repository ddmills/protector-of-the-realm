package screens.inspect;

import common.struct.Coordinate;
import core.Data;
import core.Frame;
import core.Screen;
import core.input.Command;
import data.resources.FontResources;
import domain.components.ActionQueue;
import domain.components.Behavior;
import domain.components.Health;
import domain.components.Inspectable;
import domain.events.QueryActionsEvent;
import ecs.Entity;
import h2d.Bitmap;
import h2d.Object;
import h2d.Text;
import h2d.Tile;
import ui.components.Button;

typedef ActionBtn =
{
	actionType:EntityActionType,
	btnOb:Button,
}

typedef HealthBar =
{
	ob:Bitmap,
	bar:Bitmap,
	text:h2d.Text,
}

typedef BehaviorBar =
{
	ob:Bitmap,
	behavior:Text,
	task:Text,
}

typedef InspectScreenUi =
{
	rootOb:h2d.Object,
	titleOb:h2d.Object,
	actionsOb:h2d.Object,
	titleText:Text,
	residentsOb:h2d.Object,
	health:HealthBar,
	behavior:BehaviorBar,
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

		renderBehavior();
		renderHealth();
		renderActions();

		world.input.camera.update();

		if (inspectableEntity.isDestroyed)
		{
			game.screens.pop();
			return;
		}

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
		rootOb.tile = h2d.Tile.fromColor(0x1D1D1F, 1, 1);
		rootOb.width = width;
		rootOb.height = width;

		var blocker = new h2d.Interactive(width, width, rootOb);
		blocker.cursor = null;

		var titleOb = new Bitmap(Tile.fromColor(0x2A3B44), rootOb);
		titleOb.height = 20;
		titleOb.width = width;
		var actionsOb = new h2d.Object(rootOb);
		var residentsOb = new h2d.Object(rootOb);

		ui = {
			rootOb: rootOb,
			titleOb: titleOb,
			actionsOb: actionsOb,
			residentsOb: residentsOb,
			titleText: null,
			health: null,
			behavior: null,
			actions: [],
		};

		renderTitle();
		renderBehavior();
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

		ui.titleText = title;
	}

	function renderBehavior()
	{
		y = 30;

		if (ui.behavior == null)
		{
			var ob = new Bitmap(Tile.fromColor(0x202727), ui.rootOb);
			var bhvText = new h2d.Text(FontResources.BIZCAT, ob);
			var taskText = new h2d.Text(FontResources.BIZCAT, ob);

			ui.behavior = {
				ob: ob,
				behavior: bhvText,
				task: taskText,
			};

			bhvText.maxWidth = width;
			bhvText.textAlign = Center;
			taskText.maxWidth = width;
			taskText.textAlign = Center;
		}

		var bhv = inspectableEntity.get(Behavior);

		if (bhv != null)
		{
			ui.behavior.ob.visible = true;

			var lbl = bhv.getLabels();
			ui.behavior.ob.y = y;
			ui.behavior.behavior.text = lbl.behavior;
			ui.behavior.task.text = lbl.task;
			ui.behavior.task.y = ui.behavior.behavior.textHeight;
		}
		else
		{
			ui.behavior.ob.visible = false;
		}
	}

	function renderHealth()
	{
		y = 80;

		var hp = inspectableEntity.get(Health);

		if (hp == null)
		{
			return;
		}

		if (ui.health == null)
		{
			var ob = new Bitmap(Tile.fromColor(0x202727), ui.rootOb);
			var bar = new Bitmap(Tile.fromColor(0x7e3b3b), ob);
			var txt = new h2d.Text(FontResources.BIZCAT, ob);

			ui.health = {
				ob: ob,
				bar: bar,
				text: txt,
			};

			ob.y = y;
			ob.width = width;
			ob.height = 20;
			bar.width = 80;
			bar.height = 20;
			txt.maxWidth = width;
			txt.textAlign = Center;
		}

		ui.health.bar.width = hp.percent * width;
		ui.health.text.text = '${hp.value.ciel()}/${hp.max}';
	}

	function renderActions()
	{
		y = 100;

		var evt = inspectableEntity.fireEvent(new QueryActionsEvent());

		ui.actions = ui.actions.filter(x ->
		{
			if (evt.actions.exists(e -> e.equals(x.actionType)))
			{
				return true;
			}

			x.btnOb.remove();
			return false;
		});

		var queue = inspectableEntity.get(ActionQueue);

		if (queue == null)
		{
			return;
		}

		for (action in evt.actions)
		{
			var o = ui.actions.find(a -> a.actionType.equals(action));

			if (o == null)
			{
				var btn = new Button('test', ui.actionsOb);
				btn.width = width;
				btn.onClick = (e) ->
				{
					var queue = inspectableEntity.get(ActionQueue);
					btn.disabled = true;
					queue.actions.push({
						actionType: action,
						current: .01,
						duration: getActionDuration(action),
					});
				};

				o = {
					actionType: action,
					btnOb: btn,
				}

				ui.actions.push(o);
			}

			o.btnOb.y = y;
			y += o.btnOb.height;

			var title = getActionTitle(action);
			var active = queue.actions.find(y -> y.actionType.equals(o.actionType));

			if (active == null)
			{
				o.btnOb.disabled = false;
				o.btnOb.backgroundColor = 0x679c67;
				o.btnOb.text = title;
			}
			else
			{
				o.btnOb.disabled = true;
				o.btnOb.backgroundColor = 0xa36666;
				o.btnOb.text = '${title} ${active.current.format(1)}/${active.duration}';
			}
		}
	}

	private function getActionDuration(actionType:EntityActionType):Float
	{
		return switch actionType
		{
			case FOLLOW: 0;
			case VISIT_HOME: 0;
			case RESIDENT(_): 0;
			case SELF_DESTRUCT: 2;
			case HIRE_ACTOR(_): 4;
		}
	}

	private function getActionTitle(actionType:EntityActionType):String
	{
		return switch actionType
		{
			case RESIDENT(entityId): 'Resident ($entityId)';
			case VISIT_HOME: 'Visit Home';
			case FOLLOW: 'Follow';
			case SELF_DESTRUCT: 'Self Destruct';
			case HIRE_ACTOR(actorType): {
					var actor = Data.Actors.get(actorType);
					return 'Hire ${actor.actorTypeName}';
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
		world.input.camera.onMouseMove(pos, previous);
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
