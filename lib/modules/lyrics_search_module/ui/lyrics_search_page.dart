import 'package:flutter/material.dart';

import '../../../shared/shared.dart';

import './components/components.dart';
import './lyrics_search_presenter.dart';

class LyricsSearchPage extends StatefulWidget {
  @override
  _LyricsSearchPageState createState() => _LyricsSearchPageState();
}

class _LyricsSearchPageState
    extends CustomState<LyricsSearchPresenter, LyricsSearchPage>
    with NavigateToPageMixin, ErrorMessageMixin {
  @override
  void initState() {
    presenter.loadFavorites();

    subscribeErrorMessage(presenter.stateStream);

    subscribeNavigation(presenter.stateStream);

    super.initState();
  }

  void _hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpened = MediaQuery.of(context).viewInsets.bottom > 100.0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Lyrics Search"),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: _hideKeyboard,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 16,
              ),
              child: Form(
                child: Column(
                  children: [
                    ArtistInput(),
                    const SizedBox(height: 30),
                    MusicInput(),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: !isKeyboardOpened,
              maintainState: true,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FavoritesList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SearchButton(),
    );
  }
}
