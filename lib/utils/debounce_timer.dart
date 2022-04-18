import 'dart:async';

class DebounceTimer {
  final Duration delay;
  Timer? _timer;

  DebounceTimer({this.delay = const Duration(milliseconds: 300)});

  void call(Function callback) {
    _timer?.cancel();
    _timer = Timer(delay, () => callback);
  }

  void dispose() {
    _timer?.cancel();
  }
}
