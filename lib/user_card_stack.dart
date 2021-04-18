import 'package:flutter/material.dart';
import 'package:flutter_ui/card_swipe_ui/data/users.dart';
import 'package:flutter_ui/card_swipe_ui/user_card_widget.dart';
import 'card_swipe_ui/model/user.dart';
import 'card_swipe_ui/provider/feedback_position_provider.dart';
import 'package:provider/provider.dart';

class UserCardStack extends StatefulWidget {
  @override
  _UserCardStackState createState() => _UserCardStackState();
}

class _UserCardStackState extends State<UserCardStack> {
  var  users = dummyUsers;
  var backup=dummyUsers.map((element)=>element).toList();
  var saveToFirstDragPosition=true;
  var firstDragPosition;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      child: users.isEmpty
          ? ElevatedButton(onPressed: (){
            setState(() {
              users=backup.map((element)=>element).toList();
            });

      }, child: Text("Reset stack"))
          : Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        height: size.height*0.7,
        child: Stack(
          children: users.map(buildUser).toList(),
        ),
      ),
    );
  }

  Widget buildUser(User user) {
    final userIndex = users.indexOf(user);
    final isUserInFocus = userIndex == users.length - 1;
    return Listener(
      onPointerMove: (pointerEvent) {
        final provider =
        Provider.of<FeedbackPositionProvider>(context, listen: false);
        provider.updatePosition(pointerEvent.localDelta.dx);
      },
      onPointerCancel: (_) {
        final provider =
        Provider.of<FeedbackPositionProvider>(context, listen: false);
        provider.resetPosition();
      },
      onPointerUp: (_) {
        final provider =
        Provider.of<FeedbackPositionProvider>(context, listen: false);
        provider.resetPosition();
      },
      child: Container(
        alignment: Alignment.center,
        child: Draggable(

          child: UserCardWidget(user: user, isUserInFocus: isUserInFocus),
          feedback: Material(
            type: MaterialType.transparency,
            child: UserCardWidget(user: user, isUserInFocus: isUserInFocus),
          ),
          childWhenDragging: Container(),
          onDragEnd: (details) => onDragEnd(details, user),
          onDragUpdate: (details) => onDragUpdate(details),
        ),
      ),
    );
  }

  void onDragEnd(DraggableDetails details, User user) {
    final minimumDrag = 100;
    setState(() {
      saveToFirstDragPosition=true;
    });
    if (details.offset.dx > minimumDrag) {
      user.isSwipedOff = true;
    } else if (details.offset.dx < -minimumDrag) {
      user.isLiked = true;
    }
    // nếu quẹt tối thiểu 100 px qua trái hoặc qua phải
    if (details.offset.dx.abs() > minimumDrag) {
      setState(() {
        users.remove(user);
      });
    }
  }

  void onDragUpdate(DragUpdateDetails details) {

    if(saveToFirstDragPosition==true){
      setState(() {
        firstDragPosition=details.localPosition.dx;
        saveToFirstDragPosition=false;
      });
    }
    var swipeDelta=details.localPosition.dx-firstDragPosition;
    final provider=Provider.of<FeedbackPositionProvider>(context, listen: false);
    provider.updateSwipeDelta(swipeDelta);
  }


}
