package org.haxe.extension;

import android.util.Log;

import org.haxe.lime.HaxeObject;

public class BaseSound {
    /**
     * 音频
     */
    public int soundId = -1;

    public String url;

    /**
     * 音频的加载状态
     */
    public boolean isLoaded = false;

    /**
     * 回调事件对象
     */
    public HaxeObject callbackObject;

    /**
     * 播放音频
     * @param startTime
     */
    public int play(float startTime){
        return -1;
    }

    /**
     * 加载音频
     * @param url
     */
    public void load(String url){
        this.url = url;
    }

    /**
     * 停止播放音频
     */
    public void stop(int streamId){

    }

    /**
     * 左音道声音
     */
    public float leftVolume = 1;

    /**
     * 右音道声音
     */
    public float rightVolume = 1;

    /**
     * 设置声道的声音
     * @param left
     * @param right
     */
    public void setVolume(int streamId, float left, float right){
        this.leftVolume = left;
        this.rightVolume = right;
    }

    /**
     * 释放当前音频
     */
    public void dispose() {

    }

    /**
     * 获得音频长度
     * @return
     */
    public float getDuration() {
        return 0;
    }

    /**
     * 当音频加载完成时触发
     */
    public void onCompleteEvent() {
        isLoaded = true;
        Log.i("BaseSound", "onCompleteEvent");
        callbackObject.call0("onCompleteEvent");
    }

    /**
     * 当前音频加载失败时触发
     */
    public void onIOErrorEvent(String error) {
        isLoaded = false;
        Log.i("BaseSound", "onIOErrorEvent:" + error + " url:" + url);
        callbackObject.call0("onIOErrorEvent");
    }

    /**
     * 播放完成事件触发
     */
    public void onPlayCompleteEvent(int streamId){
        Log.i("BaseSound", "onPlayCompleteEvent:" + streamId);
        callbackObject.call1("onPlayCompleteEvent",streamId);
    }
}
