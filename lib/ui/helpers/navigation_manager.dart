import 'package:equatable/equatable.dart';

enum NavigateType { push, pushReplacement }

class PageConfig extends Equatable {
  final String route;
  final NavigateType type;
  final Object arguments;

  PageConfig(this.route, {this.type = NavigateType.push, this.arguments});

  @override
  List<Object> get props => [route, type, arguments];
}

abstract class NavigationManager {
  Stream<PageConfig> get navigateToStream;
}
