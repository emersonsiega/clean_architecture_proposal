import 'package:flutter/widgets.dart';

import '../../shared.dart';

abstract class CustomState<P extends BasePresenter, T extends StatefulWidget>
    extends State<T> with NavigateToPageMixin {
  P get presenter => Get.i().get<P>();

  @override
  Stream<BaseState> get navigationStream => presenter.stateStream;
}
