import 'dart:async';

import 'package:flutter/material.dart';

import '../../../shared/shared.dart';

import './components/components.dart';
import './lyrics_search_presenter.dart';

class LyricsSearchPage extends StatefulWidget {
  @override
  _LyricsSearchPageState createState() => _LyricsSearchPageState();
}

class _LyricsSearchPageState
    extends CustomState<LyricsSearchPresenter, LyricsSearchPage> {
  StreamSubscription _subscription;

  @override
  void initState() {
    presenter.loadFavorites();

    _subscription = presenter.stateStream.listen((state) {
      if (state.localError != null) {
        showErrorSnack(context: context, error: state.localError);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();

    presenter.dispose();

    super.dispose();
  }

  void _hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lyrics Search"),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: _hideKeyboard,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 32),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ArtistInput(),
                const SizedBox(height: 30),
                MusicInput(),
                const SizedBox(height: 30),
                FavoritesList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SearchButton(),
    );
  }
}
