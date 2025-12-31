package org.haxe.extension;

import android.content.res.AssetFileDescriptor;
import android.media.MediaPlayer;
import android.util.Log;

/**
 * 支持长音频的音乐音频，支持播放完成回调
 */
public class MusicSound extends BaseSound {

    MediaPlayer player;

    @Override
    public void load(String url) {
        super.load(url);
        try {
            player = new MediaPlayer();
            // 如果是 assets 中的文件
            if(url.startsWith("/")){
                player.setDataSource(url);
            }else {
                AssetFileDescriptor afd = Extension.mainActivity.getAssets().openFd(url);
                player.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
                afd.close();
            }
            player.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
                @Override
                public void onPrepared(MediaPlayer mediaPlayer) {
                    // 背景音乐加载完成
                    MusicSound.this.onCompleteEvent();
                }
            });
            player.setOnErrorListener(new MediaPlayer.OnErrorListener() {
                @Override
                public boolean onError(MediaPlayer mediaPlayer, int i, int i1) {
                    MusicSound.this.onIOErrorEvent("MediaPlayer load fail:" + i + ", " + i1);
                    return false;
                }
            });
            player.prepareAsync();
        } catch (Exception e) {
            Log.e("MusicSound", "Error loading MP3: " + e.getMessage());
        }
    }

    @Override
    public int play(float startTime) {
        if(isLoaded){
            Log.i("MusicSound","MusicSound.play:" + this.url);
            if(!player.isPlaying())
                player.start();
        }
        return soundId;
    }

    @Override
    public void stop(int streamId) {
        super.stop(streamId);
        Log.i("MusicSound","MusicSound.stop:" + this.url);
        if(isLoaded){
            if(player.isPlaying())
                player.stop();
        }
    }

    @Override
    public void setVolume(float left, float right) {
        super.setVolume(left, right);
        if(isLoaded){
            player.setVolume(left, right);
        }
    }

    @Override
    public float getDuration() {
        if(isLoaded){
            return player.getDuration();
        }
        return super.getDuration();
    }

    @Override
    public void dispose() {
        super.dispose();
        if(isLoaded){
            player.release();
            player = null;
        }
    }
}
