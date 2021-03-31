import 'dart:async';

import 'package:flutter/material.dart';

import '../../dependency_management/dependency_management.dart';
import '../../domain/domain.dart';

import '../ui.dart';

class LyricPage extends StatefulWidget {
  @override
  _LyricPageState createState() => _LyricPageState();
}

class _LyricPageState extends State<LyricPage> {
  LyricPresenter presenter = Get.i().get();
  LyricEntity _entity;
  StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = presenter.stateStream.listen((state) {
      if (state.successMessage != null) {
        showSuccessSnack(context: context, message: state.successMessage);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _entity = ModalRoute.of(context).settings.arguments;
    presenter.fireEvent(CheckFavoriteEvent(_entity));

    return Scaffold(
      appBar: AppBar(
        title: Text("${_entity.artist}"),
        actions: [
          StreamBuilder<LyricState>(
            stream: presenter.stateStream,
            builder: (context, snapshot) {
              return IconButton(
                key: Key("favoriteButton"),
                icon: snapshot.data?.isLoading == true
                    ? Loading()
                    : snapshot.data?.isFavorite == true
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                onPressed: snapshot.data?.isLoading == true
                    ? () {}
                    : () => presenter.fireEvent(AddFavoriteEvent(_entity)),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Container(
            height: 35,
            width: double.infinity,
            child: Center(
              child: Text(
                "${_entity.music}",
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
            "${_entity.lyric}",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
