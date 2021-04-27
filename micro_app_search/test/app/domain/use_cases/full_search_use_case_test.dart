import 'package:flutter_test/flutter_test.dart';
import 'package:micro_app_search/app/domain/models/github_repository_model.dart';
import 'package:micro_app_search/app/domain/repositories/full_search_repository_interface.dart';
import 'package:micro_app_search/app/domain/use_cases/full_search/full_search_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'full_search_use_case_test.mocks.dart';

@GenerateMocks([FullSearchRepositoryInterface])
void main() {
  final repositoryMock = MockFullSearchRepositoryInterface();
  final useCase = FullSearchUseCase(repositoryMock);

  test('Execute should call get method', () async {
    final repos = [GitHubRepositoryModel(), GitHubRepositoryModel(), GitHubRepositoryModel()];
    when(repositoryMock.getFullSearch()).thenAnswer((_) async => repos);

    final result = await useCase();

    verify(repositoryMock.getFullSearch());
    expect(repos, result);
  });
}
