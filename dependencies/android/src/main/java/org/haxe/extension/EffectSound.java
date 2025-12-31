package org.haxe.extension;

import android.media.AudioAttributes;
import android.media.SoundPool;
import android.os.Build;
import android.util.Log;

import java.util.HashMap;
import java.util.Map;

/**
 * 提供给音效使用的播放音频功能，目前暂不支持播放完成事件回调，如果需播放完成事件，请使用音乐音频
 */
public class EffectSound extends BaseSound {
    /**
     * 音效管理器
     */
    public static SoundPool soundPool;

    /**
     * 已加载完毕的音频缓存
     */
    public static Map<Integer, EffectSound> players = new HashMap<>();

    /**
     * SoundPool内部的音频id
     */
    private int __effectSoundId = -1;

    @Override
    public void load(String url) {
        super.load(url);
        if(soundPool == null){
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
                AudioAttributes attributes = new AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_GAME)
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
//                        .setFlags(AudioAttributes.FLAG_AUDIBILITY_ENFORCED)
                        .build();
                soundPool = new SoundPool.Builder().setAudioAttributes(attributes).setMaxStreams(30).build();
            }else{
                soundPool = new SoundPool(30, 3, 5);
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.FROYO) {
                soundPool.setOnLoadCompleteListener(new SoundPool.OnLoadCompleteListener() {
                    @Override
                    public void onLoadComplete(SoundPool soundPool, int sampleId, int status) {
                        BaseSound sound = players.get(sampleId);
                        if(sound != null){
                            if(status == 0)
                                sound.onCompleteEvent();
                            else
                                sound.onIOErrorEvent("Load fail status is " + status);
                        }
                    }
                });
            }
        }
        try {
            if (url.startsWith("/")) {
                __effectSoundId = soundPool.load(url, 0);
            } else {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
                    __effectSoundId = soundPool.load(Extension.mainContext.getAssets().openFd(url), 0);
                }else{
                    __effectSoundId = -1;
                }
            }
        } catch (Exception e){
            e.printStackTrace();
            __effectSoundId = -1;
        }
        if(__effectSoundId != -1){
            players.put(__effectSoundId, this);
        } else {
            this.onIOErrorEvent("Invail effectSoundId");
        }
    }

    /**
     * 开始播放音频
     * @param startTime
     * @return
     */
    @Override
    public int play(float startTime) {
        super.play(startTime);
        if(isLoaded){
            Log.i("EffectSound","EffectSound.play:" + this.url);
            return soundPool.play(__effectSoundId,leftVolume, rightVolume, 1, 0, 1);
        }
        return -1;
    }

    /**
     * 停止播放音频
     * @param streamId
     */
    @Override
    public void stop(int streamId) {
        super.stop(streamId);
        if(isLoaded){
            soundPool.stop(streamId);
        }
    }

    /**
     * 释放音频
     */
    @Override
    public void dispose() {
        super.dispose();
        soundPool.unload(this.__effectSoundId);
    }
}
