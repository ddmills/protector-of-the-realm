package data.input;

import core.input.KeyCode;

enum abstract Keybinding(KeyCode) from KeyCode to KeyCode
{
	var BACK = KEY_ESCAPE;
	var CONSOLE_SCREEN = KEY_COMMA;
}
