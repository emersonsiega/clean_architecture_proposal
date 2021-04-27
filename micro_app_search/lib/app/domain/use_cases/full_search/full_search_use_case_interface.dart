import 'package:micro_app_search/app/domain/models/github_repository_model.dart';

abstract class FullSearchUseCaseInterface {
  Future<List<GitHubRepositoryModel>> call();
}
