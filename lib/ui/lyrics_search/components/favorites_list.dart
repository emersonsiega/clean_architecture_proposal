import 'package:flutter/material.dart';

import '../../../dependency_management/get_dependency_manager/get_dependency_manager.dart';
import '../../../domain/domain.dart';

import '../../ui.dart';

class FavoritesList extends StatelessWidget {
  final presenter = Get.i().get<LyricsSearchPresenter>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LyricEntity>>(
      stream: presenter.favoritesStream,
      builder: (context, snapshot) {
        final favorites = snapshot?.data ?? [];

        if (favorites.isNotEmpty) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Favorites",
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 16),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: favorites
                    .map(
                      (favorite) => _FavoriteListTile(favorite: favorite),
                    )
                    .toList(),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }
}

class _FavoriteListTile extends StatelessWidget {
  final LyricEntity favorite;
  final presenter = Get.i().get<LyricsSearchPresenter>();

  _FavoriteListTile({Key key, @required this.favorite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key("${favorite.id}"),
      leading: Icon(Icons.music_note),
      title: Text("${favorite.artist} - ${favorite.music}"),
      onTap: () => presenter.openFavorite(favorite),
    );
  }
}
