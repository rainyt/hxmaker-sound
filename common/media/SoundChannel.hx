package common.media;

import openfl.media.SoundTransform;
import openfl.events.EventDispatcher;

class SoundChannel extends EventDispatcher {
	private var __soundId:Int;

	public var soundTransform(get, set):SoundTransform;

	private var __soundTransform:SoundTransform;

	private function set_soundTransform(value:SoundTransform):SoundTransform {
		if (value != null) {
			__soundTransform = value;
			NativeSound.setVolume(__soundId, __soundTransform.volume * (1 - __soundTransform.pan), __soundTransform.volume * (1 + __soundTransform.pan));
		}
		return value;
	}

	private function get_soundTransform():SoundTransform {
		return __soundTransform;
	}

	public function new() {
		super();
	}

	public function stop() {
		NativeSound.stop(__soundId);
	}
}
