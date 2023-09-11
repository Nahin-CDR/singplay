import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

Widget shuffleButton({required BuildContext context,required bool isEnabled,required AudioPlayer audioPlayer}) {
  return IconButton(
    icon: isEnabled
        ? Icon(Icons.shuffle, color: Theme.of(context).canvasColor)
        : const Icon(Icons.shuffle),
    onPressed: () async {
      final enable = !isEnabled;
      if (enable) {
        await audioPlayer.shuffle();
      }
      await audioPlayer.setShuffleModeEnabled(enable);
    },
  );
}

Widget previousButton({required AudioPlayer audioPlayer}) {
  return IconButton(
    icon: const Icon(Icons.skip_previous),
    onPressed: audioPlayer.hasPrevious ? audioPlayer.seekToPrevious : null,
  );
}

Widget nextButton({required AudioPlayer audioPlayer}) {
  return IconButton(
    icon: const Icon(Icons.skip_next),
    onPressed: audioPlayer.hasNext ? audioPlayer.seekToNext : null,
  );
}

Widget repeatButton({
  required BuildContext context,
  required LoopMode loopMode,
  required AudioPlayer audioPlayer}) {
  final icons = [
    const Icon(Icons.repeat),
    Icon(Icons.repeat, color: Theme.of(context).canvasColor),
    Icon(Icons.repeat_one, color: Theme.of(context).canvasColor),
  ];
  const cycleModes = [
    LoopMode.off,
    LoopMode.all,
    LoopMode.one,
  ];
  final index = cycleModes.indexOf(loopMode);
  return IconButton(
    icon: icons[index],
    onPressed: () {
      audioPlayer.setLoopMode(cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
    },
  );
}

Widget playPauseButton({required PlayerState playerState,required AudioPlayer audioPlayer}) {
  final processingState = playerState.processingState;
  if (processingState == ProcessingState.loading ||
      processingState == ProcessingState.buffering) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: 64.0,
      height: 64.0,
      child: const CircularProgressIndicator(),
    );
  } else if (audioPlayer.playing != true) {
    return IconButton(
      icon: const Icon(Icons.play_arrow),
      iconSize: 64.0,
      onPressed: audioPlayer.play,
    );
  } else if (processingState != ProcessingState.completed) {
    return IconButton(
      icon: const Icon(Icons.pause),
      iconSize: 64.0,
      onPressed: audioPlayer.pause,
    );
  } else {
    return IconButton(
      icon: const Icon(Icons.replay),
      iconSize: 64.0,
      onPressed: () => audioPlayer.seek(Duration.zero,
          index: audioPlayer.effectiveIndices?.first
      ),
    );
  }
}