package common.media;

import openfl.events.EventDispatcher;

class SoundChannel extends EventDispatcher {
	private var __soundId:Int;

	public function new() {
		super();
	}

	public function stop() {
		NativeSound.stop(__soundId);
	}
}
