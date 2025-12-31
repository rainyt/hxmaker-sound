package;

import lime.system.CFFI;
import lime.system.JNI;

class NativeSound {
	#if android
	/**
	 * 加载声音JNI方法
	 * 	public static int load(String assetPath, boolean loadMediaPlayer, HaxeObject callbackObject) {
	 */
	private static var hxmaker_sound_load_jni = JNI.createStaticMethod("org.haxe.extension.SoundManager", "load",
		"(Ljava/lang/String;ZLorg/haxe/lime/HaxeObject;)I");

	/**
	 * 播放声音JNI方法
	 */
	private static var hxmaker_sound_play_jni = JNI.createStaticMethod("org.haxe.extension.SoundManager", "play", "(I)I");

	/**
	 * 停止声音JNI方法
	 */
	private static var hxmaker_sound_stop_jni = JNI.createStaticMethod("org.haxe.extension.SoundManager", "stop", "(I)V");

	/**
	 * 设置声音音量JNI方法
	 */
	private static var hxmaker_sound_setVolume_jni = JNI.createStaticMethod("org.haxe.extension.SoundManager", "setVolume", "(IFF)V");

	/**
	 * 获取声音当前播放位置JNI方法
	 */
	private static var hxmaker_sound_getDuration_jni = JNI.createStaticMethod("org.haxe.extension.SoundManager", "getDuration", "(I)F");

	/**
	 * 释放声音JNI方法
	 */
	private static var hxmaker_sound_dispose_jni = JNI.createStaticMethod("org.haxe.extension.SoundManager", "dispose", "(I)V");

	/**
	 * 释放所有声音JNI方法
	 */
	private static var hxmaker_sound_disposeAll_jni = JNI.createStaticMethod("org.haxe.extension.SoundManager", "disposeAll", "()V");
	#end

	/**
	 * 加载声音
	 * @param url 声音URL
	 * @return 声音ID
	 */
	public static function loadSound(url:String, loadMediaPlayer:Bool = false, callbackObject:Dynamic = null):Int {
		#if android
		var soundId = hxmaker_sound_load_jni(url, loadMediaPlayer, callbackObject);
		return soundId;
		#else
		return -1;
		#end
	}

	/**
	 * 播放声音
	 * @param id 声音ID
	 */
	public static function play(id:Int):Int {
		#if android
		return hxmaker_sound_play_jni(id);
		#else
		trace("play sound id: $id");
		return -1;
		#end
	}

	/**
	 * 停止声音
	 * @param id 声音ID
	 */
	public static function stop(id:Int):Void {
		#if android
		hxmaker_sound_stop_jni(id);
		#else
		trace("stop sound id: $id");
		#end
	}

	/**
	 * 设置声音音量
	 * @param id 声音ID
	 * @param leftVolume 左声道音量，范围为0.0到1.0
	 * @param rightVolume 右声道音量，范围为0.0到1.0
	 */
	public static function setVolume(id:Int, leftVolume:Float, rightVolume:Float):Void {
		#if android
		hxmaker_sound_setVolume_jni(id, leftVolume, rightVolume);
		#else
		trace("set sound id: $id volume: $leftVolume, $rightVolume");
		#end
	}

	/**
	 * 获取声音当前播放位置
	 * @param id 声音ID
	 * @return 当前播放位置，单位为毫秒
	 */
	public static function getDuration(id:Int):Float {
		#if android
		return hxmaker_sound_getDuration_jni(id);
		#else
		return 0.0;
		#end
	}

	/**
	 * 释放声音
	 * @param id 声音ID
	 */
	public static function dispose(id:Int):Void {
		#if android
		hxmaker_sound_dispose_jni(id);
		#else
		trace("dispose sound id: $id");
		#end
	}

	/**
	 * 释放所有声音
	 */
	public static function disposeAll():Void {
		#if android
		hxmaker_sound_disposeAll_jni();
		#else
		trace("dispose all sounds");
		#end
	}
}
