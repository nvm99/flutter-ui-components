import 'package:flutter/material.dart';

enum SwipingDirection { left, right, none }

class FeedbackPositionProvider extends ChangeNotifier {
  double _dx = 0.0;
  SwipingDirection _swipingDirection;
  double _swipeDelta;
  SwipingDirection get swipingDirection => _swipingDirection;
  double get swipeDelta=>_swipeDelta!=null?_swipeDelta:0;
  FeedbackPositionProvider() {
    _swipingDirection = SwipingDirection.none;
  }

  void resetPosition() {
    _dx = 0.0;
    _swipingDirection = SwipingDirection.none;
    _swipeDelta=0;
    notifyListeners();
  }

  void updatePosition(double changeInX) {
    _dx = _dx + changeInX;
    if (_dx > 0) {
      _swipingDirection = SwipingDirection.right;
    } else if (_dx < 0) {
      _swipingDirection = SwipingDirection.left;
    } else {
      _swipingDirection = SwipingDirection.none;
    }
    notifyListeners();
  }

  void updateSwipeDelta(double delta) {
    _swipeDelta=delta;
    notifyListeners();
  }
}
