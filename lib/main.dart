import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:flutter_ui/play_ground.dart';
import 'package:provider/provider.dart';
import 'card_swipe_ui/provider/feedback_position_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FeedbackPositionProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        home: Scaffold(
          appBar: AppBar(title: Text("Flutter UI")),
          body: Container(
            child: PlayGround(),
          ),
        ),
      ),
    );
  }
}
