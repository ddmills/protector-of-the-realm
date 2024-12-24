import core.Game;
import data.input.Commands;
import data.resources.AnimationResources;
import data.resources.AudioResources;
import data.resources.Bitmasks;
import data.resources.FontResources;
import data.resources.TileResources;
import screens.splash.SplashScreen;

class Main extends hxd.App
{
	var game:Game;

	static function main()
	{
		// hxd.Res.initEmbed();
		hxd.Res.initLocal();
		new Main();
	}

	override function init()
	{
		// hack to fix audio not playing more than once
		@:privateAccess haxe.MainLoop.add(() -> {});

		FontResources.Init();
		TileResources.Init();
		AnimationResources.Init();
		AudioResources.Init();
		Bitmasks.Init();
		Commands.Init();

		hxd.Window.getInstance().title = "Myth";

		game = Game.Create(this);
		game.backgroundColor = game.CLEAR_COLOR;
		game.screens.set(new SplashScreen());
	}

	override function update(dt:Float)
	{
		game.update();
	}
}
