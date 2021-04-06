import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/shared.dart';

import './data/data.dart';
import './domain/domain.dart';
import './presentation/presentation.dart';
import './ui/ui.dart';

class LyricModule extends Module {
  @override
  final List<Bind> binds = [
    Bind<SaveFavoriteLyrics>(
      (i) => LocalSaveFavoriteLyrics(
        saveLocalStorage: i.get<LocalStorageComposite>(),
      ),
    ),
    Bind<LyricPresenter>(
      (i) => CubitLyricPresenter(
        saveFavoriteLyrics: i.get<SaveFavoriteLyrics>(),
        loadFavoriteLyrics: i.get<LoadFavoriteLyrics>(),
      ),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => LyricPage(entity: args.data)),
  ];
}
