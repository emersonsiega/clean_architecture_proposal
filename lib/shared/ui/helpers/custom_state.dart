import 'package:flutter/widgets.dart';

import '../../shared.dart';

abstract class CustomState<P extends BasePresenter, T extends StatefulWidget>
    extends State<T> {
  P get presenter => Get.i().get<P>();
}
