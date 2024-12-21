package core;

import data.resources.AudioKey;
import data.resources.AudioResources;

class AudioManager
{
	public function new()
	{
		var manager = hxd.snd.Manager.get();
		manager.masterVolume = 0.1;
	}

	public function play(key:Null<AudioKey>)
	{
		var sound = AudioResources.Get(key);

		if (sound.isNull())
		{
			return;
		}

		sound.play();
	}
}
