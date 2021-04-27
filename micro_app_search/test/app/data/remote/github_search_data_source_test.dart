import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:micro_app_search/app/data/remote/github_search_data_source.dart';
import 'package:micro_app_search/app/domain/exceptions/exceptions.dart';
import 'package:micro_app_search/app/domain/models/github_repository_model.dart';
import 'package:micro_core/app/http_interface.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import '../../../util/github_response.dart';
import 'github_search_data_source_test.mocks.dart';

@GenerateMocks([HttpInterface])
void main() {
  final http = MockHttpInterface();
  final dataSource = GitHubSearchDataSource(http);

  test('Should return a list of GitHubRepositoryModel', () async {
    when(http.get(any)).thenAnswer((_) async =>
        Response(data: jsonDecode(gitHubResponse), statusCode: 200, requestOptions: RequestOptions(path: ':any')));

    final result = await dataSource.getFullSearch();
    expect(result, isInstanceOf<List<GitHubRepositoryModel>>());
  });

  test('Should return a typed exception', () {
    when(http.get(any)).thenThrow(GetFullSearchError());

    final result = dataSource.getFullSearch();

    expect(result, throwsA(isInstanceOf<GenericException>()));
  });
}
