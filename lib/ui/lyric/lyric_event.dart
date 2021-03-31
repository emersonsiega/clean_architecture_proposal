import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

abstract class LyricEvent {}

class AddFavoriteEvent extends Equatable implements LyricEvent {
  final LyricEntity entity;

  AddFavoriteEvent(this.entity);

  @override
  List<Object> get props => [entity];
}

class CheckFavoriteEvent extends Equatable implements LyricEvent {
  final LyricEntity entity;

  CheckFavoriteEvent(this.entity);

  @override
  List<Object> get props => [entity];
}
