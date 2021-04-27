import 'package:micro_app_search/app/domain/models/github_repository_model.dart';
import 'package:micro_app_search/app/domain/repositories/full_search_repository_interface.dart';
import 'package:micro_app_search/app/infra/data_sources/get_full_search_data_source_interface.dart';

class FullSearchRepository implements FullSearchRepositoryInterface {
  final GetFullSearchDataSourceInterface dataSource;

  FullSearchRepository(this.dataSource);

  @override
  Future<List<GitHubRepositoryModel>> getFullSearch() async => dataSource.getFullSearch();
}
