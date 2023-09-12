import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'playerView.dart';


class Player extends StatefulWidget {
  const Player({super.key});
  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player>{
  bool loading = true;
  late AudioPlayer audioPlayer;

  Future<void>initMusic()async{
    audioPlayer = AudioPlayer();
    audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
            children: [
              AudioSource.uri(Uri.parse("https://be-music.s3-us-west-1.amazonaws.com/2627f34b-ac90-43e0-be71-be873620787f/4a357601-66d9-4896-bd16-26e0c16c13d3.mp3")),
              AudioSource.uri(Uri.parse("https://be-music.s3-us-west-1.amazonaws.com/f0bcd86d-7fce-4b82-8db8-dbc82b405da9/940e46dc-1ac9-46e5-b1e2-f43796b5cbf1.mp3")),
            ]
        )).catchError((error){
      if (kDebugMode) {
        print("Audio Player ERROR : $error");
      }
    });
  }

  @override
  void initState(){
    setState(() {
      loading = true;
    });
    initMusic();
    Timer(const Duration(seconds: 9), () {
      setState(() {
        loading = false;
      });
    });

    super.initState();
  }
  Widget _playerButton(PlayerState playerState) {
    // 1
    final processingState = playerState.processingState;
    if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
    // 2
      return Container(
        margin: const EdgeInsets.all(8.0),
        width: 64.0,
        height: 64.0,
        child: const CircularProgressIndicator(),
      );
    } else if (audioPlayer.playing != true) {
      // 3
      return IconButton(
        icon: const Icon(Icons.play_arrow),
        iconSize: 64.0,
        onPressed: audioPlayer.play,
      );
    } else if (processingState != ProcessingState.completed) {
      // 4
      return IconButton(
        icon: const Icon(Icons.pause),
        iconSize: 64.0,
        onPressed: audioPlayer.pause,
      );
    } else {
      // 5
      return IconButton(
        icon: const Icon(Icons.replay),
        iconSize: 64.0,
        onPressed: () => audioPlayer.seek(
            Duration.zero,
            index: audioPlayer.effectiveIndices?.first
        ),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading?const Center(
        child: CircularProgressIndicator(color: Colors.green),
      ):Center(
        child: PlayerView(audioPlayer: audioPlayer),
      )
    );
  }
}
/*
Center(
        child: StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context,AsyncSnapshot snapshot) {
            final playerState = snapshot.data;
            return _playerButton(playerState);
          },
        ),
      ),
 */