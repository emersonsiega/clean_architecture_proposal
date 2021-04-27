import 'package:micro_app_search/app/infra/data_sources/get_full_search_data_source_interface.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
part 'search_controller.g.dart';

@Injectable()
class SearchController = _SearchControllerBase with _$SearchController;

abstract class _SearchControllerBase with Store {
  final GetFullSearchDataSourceInterface getFullSearchUseCase;

  _SearchControllerBase(this.getFullSearchUseCase);

  @observable
  ObservableFuture? gitHubObservable;

  @computed
  bool get gitHubObservableHasError => gitHubObservable?.error != null;

  @computed
  FutureStatus get gitHubObservableStatus => gitHubObservable!.status;

  @computed
  bool get gitHubIsLoading => gitHubObservableStatus == FutureStatus.pending && !gitHubObservableHasError;

  @action
  Future<void> getGitHubList() async {
    gitHubObservable = getFullSearchUseCase.getFullSearch().asObservable();
  }

  void navigateToAboutPage() => Modular.to.pushNamed('/about');
}
