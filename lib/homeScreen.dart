import 'package:flutter/material.dart';
import 'package:singplay/example2/musicScreen.dart';
import 'package:singplay/example3/recordScreen.dart';
import 'package:singplay/example4/recordScreen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SingPlay"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed:(){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>const MusicScreen()));
                  } ,
                  child: const Text("Music Play from online")
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                  onPressed:(){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context)=>const AudioRecorderPage()));
                  } ,
                  child: const Text("Audio Recorder")
              ),
            )
          ],
        ),
      )
    );
  }
}
