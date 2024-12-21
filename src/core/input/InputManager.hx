package core.input;

import common.struct.Coordinate;
import common.struct.Queue;

class InputManager
{
	public var queue:Queue<KeyEvent>;
	public var mouse:Coordinate;
	public var modShift:Bool = false;
	public var modCtrl:Bool = false;
	public var modAlt:Bool = false;
	public var lmb:Bool = false;
	public var rmb:Bool = false;
	public var mmb:Bool = false;

	public function new()
	{
		queue = new Queue();
		queue.maxLength = 4;
		mouse = new Coordinate(0, 0, SCREEN);
		Game.instance.window.addEventTarget(onSceneEvent);
	}

	public inline function next():Null<KeyEvent>
	{
		return queue.dequeue();
	}

	public inline function peek():Null<KeyEvent>
	{
		return queue.peek();
	}

	public inline function hasNext():Bool
	{
		return !queue.isEmpty;
	}

	public function flush()
	{
		queue.flush();
	}

	private function handleKeyEvent(key:KeyCode, type:KeyEventType)
	{
		var event:KeyEvent = {
			key: key,
			type: type,
			shift: modShift,
			ctrl: modCtrl,
			alt: modAlt,
		};
		queue.enqueue(event);
	}

	private function setModKeys(key:KeyCode, type:KeyEventType)
	{
		switch key
		{
			case KEY_SHIFT:
				modShift = type == KEY_DOWN;
			case KEY_CONTROL:
				modCtrl = type == KEY_DOWN;
			case KEY_ALT:
				modAlt = type == KEY_DOWN;
			case _:
		}
	}

	function onSceneEvent(event:hxd.Event)
	{
		switch (event.kind)
		{
			case EMove:
				var previous = mouse;
				mouse = new Coordinate(event.relX, event.relY, SCREEN);
				Game.instance.screens.current.onMouseMove(mouse, previous);
			case EKeyUp:
				setModKeys(event.keyCode, KEY_UP);
			case EKeyDown:
				setModKeys(event.keyCode, KEY_DOWN);
				handleKeyEvent(event.keyCode, KEY_DOWN);
				Game.instance.screens.current.onKeyDown(event.keyCode);
			case EPush:
				switch (event.button)
				{
					case 0:
						lmb = true;
					case 1:
						rmb = true;
					case 2:
						mmb = true;
				}
				Game.instance.screens.current.onMouseDown(new Coordinate(event.relX, event.relY, SCREEN));
			case ERelease:
				switch (event.button)
				{
					case 0:
						lmb = false;
					case 1:
						rmb = false;
					case 2:
						mmb = false;
				}
				Game.instance.screens.current.onMouseUp(new Coordinate(event.relX, event.relY, SCREEN));
			case EWheel:
				if (event.wheelDelta > 0)
				{
					Game.instance.screens.current.onMouseWheelUp(event.wheelDelta);
				}
				else
				{
					Game.instance.screens.current.onMouseWheelDown(event.wheelDelta);
				}
			case _:
		}
	}
}
