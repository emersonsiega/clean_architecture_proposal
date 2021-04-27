import 'package:flutter_modular/flutter_modular.dart';
import 'package:micro_app_search/app/data/remote/github_search_data_source.dart';
import 'package:micro_app_search/app/domain/repositories/full_search_repository_interface.dart';
import 'package:micro_app_search/app/domain/use_cases/full_search/full_search_use_case.dart';
import 'package:micro_app_search/app/domain/use_cases/full_search/full_search_use_case_interface.dart';
import 'package:micro_app_search/app/infra/repositories/full_search_repository.dart';
import 'package:micro_app_search/app/ui/pages/search_pages.dart/search_controller.dart';
import 'package:micro_app_search/app/ui/pages/search_pages.dart/search_page.dart';
import 'package:micro_core/app/http.dart';

import 'app/infra/data_sources/get_full_search_data_source_interface.dart';

class MicroAppSearchModule extends Module {
  @override
  //ignore:overridden_fields
  final List<Bind> binds = [
    Bind((i) => SearchController(i())),
    Bind<FullSearchUseCaseInterface>((i) => FullSearchUseCase(i())),
    Bind<FullSearchRepositoryInterface>((i) => FullSearchRepository(i())),
    Bind<GetFullSearchDataSourceInterface>((i) => GitHubSearchDataSource(i())),
    Bind((i) => Http()),
  ];

  @override
  //ignore:overridden_fields
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => SearchPage()),
  ];
}
