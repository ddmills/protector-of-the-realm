package core;

import core.input.Command;
import data.input.Commands;
import h2d.Console;

class ConsoleConfig
{
	static var SAVE_DATA:String;

	static var game(get, never):Game;

	public static function Config(console:Console)
	{
		console.log('Type "help" for list of commands.');

		console.addCommand('exit', 'Close the console', [], () ->
		{
			game.screens.pop();
		});

		console.addCommand('cmds', 'List available commands on current screen', [], () ->
		{
			console.log('Available commands', game.TEXT_COLOR_FOCUS);
			Commands.GetForDomains([INPUT_DOMAIN_DEFAULT, game.screens.previous.inputDomain]).each((cmd:Command) ->
			{
				console.log('${cmd.friendlyKey()} - ${cmd.name}', game.TEXT_COLOR_FOCUS);
			});
		});
	}

	static function entityCountCmd(console:Console)
	{
		console.log('Entities: ${game.registry.size}', game.TEXT_COLOR_FOCUS);
	}

	static function get_game():Game
	{
		return Game.instance;
	}
}
