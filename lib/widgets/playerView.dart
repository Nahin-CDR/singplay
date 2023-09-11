import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'buttons.dart';

class PlayerView extends StatelessWidget {
  final AudioPlayer audioPlayer;
  const PlayerView({super.key,required this.audioPlayer});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StreamBuilder<bool>(
          stream: audioPlayer.shuffleModeEnabledStream,
          builder: (context, snapshot) {
            return shuffleButton(context: context, isEnabled: snapshot.hasData??false, audioPlayer: audioPlayer);
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: audioPlayer.sequenceStateStream,
          builder: (_, __) {
            return previousButton(audioPlayer: audioPlayer);
          },
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (child, snapshot) {
            final playerState = snapshot.data;
            return playPauseButton(playerState: playerState!, audioPlayer:audioPlayer);
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: audioPlayer.sequenceStateStream,
          builder: (_, __) {
            return nextButton(audioPlayer: audioPlayer);
          },
        ),
        StreamBuilder<LoopMode>(
          stream: audioPlayer.loopModeStream,
          builder: (context, snapshot) {
            return repeatButton(
                context: context,
                loopMode: snapshot.data ?? LoopMode.off,
                audioPlayer: audioPlayer
            );
          },
        ),
      ],
    );
  }
}
