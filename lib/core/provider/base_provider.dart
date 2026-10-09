import 'package:flutter/foundation.dart';

abstract class BaseProvider<T> extends ChangeNotifier {
  @protected
  abstract T backedState;

  @protected
  void setState(T state) {
    backedState = state;
    notifyListeners();
  }

}