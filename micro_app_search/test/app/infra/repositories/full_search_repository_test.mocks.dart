// Mocks generated by Mockito 5.0.5 from annotations
// in micro_app_search/test/app/infra/repositories/full_search_repository_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:micro_app_search/app/domain/models/github_repository_model.dart'
    as _i4;
import 'package:micro_app_search/app/infra/data_sources/get_full_search_data_source_interface.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [GetFullSearchDataSourceInterface].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetFullSearchDataSourceInterface extends _i1.Mock
    implements _i2.GetFullSearchDataSourceInterface {
  MockGetFullSearchDataSourceInterface() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.GitHubRepositoryModel>> getFullSearch() =>
      (super.noSuchMethod(Invocation.method(#getFullSearch, []),
              returnValue: Future<List<_i4.GitHubRepositoryModel>>.value(
                  <_i4.GitHubRepositoryModel>[]))
          as _i3.Future<List<_i4.GitHubRepositoryModel>>);
}