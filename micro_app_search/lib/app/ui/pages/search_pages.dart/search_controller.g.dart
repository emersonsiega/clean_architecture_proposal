// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SearchController on _SearchControllerBase, Store {
  Computed<bool>? _$gitHubObservableHasErrorComputed;

  @override
  bool get gitHubObservableHasError => (_$gitHubObservableHasErrorComputed ??=
          Computed<bool>(() => super.gitHubObservableHasError,
              name: '_SearchControllerBase.gitHubObservableHasError'))
      .value;
  Computed<FutureStatus>? _$gitHubObservableStatusComputed;

  @override
  FutureStatus get gitHubObservableStatus =>
      (_$gitHubObservableStatusComputed ??= Computed<FutureStatus>(
              () => super.gitHubObservableStatus,
              name: '_SearchControllerBase.gitHubObservableStatus'))
          .value;
  Computed<bool>? _$gitHubIsLoadingComputed;

  @override
  bool get gitHubIsLoading =>
      (_$gitHubIsLoadingComputed ??= Computed<bool>(() => super.gitHubIsLoading,
              name: '_SearchControllerBase.gitHubIsLoading'))
          .value;

  final _$gitHubObservableAtom =
      Atom(name: '_SearchControllerBase.gitHubObservable');

  @override
  ObservableFuture<dynamic>? get gitHubObservable {
    _$gitHubObservableAtom.reportRead();
    return super.gitHubObservable;
  }

  @override
  set gitHubObservable(ObservableFuture<dynamic>? value) {
    _$gitHubObservableAtom.reportWrite(value, super.gitHubObservable, () {
      super.gitHubObservable = value;
    });
  }

  final _$getGitHubListAsyncAction =
      AsyncAction('_SearchControllerBase.getGitHubList');

  @override
  Future<void> getGitHubList() {
    return _$getGitHubListAsyncAction.run(() => super.getGitHubList());
  }

  @override
  String toString() {
    return '''
gitHubObservable: ${gitHubObservable},
gitHubObservableHasError: ${gitHubObservableHasError},
gitHubObservableStatus: ${gitHubObservableStatus},
gitHubIsLoading: ${gitHubIsLoading}
    ''';
  }
}
