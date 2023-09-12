import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:singplay/example2/pageManager.dart';

/// Source : https://medium.com/@suragch/steaming-audio-in-flutter-with-just-audio-7435fcf672bf

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {

  late final PageManager _pageManager;

  @override
  void initState() {
    // TODO: implement initState
    _pageManager = PageManager();
    super.initState();
  }
  TextEditingController textEditingController = TextEditingController();
  @override


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Player"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Spacer(),
            ValueListenableBuilder(
                valueListenable: _pageManager.progressNotifier,
                builder: (context,value,widget){
                  return ProgressBar(
                      progress: value.current,
                      total: value.total,
                      onSeek: (position) {
                        _pageManager.seek(position);
                      },
                  );
                }
            ),
            ValueListenableBuilder<ButtonState>(
                valueListenable: _pageManager.buttonNotifier,
                builder: (context,value,widget){
                  switch(value){
                    case ButtonState.loading:
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        child: const CircularProgressIndicator(),
                      );
                    case ButtonState.paused:
                      return IconButton(
                          onPressed:(){
                            _pageManager.play();
                          },
                          icon: const Icon(Icons.play_arrow,size: 32.0)
                      );
                    case ButtonState.playing:
                      return IconButton(
                          onPressed: (){
                            _pageManager.pause();
                          },
                          icon: const Icon(Icons.pause,size: 32.0)
                      );
                     default:
                       return Container();
                  }
                }
            )
          ],
        ),
      ),
    );
  }
}
