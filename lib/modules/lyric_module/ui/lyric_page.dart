import 'dart:async';

import 'package:flutter/material.dart';

import '../../../shared/shared.dart';

import './lyric_presenter.dart';

class LyricPage extends StatefulWidget {
  final LyricEntity entity;

  const LyricPage({Key key, @required this.entity}) : super(key: key);

  @override
  _LyricPageState createState() => _LyricPageState();
}

class _LyricPageState extends State<LyricPage> {
  LyricPresenter presenter = Get.i().get();

  StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = presenter.successMessageStream.listen((message) {
      if (message != null) {
        showSuccessSnack(context: context, message: message);
      }
    });

    presenter.checkIsFavorite(widget.entity);

    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.entity.artist}"),
        actions: [
          StreamBuilder<bool>(
            stream: presenter.isFavoriteStream,
            initialData: false,
            builder: (context, isFavorite) {
              return StreamBuilder<bool>(
                stream: presenter.isLoadingStream,
                initialData: false,
                builder: (context, isLoading) {
                  return IconButton(
                    key: Key("favoriteButton"),
                    icon: isLoading.data
                        ? Loading()
                        : isFavorite.data
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                    onPressed: isLoading.data
                        ? () {}
                        : () => presenter.addFavorite(widget.entity),
                  );
                },
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
                "${widget.entity.music}",
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
            "${widget.entity.lyric}",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
