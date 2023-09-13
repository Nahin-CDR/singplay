import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singplay/example2/musicScreen.dart';
import 'package:singplay/example3/recordScreen.dart';

void main(){
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown
      ),
      home: const AudioRecordScreen()//MusicScreen(),
    );
  }
}