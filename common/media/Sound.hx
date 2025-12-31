package common.media;

import sys.FileSystem;
import haxe.io.Path;
import sys.io.File;
import hx.core.BaseSoundChannel;
import openfl.events.IOErrorEvent;
import openfl.events.Event;
import hx.core.BaseSoundChannel;
import openfl.media.SoundTransform;
import openfl.utils.ByteArray;
import openfl.media.SoundLoaderContext;
import openfl.net.URLRequest;
import hx.core.IBaseSound;
import openfl.events.EventDispatcher;
import common.media.SoundChannel;

/**
 * 安卓本机使用MP3加载器
 */
class Sound extends EventDispatcher implements IBaseSound {
	public static var __tempSoundId:Int = 0;

	/**
	 * 获得当前声音的长度，单位为毫秒
	 */
	public var length(get, never):Float;

	@:noCompletion private var __isMusic:Bool = false;

	@:noCompletion private var __soundId:Int = -1;

	private function get_length():Float {
		return 0.0;
	}

	/**
	 * 获得当前声音的URL
	 */
	public var url(default, null):String;

	/**
	 * 关闭当前声音，会进行释放音频
	 */
	public function close():Void {}

	/**
	 * 回调对象
	 */
	private var __callbackObject:Dynamic = null;

	/**
	 * 音乐通道
	 */
	private var __musicChannel:SoundChannel = null;

	/**
	 * 加载当前声音，提供加载路径进行加载
	 * @param stream 加载路径
	 * @param context 加载上下文，默认值为null
	 */
	public function load(stream:URLRequest, context:SoundLoaderContext = null):Void {
		__callbackObject = {
			onCompleteEvent: function() {
				this.dispatchEvent(new Event(Event.COMPLETE));
			},
			onIOErrorEvent: function(error:String) {
				this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			},
			onPlayCompleteEvent: function(streamId:Int) {
				if (__musicChannel != null)
					__musicChannel.dispatchEvent(new Event(Event.SOUND_COMPLETE));
			},
		}
		__soundId = NativeSound.loadSound(stream.url, __isMusic, __callbackObject);
		this.url = stream.url;
	}

	/**
	 * 从ByteArray加载压缩后的音频数据
	 * @param bytes 音频数据
	 * @param bytesLength 音频数据长度
	 */
	public function loadCompressedDataFromByteArray(bytes:ByteArray, bytesLength:Int):Void {
		var dir = Path.join([NativeSound.getApplicationCache(), "temp_sounds"]);
		if (!FileSystem.exists(dir)) {
			FileSystem.createDirectory(dir);
		}
		__tempSoundId++;
		var save = Path.join([dir, "temp_" + __tempSoundId + ".mp3"]);
		File.saveBytes(save, bytes);
		this.load(new URLRequest(save));
	}

	/**
	 * 播放当前声音
	 * @param startTime 播放起始时间，默认值为0.0
	 * @param loops 播放循环次数，默认值为0
	 * @param sndTransform 播放音效变换，默认值为null
	 * @return 播放通道
	 */
	public function play(startTime:Float = 0.0, loops:Int = 0, sndTransform:SoundTransform = null):BaseSoundChannel {
		if (__soundId == -1)
			return null;
		var streamId = NativeSound.play(__soundId);
		var channel = new SoundChannel();
		@:privateAccess channel.__soundId = streamId;
		if (__isMusic)
			__musicChannel = channel;
		return channel;
	}
}
