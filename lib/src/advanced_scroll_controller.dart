import 'package:flutter/material.dart';

class AdvancedScrollController {
  final ScrollController _controller = ScrollController();

  ScrollController get scrollController => _controller;

  bool get hasClients => _controller.hasClients;

  double get offset => _controller.hasClients ? _controller.offset : 0;

  double get maxScrollExtent =>
      _controller.hasClients ? _controller.position.maxScrollExtent : 0;

  void jumpTo(double offset) {
    if (!_controller.hasClients) return;

    _controller.jumpTo(
      offset.clamp(
        0.0,
        _controller.position.maxScrollExtent,
      ),
    );
  }

  Future<void> animateTo(double offset, {
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOutCubic,
  }) async {
    if (!_controller.hasClients) return;

    await _controller.animateTo(
      offset.clamp(
        0.0,
        _controller.position.maxScrollExtent,
      ),
      duration: duration,
      curve: curve,
    );
  }

  Future<void> scrollToTop({
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOutCubic,
  }) {
    return animateTo(
      0,
      duration: duration,
      curve: curve,
    );
  }

  Future<void> scrollToBottom({
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeOutCubic,
  }) {
    return animateTo(
      _controller.hasClients
          ? _controller.position.maxScrollExtent
          : 0,
      duration: duration,
      curve: curve,
    );
  }

  Future<void> scrollToIndex(int index, {
    double itemExtent = 60,
    Duration duration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOutCubic,
  }) {
    if (index < 0) return Future.value();

    return animateTo(
      index * itemExtent,
      duration: duration,
      curve: curve,
    );
  }

  void dispose() {
    _controller.dispose();
  }
}