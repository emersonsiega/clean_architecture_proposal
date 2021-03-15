import 'package:flutter/material.dart';

import '../../dependency_management/dependency_management.dart';
import '../../domain/domain.dart';

import '../ui.dart';

class LyricPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LyricEntity entity = ModalRoute.of(context).settings.arguments;
    LyricPresenter presenter = Get.i().get();

    return Scaffold(
      appBar: AppBar(
        title: Text("${entity.artist}"),
        actions: [
          IconButton(
            key: Key("favoriteButton"),
            icon: Icon(Icons.favorite_border),
            onPressed: () => presenter.addFavorite(entity),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Container(
            height: 35,
            width: double.infinity,
            child: Center(
              child: Text(
                "${entity.music}",
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            "${entity.lyric}",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
