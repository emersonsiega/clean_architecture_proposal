import 'package:equatable/equatable.dart';

enum NavigateType { push, pushReplacement }

class PageConfig extends Equatable {
  final String route;
  final NavigateType type;
  final Object arguments;
  final void Function() whenComplete;

  PageConfig(
    this.route, {
    this.type = NavigateType.push,
    this.arguments,
    this.whenComplete,
  });

  @override
  List<Object> get props => [route, type, arguments, whenComplete];
}
