import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'provider/feedback_position_provider.dart';
import 'model/user.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class UserCardWidget extends StatelessWidget {
  final User user;
  final bool isUserInFocus;

  const UserCardWidget({
    @required this.user,
    @required this.isUserInFocus,
    Key key,
  }) : super(key: key);

  // đặt giới hạn trên cho phép tính
  double upperLimit(result, limit) {
    return result < limit ? result : limit;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<FeedbackPositionProvider>(context);
    final swipingDirection = provider.swipingDirection;
    final focusHeightRatio = 0.7;
    final focusWidthRatio = 0.9;
    final unfocusedHeightRatio = 0.6;
    final unfocusedWidthRatio = 0.8;
    // chuyển cử động swipe (từ provider) thành các animation
    var rotateInterpolate = pi / 180.0 * provider.swipeDelta / 10;
    var heightInterpolate = size.height *
        upperLimit(provider.swipeDelta.abs() / 3000,
            focusHeightRatio - unfocusedHeightRatio);
    var widthInterpolate = size.width *
        upperLimit(provider.swipeDelta.abs() / 3000,
            focusWidthRatio - unfocusedWidthRatio);
    return Transform.rotate(
      angle: isUserInFocus ? rotateInterpolate : 0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        height: isUserInFocus
            ? size.height * focusHeightRatio
            : size.height * unfocusedHeightRatio + heightInterpolate,
        width: isUserInFocus
            ? size.width * focusWidthRatio
            : size.width * unfocusedWidthRatio + widthInterpolate,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(user.imgUrl),
              fit: BoxFit.cover,
            )),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.black12, spreadRadius: 0.5),
            ],
            gradient: LinearGradient(
              colors: [Colors.black12, Colors.black87],
              begin: Alignment.center,
              stops: [0.4, 1],
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 10,
                left: 10,
                bottom: 10,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildUserInfo(user: user),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16, right: 8),
                      child: Icon(Icons.info, color: Colors.white),
                    ),
                  ],
                ),
              ),
              if (isUserInFocus) buildLikeBadge(swipingDirection)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserInfo({@required User user}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${user.name}, ${user.age}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          Text(
            user.designation,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            '${user.mutualFriends} Mutual Friends',
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget buildLikeBadge(SwipingDirection swipingDirection) {
    final isSwipingRight = swipingDirection == SwipingDirection.right;
    final color = isSwipingRight ? Colors.green : Colors.pink;
    final angle = isSwipingRight ? -0.5 : 0.5;

    if (swipingDirection == SwipingDirection.none) {
      return Container();
    } else {
      return Positioned(
        top: 20,
        right: isSwipingRight ? null : 20,
        left: isSwipingRight ? 20 : null,
        child: Transform.rotate(
          angle: angle,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 2),
            ),
            child: Text(
              isSwipingRight ? 'LIKE' : 'NOPE',
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }
}
