package screens.save;

import core.Screen;
import screens.splash.SplashScreen;

class SaveScreen extends Screen
{
	var teardown:Bool;

	public function new(teardown:Bool = false)
	{
		this.teardown = teardown;
	}

	public override function onEnter()
	{
		if (teardown)
		{
			var data = world.save(true);
			game.files.saveWorld(data);
			game.screens.set(new SplashScreen());
		}
		else
		{
			var data = world.save(false);
			game.files.saveWorld(data);
			game.screens.pop();
		}
	}
}
