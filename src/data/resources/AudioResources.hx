package data.resources;

import hxd.res.Sound;

class AudioResources
{
	public static var audio:Map<AudioKey, Sound> = [];

	public static function Get(type:AudioKey):Sound
	{
		if (type.isNull())
		{
			return null;
		}
		return audio.get(type);
	}

	public static function Init()
	{
		if (hxd.res.Sound.supportedFormat(OggVorbis))
		{
			// var r = hxd.Res.sound;
		}
		else
		{
			trace('OggVorbis NOT SUPPORTED');
		}
	}
}
