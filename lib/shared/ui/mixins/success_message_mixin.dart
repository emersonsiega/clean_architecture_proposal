import 'dart:async';

import 'package:flutter/material.dart';

import '../ui.dart';

mixin SuccessMessageMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription _subscription;

  void subscribeSuccessMessage(Stream<SuccessMessageState> success) {
    _subscription = success.listen((state) {
      if (state.message != null) {
        showSuccessSnack(context: context, message: state.message);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
