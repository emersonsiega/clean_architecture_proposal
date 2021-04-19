import 'package:flutter/material.dart';

import '../../../../shared/shared.dart';

import '../ui.dart';

class FavoritesList extends StatelessWidget {
  final presenter = Get.i().get<LyricsSearchPresenter>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LyricsSearchState>(
      stream: presenter.stateStream,
      builder: (context, snapshot) {
        final favorites = snapshot?.data?.favorites ?? [];

        if (favorites.isNotEmpty) {
          return SafeArea(
            child: ExpandableList(
              minSize: MediaQuery.of(context).size.height * 0.5,
              indicatorColor: Theme.of(context).accentColor,
              builder: (ScrollController controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, left: 10),
                      child: Text(
                        "Favorites",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: favorites.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _FavoriteListTile(favorite: favorites[index]);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
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
