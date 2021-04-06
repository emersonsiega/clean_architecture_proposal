import 'dart:async';

import 'package:flutter/material.dart';
import '../navigation/navigation.dart';

import '../../ui/ui.dart';

mixin NavigateToPageMixin<T extends StatefulWidget> on State<T> {
  Stream<BaseState> navigationStream;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = navigationStream
        .map((state) => state.navigateTo)
        .listen((PageConfig page) async {
      if (page != null) {
        if (page.type == NavigateType.push) {
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
    super.dispose();
    _subscription?.cancel();
  }
}
