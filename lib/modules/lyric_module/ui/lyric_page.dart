import 'package:flutter/material.dart';

import '../../../shared/shared.dart';

import './lyric_presenter.dart';
import './lyric_state.dart';

class LyricPage extends StatefulWidget {
  final LyricEntity entity;

  const LyricPage({Key key, @required this.entity}) : super(key: key);

  @override
  _LyricPageState createState() => _LyricPageState();
}

class _LyricPageState extends CustomState<LyricPresenter, LyricPage>
    with SuccessMessageMixin {
  @override
  void initState() {
    subscribeSuccessMessage(presenter.stateStream);

    presenter.checkIsFavorite(widget.entity);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.entity.artist}"),
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
                    : () => presenter.addFavorite(widget.entity),
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
