import 'package:flutter/foundation.dart';

abstract class BaseProvider<T> extends ChangeNotifier {
  @protected
  abstract T backedState;
  bool _disposed = false;

  @protected
  void setState(T state) {
    if (_disposed) return;
    backedState = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
