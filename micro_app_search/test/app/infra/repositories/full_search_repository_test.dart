import 'package:flutter_test/flutter_test.dart';
import 'package:micro_app_search/app/domain/exceptions/exceptions.dart';
import 'package:micro_app_search/app/domain/models/github_repository_model.dart';
import 'package:micro_app_search/app/infra/data_sources/get_full_search_data_source_interface.dart';
import 'package:micro_app_search/app/infra/repositories/full_search_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'full_search_repository_test.mocks.dart';

@GenerateMocks([GetFullSearchDataSourceInterface])
void main() {
  final dataSourceMock = MockGetFullSearchDataSourceInterface();
  final repository = FullSearchRepository(dataSourceMock);

  test('Should return a list of GitHubRepositoryModel', () async {
    final repos = [GitHubRepositoryModel(), GitHubRepositoryModel(), GitHubRepositoryModel()];
    when(dataSourceMock.getFullSearch()).thenAnswer((_) async => repos);

    final result = await repository.getFullSearch();

    verify(repository.getFullSearch());
    expect(repos, result);
  });

  test('Should return a typed exception', () {
    when(dataSourceMock.getFullSearch()).thenThrow(GetFullSearchError());

    final result = repository.getFullSearch();

    verify(repository.getFullSearch());
    expect(result, throwsA(isInstanceOf<GenericException>()));
  });
}
