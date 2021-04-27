import 'package:micro_app_search/app/domain/models/github_repository_model.dart';
import 'package:micro_app_search/app/domain/repositories/full_search_repository_interface.dart';

import 'full_search_use_case_interface.dart';

class FullSearchUseCase implements FullSearchUseCaseInterface {
  final FullSearchRepositoryInterface repository;

  FullSearchUseCase(this.repository);

  @override
  Future<List<GitHubRepositoryModel>> call() => repository.getFullSearch();
}
