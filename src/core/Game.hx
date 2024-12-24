package core;

import common.tools.Performance;
import core.input.CommandManager;
import core.input.InputManager;
import core.rendering.RenderLayerManager;
import data.core.ColorKey;
import data.resources.FontResources;
import domain.World;
import ecs.Registry;
import h2d.Console;
import hxd.Window;

class Game
{
	public static var TILE_SIZE:Int = 32;

	public var CLEAR_COLOR:ColorKey = ColorKey.C_CLEAR;
	public var TEXT_COLOR:ColorKey = C_TEXT;
	public var TEXT_COLOR_FOCUS:ColorKey = C_YELLOW;

	public static var instance:Game;

	public var backgroundColor(get, set):Int;
	public var frame(default, null):Frame;
	public var clock(default, null):Clock;
	public var app(default, null):hxd.App;
	public var camera(default, null):Camera;
	public var window(get, never):hxd.Window;
	public var screens(default, null):ScreenManager;
	public var audio(default, null):AudioManager;
	public var input(default, null):InputManager;
	public var commands(default, null):CommandManager;
	public var console(default, null):Console;
	public var layers(default, null):RenderLayerManager;
	public var registry(default, null):Registry;
	public var world(default, null):World;
	public var files(default, null):FileManager;

	private function new(app:hxd.App)
	{
		instance = this;
		this.app = app;

		frame = new Frame();
		clock = new Clock();
		files = new FileManager();
		screens = new ScreenManager();
		audio = new AudioManager();
		layers = new RenderLayerManager();
		camera = new Camera();
		input = new InputManager();
		commands = new CommandManager();
		console = new Console(FontResources.BIZCAT);
		registry = new Registry();

		ConsoleConfig.Config(console);

		app.s2d.scaleMode = Fixed(800, 600, 1, Left, Top);
		app.s2d.addChild(layers.root);
	}

	public static function Create(app:hxd.App)
	{
		if (instance != null)
		{
			return instance;
		}

		return new Game(app);
	}

	public inline function update()
	{
		Performance.update(frame.dt * 1000);
		frame.update();
		clock.update(frame);
		screens.current.update(frame);
	}

	public inline function render(layer:RenderLayerType, ob:h2d.Object)
	{
		layers.render(layer, ob);
	}

	public inline function clear(layer:RenderLayerType)
	{
		return layers.clear(layer);
	}

	public function mount()
	{
		layers.clearAll();
		frame = new Frame();
	}

	function get_backgroundColor():Int
	{
		return app.engine.backgroundColor;
	}

	function set_backgroundColor(value:Int):Int
	{
		return app.engine.backgroundColor = value;
	}

	inline function get_window():Window
	{
		return hxd.Window.getInstance();
	}

	@:allow(core.Screen)
	private function setWorld(world:World)
	{
		this.world = world;
	}
}
