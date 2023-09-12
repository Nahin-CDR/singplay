import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

class PageManager{
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  static const url = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3";
  late AudioPlayer _audioPlayer;
  PageManager(){
    _init();
  }

  void _init()async{
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setUrl(url);

    _audioPlayer.playerStateStream.listen((playerState){
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if(processingState == ProcessingState.loading || processingState == ProcessingState.buffering){
        buttonNotifier.value = ButtonState.loading;
      }else if(!isPlaying){
        buttonNotifier.value = ButtonState.paused;
      }else if(processingState != ProcessingState.completed){
       buttonNotifier.value = ButtonState.playing;
      }
      else{
        /// completed
        //buttonNotifier.value = ButtonState.playing;
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    /// Updating the progress bar
    // The progress bar needs the following three data points:
    // => The current play position
    // => The buffered position
    // => The total audio duration
    // AudioPlayer provides this data in three different streams:

    /// 1. PositionStream:
    // This stream of type Duration gives frequent updates,
    // often enough to make the progress bar thumb look animated as it moves across the bar.
    /// 2. BufferedPositionStream:
    // This stream of type Duration gives intermittent updates,
    // enough to make the buffering show as occasional jumps in progress.
    /// 3. DurationStream:
    // This stream of type Duration? gives a single update shortly after the audio loads.
    // After that there aren’t any more updates until a new audio source is loaded.


    /*
    Listening to the position stream
    Still in page_manager.dart,
    add the following code at the bottom of the _init method:
     */
    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total
      );
    });

    /*
    Listening to the buffered position stream
    You’ll do almost exactly the same thing for the
    buffered position.
    Add the following code at the bottom of
    the _init method:
     */

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: bufferedPosition,
          total: oldState.total
      );
    });

    /*
    Listening to the duration stream :
    The process is the same for the duration stream.
    Add the following stream listener at the bottom of the _init method:
    */

    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: oldState.buffered,
          total: totalDuration ?? Duration.zero
      );
    });
    /*
    Unlike the two previous streams,
    the duration stream gives nullable values.
    The progress bar won’t accept a null value,
    though, so you gave it a default of Duration.zero
    */

  }

  /// Seeking to a new audio position
  /*
    AudioPlayer has a seek method so all you need to do is hook it up.
    In page_manager.dart, add the following method to PageManager:
    */

  void seek(Duration position){
    _audioPlayer.seek(position);
  }
  void play(){
    _audioPlayer.play();
  }
  void pause(){
    _audioPlayer.pause();
  }


}





class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState {
  paused, playing, loading
}