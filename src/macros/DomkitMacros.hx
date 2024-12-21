package macros;

class DomkitMacros
{
	public static function Init()
	{
		domkit.Macros.registerComponentsPath("Components.$Component");
		domkit.Macros.registerComponentsPath("$Component");
		// domkit.Macros.processMacro = processMacro;
		// domkit.Macros.checkCSS("test.css");
	}
}
