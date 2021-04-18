import 'package:flutter/material.dart';
import 'package:flutter_ui/choose_participant_for_your_date.dart';
import 'package:flutter_ui/draggable_list_view.dart';

import 'package:flutter_ui/user_card_stack.dart';
import 'package:flutter_ui/custom_day_picker.dart';
class PlayGround extends StatefulWidget {
  @override
  _PlayGroundState createState() => _PlayGroundState();
}

class _PlayGroundState extends State<PlayGround> {
  var isMenuShowed=true;
  var _widgetName='tinder_swipe';
  final widgetList=['tinder_swipe','calendar','draggable_list_view','draggable_list_with_ranking'];
  Widget buildWidgetPage(widgetName){
    var widget;
    switch(widgetName){
      case 'tinder_swipe':
        widget=UserCardStack();
        break;
      case 'calendar':
        widget=CustomDayPicker();
        break;
      case 'draggable_list_view':
        widget=Expanded(child: DraggableList());
        break;
      case 'draggable_list_with_ranking':
        widget=ChooseParticipantForYourDate();
        break;
    }
    return Column(
      children: [
        ElevatedButton(onPressed: (){
          setState(() {
            isMenuShowed=true;
          });
        }, child: Text("Quay về")),
        widget
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return isMenuShowed?Container(
      width: double.infinity,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
        SizedBox(height:20),
        ...widgetList.map((widgetName) => ElevatedButton(onPressed: (){
          setState(() {
            isMenuShowed=false;
            _widgetName=widgetName;
          });
        }, child: Text(widgetName))).toList()
      ]),
    ):buildWidgetPage(_widgetName);
    

  }
}
