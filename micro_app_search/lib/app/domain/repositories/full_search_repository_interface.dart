import 'package:micro_app_search/app/domain/models/github_repository_model.dart';

abstract class FullSearchRepositoryInterface {
  Future<List<GitHubRepositoryModel>> getFullSearch();
}
