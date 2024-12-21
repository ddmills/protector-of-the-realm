package domain.systems;

import core.Frame;
import domain.components.Drawable;
import domain.components.IsDestroyed;
import domain.components.IsDetached;
import domain.components.Sprite;
import domain.components.SpriteAnim;
import ecs.Query;
import ecs.System;

class SpriteSystem extends System
{
	var sprites:Query;
	var anims:Query;

	public var debug(default, set):Bool;

	public function new()
	{
		sprites = new Query({
			all: [Sprite],
			none: [IsDetached, IsDestroyed]
		});
		anims = new Query({
			all: [SpriteAnim],
			none: [IsDetached, IsDestroyed]
		});

		sprites.onEntityAdded((entity) -> renderSprite(entity.get(Sprite)));
		sprites.onEntityRemoved((entity) -> removeSprite(entity.get(Sprite)));

		anims.onEntityAdded((entity) -> renderSprite(entity.get(SpriteAnim)));
		anims.onEntityRemoved((entity) -> removeSprite(entity.get(SpriteAnim)));
	}

	public override function update(frame:Frame)
	{
		if (frame.tick % 24 != 0)
		{
			game.layers.sort(OBJECTS);
		}
	}

	private function renderSprite(drawable:Drawable)
	{
		if (drawable != null)
		{
			drawable.debug = debug;
			game.render(drawable.layer, drawable.ob);
		}
	}

	private function removeSprite(drawable:Drawable)
	{
		if (drawable != null)
		{
			drawable.drawable.remove();
		}
	}

	function set_debug(value:Bool):Bool
	{
		for (e in sprites)
		{
			e.get(Sprite).debug = value;
		}
		for (e in anims)
		{
			e.get(SpriteAnim).debug = value;
		}
		return debug = value;
	}
}
