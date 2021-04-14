import 'dart:async';

import 'package:flutter/material.dart';
import '../navigation/navigation.dart';

import '../ui.dart';

mixin NavigateToPageMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription _subscription;

  void subscribeNavigation(Stream<NavigationState> navigationStream) {
    _subscription = navigationStream.listen((state) async {
      if (state.navigateTo != null) {
        final page = state.navigateTo;

        if (state.navigateTo.type == NavigateType.push) {
          await Nav.pushNamed(page.route, arguments: page.arguments);
        } else {
          await Nav.pushReplacementNamed(page.route, arguments: page.arguments);
        }

        if (page.whenComplete != null) {
          page.whenComplete();
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
