import 'package:micro_app_search/app/domain/exceptions/exceptions.dart';
import 'package:micro_app_search/app/domain/models/github_repository_model.dart';
import 'package:micro_app_search/app/infra/data_sources/get_full_search_data_source_interface.dart';
import 'package:micro_core/app/http_interface.dart';

class GitHubSearchDataSource implements GetFullSearchDataSourceInterface {
  String url = 'https://api.github.com/search/repositories?q=dart';

  final HttpInterface http;

  GitHubSearchDataSource(this.http);

  @override
  Future<List<GitHubRepositoryModel>> getFullSearch() async {
    try {
      final result = await http.get(url);
      if (result.statusCode == 200) {
        final jsonList = result.data['items'] as List;
        final list = jsonList.map((item) => GitHubRepositoryModel.fromJson(item)).toList();
        return list;
      }
      throw GetFullSearchError(message: 'Get call error!');
    } on Exception catch (_) {
      throw GetFullSearchError(message: 'Get call error!');
    }
  }
}
