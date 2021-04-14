import 'dart:async';

import 'package:flutter/material.dart';

import '../ui.dart';

mixin ErrorMessageMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription _subscription;

  void subscribeErrorMessage(Stream<ErrorMessageState> errorMessageStream) {
    _subscription = errorMessageStream.listen((state) {
      if (state.errorMessage != null) {
        showErrorSnack(context: context, error: state.errorMessage);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
