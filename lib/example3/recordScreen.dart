import 'dart:io';

import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioRecordScreen extends StatefulWidget {
  const AudioRecordScreen({super.key});

  @override
  State<AudioRecordScreen> createState() => _AudioRecordScreenState();
}

class _AudioRecordScreenState extends State<AudioRecordScreen> {

  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = "";
  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    super.initState();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> startRecording()async{
    try{
      if(await audioRecord.hasPermission()){
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    }catch(error){
      print("Error occurred while starting record : $error");
    }
  }

  Future<void>stopRecording()async{
    try{
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
      });
    }catch(error){
      print("Error occurred while starting record : $error");
    }
  }


  Future<void>playRecording()async{
    try{
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    }catch(error){
      print("Error occurred while playing record : $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Record Screen"),
      ),
      body: Column(
        children: [
          if(isRecording)
            const Text("Recording in progress ..."),
          const SizedBox(height: 50),
          ElevatedButton(
              onPressed: isRecording? stopRecording : startRecording,
              child: isRecording? const Text("stop") : const Text("start")
          ),
          const SizedBox(height: 20),
          if(!isRecording && audioPath.isNotEmpty)
            ElevatedButton(
              onPressed: playRecording,
              child: const Text("play")
            )
        ],
      ),
    );
  }
}
