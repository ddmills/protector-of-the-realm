package screens.splash;

import common.util.Timeout;
import core.Frame;
import core.Screen;
import core.input.KeyCode;
import domain.World;
import screens.play.PlayScreen;

class SplashScreen extends Screen
{
	var title:h2d.Text;
	var next:h2d.Text;
	var timeout:Timeout;

	public function new()
	{
		timeout = new Timeout(2);
		timeout.onComplete = timeout.reset;
	}

	override function onEnter()
	{
		game.setWorld(null);

		title = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		title.setScale(1);
		title.text = "myth";
		title.color = new h3d.Vector4(1, 1, .9);

		next = new h2d.Text(hxd.Res.fnt.bizcat.toFont());
		next.setScale(1);
		next.text = "(n)ew game, (l)oad game";
		next.color = new h3d.Vector4(1, 1, .9);

		game.render(HUD, title);
		game.render(HUD, next);
	}

	override function onKeyDown(key:KeyCode)
	{
		if (key == KEY_N)
		{
			newGame();
		}
		if (key == KEY_L)
		{
			loadGame();
		}
	}

	override function update(frame:Frame)
	{
		timeout.update();

		title.textAlign = Center;
		title.x = camera.width / 2;
		title.y = camera.height / 2;

		next.textAlign = Center;
		next.x = camera.width / 2;
		next.y = camera.height / 2 + 128;

		var scale = timeout.progress.yoyo(EASE_OUT_BOUNCE);

		title.setScale(3 + scale);
	}

	private function newGame()
	{
		var seed = Std.random(0xffffff);
		trace('seed - ${seed}');
		game.files.deleteSave('test');
		game.files.setSaveName('test');
		game.setWorld(new World());
		game.world.initialize();
		game.world.newGame(seed);
		start();
	}

	private function loadGame()
	{
		game.files.setSaveName('test');
		var data = game.files.tryReadWorld();
		game.setWorld(new World());
		game.world.initialize();
		game.world.load(data);
		start();
	}

	private function start()
	{
		game.screens.set(new PlayScreen());
	}

	override function onDestroy()
	{
		title.remove();
		next.remove();
	}
}
