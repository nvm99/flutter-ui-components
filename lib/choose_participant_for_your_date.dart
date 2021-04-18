import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChooseParticipantForYourDate extends StatefulWidget {
  @override
  _ChooseParticipantForYourDateState createState() =>
      _ChooseParticipantForYourDateState();
}

class _ChooseParticipantForYourDateState
    extends State<ChooseParticipantForYourDate> {
  // theo dõi chuyển động kéo thả
  var isDragging = false; // đang kéo
  var draggingIndex; // index của item đang kéo
  var globalDraggingDelta; // vị trí item lúc thả so với lúc bắt đầu kéo
  var startDraggingPosition; // vị trí item lúc bắt đầu kéo
  final _users = [];

  Widget buildPlaceholder(index) {
    var placeHolderText = '';
    var placeHolderImage = '';
    switch (index) {
      case 0:
        placeHolderText = 'Ưu tiên hàng đầu';
        placeHolderImage = 'firstChoice.png';
        break;
      case 1:
        placeHolderText = 'Lựa chọn thứ hai';
        placeHolderImage = 'secondChoice.png';
        break;
      case 2:
        placeHolderText = 'Lựa chọn thứ ba';
        placeHolderImage = 'thirdChoice.png';
        break;
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/$placeHolderImage',
              width: 50,
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(placeHolderText),
                Text('Vui lòng chọn ra người bạn muốn hẹn'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildParticipant(data, index) {
    var participantFrame = '';
    switch (index) {
      case 0:
        participantFrame = 'firstFrame.png';
        break;
      case 1:
        participantFrame = 'secondFrame.png';
        break;
      case 2:
        participantFrame = 'thirdFrame.png';
        break;
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            height: 60,
            child: Stack(alignment: Alignment.center, children: [
              AnimatedOpacity(
                opacity: isDragging ? 0.0 : 1.0,
                duration: Duration(milliseconds: 500),
                child: Image.asset(
                  'assets/$participantFrame',
                  width: 50,
                ),
              ),
              Image.asset(
                'assets/avatar.png',
                width: 40,
              ),
              Positioned(
                top: 0,
                child: AnimatedOpacity(
                  opacity: index == 0 && isDragging == false ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: Image.asset(
                    'assets/crown.png',
                    width: 20,
                  ),
                ),
              ),
            ]),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${data['name']}'),
              Text('${data['job']} - ${data['age']}'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Lựa chọn đi hẹn của bạn'),
              TextButton(
                onPressed: () {},
                child: Text("Chỉnh sửa"),
              ),
            ],
          ),
          Stack(children: [
            Container(
              height: 250,
              child: Column(
                children: <Widget>[
                  for (int index = 0; index < 3; index++)
                    buildPlaceholder(index),
                ],
              ),
            ),
            Container(
              height: 250,
              child: ReorderableListView(
                physics: NeverScrollableScrollPhysics(),
                buildDefaultDragHandles: false,
                children: <Widget>[
                  for (int index = 0; index < _users.length; index++)
                    Container(
                      key: Key('$index'),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Listener(
                        onPointerDown: (event) {
                          setState(() {
                            draggingIndex = index;
                          });
                        },
                        onPointerMove: (event) {
                          setState(() {
                            if (startDraggingPosition == null) {
                              startDraggingPosition = event.position.dy;
                            }
                            globalDraggingDelta =
                                event.position.dy - startDraggingPosition;
                            if (isDragging == false) {
                              isDragging = true;
                            }
                          });
                        },
                        onPointerUp: (event) {
                          setState(() {
                            if (draggingIndex == _users.length - 1 &&
                                globalDraggingDelta > 0) {
                              isDragging = false;
                            }
                            startDraggingPosition=null;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildParticipant(_users[index], index),
                              ReorderableDragStartListener(
                                index: index,
                                child: Icon(Icons.drag_handle),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    if (isDragging = true) {
                      isDragging = false;
                    }
                    final item = _users.removeAt(oldIndex);
                    _users.insert(newIndex, item);
                  });
                },
              ),
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: _users.length >= 3
                      ? null
                      : () {
                          setState(() {
                            if (_users.length < 3) {
                              _users.add({
                                'name': 'Jonathan',
                                'job': 'Bác sĩ',
                                'age': 21,
                              });
                            }
                          });
                        },
                  child: Text("Thêm người")),
              SizedBox(
                width: 50,
              ),
              ElevatedButton(
                  onPressed: !_users.isNotEmpty
                      ? null
                      : () {
                          setState(() {
                            if (_users.isNotEmpty) {
                              _users.removeLast();
                            }
                          });
                        },
                  child: Text('Xóa người')),
            ],
          )
        ],
      ),
    );
  }
}
