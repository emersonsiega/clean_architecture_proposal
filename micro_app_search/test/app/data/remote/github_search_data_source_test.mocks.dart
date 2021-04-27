// Mocks generated by Mockito 5.0.5 from annotations
// in micro_app_search/test/app/data/remote/github_search_data_source_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:dio/src/response.dart' as _i2;
import 'package:micro_core/app/http_interface.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

class _FakeResponse<T> extends _i1.Fake implements _i2.Response<T> {}

/// A class which mocks [HttpInterface].
///
/// See the documentation for Mockito's code generation for more information.
class MockHttpInterface extends _i1.Mock implements _i3.HttpInterface {
  MockHttpInterface() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Response<dynamic>> get(String? path) =>
      (super.noSuchMethod(Invocation.method(#get, [path]),
              returnValue:
                  Future<_i2.Response<dynamic>>.value(_FakeResponse<dynamic>()))
          as _i4.Future<_i2.Response<dynamic>>);
}
