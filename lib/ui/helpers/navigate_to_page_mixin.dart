import 'dart:async';

import 'package:flutter/material.dart';

import '../../ui/ui.dart';

mixin NavigateToPageMixin<T extends StatefulWidget> on State<T> {
  Stream<PageConfig> get navigateToPageManager;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = navigateToPageManager.listen((PageConfig page) async {
      if (page != null) {
        final navigator = Navigator.of(context);

        if (page.type == NavigateType.push) {
          await navigator.pushNamed(page.route, arguments: page.arguments);
        } else {
          await navigator.pushReplacementNamed(page.route,
              arguments: page.arguments);
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
