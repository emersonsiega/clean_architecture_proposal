import 'dart:async';

import 'package:flutter/material.dart';

import './lyrics_search_presenter.dart';

class LyricsSearchPage extends StatefulWidget {
  final LyricsSearchPresenter presenter;

  const LyricsSearchPage({
    Key key,
    @required this.presenter,
  }) : super(key: key);

  @override
  _LyricsSearchPageState createState() => _LyricsSearchPageState();
}

class _LyricsSearchPageState extends State<LyricsSearchPage> {
  StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = widget.presenter.localErrorStream.listen((error) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[900],
            content: Text(
              error,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();

    widget.presenter.dispose();

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
                StreamBuilder<String>(
                  stream: widget.presenter.artistErrorStream,
                  initialData: null,
                  builder: (context, snapshot) {
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText: "Artist",
                        hintText: "Eric Clapton",
                        prefixIcon: Icon(Icons.person),
                        errorText: snapshot.data,
                      ),
                      textInputAction: TextInputAction.none,
                      onChanged: widget.presenter.validateArtist,
                    );
                  },
                ),
                const SizedBox(height: 30),
                StreamBuilder<String>(
                  stream: widget.presenter.musicErrorStream,
                  initialData: null,
                  builder: (context, snapshot) {
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText: "Music",
                        hintText: "Tears in Heaven",
                        prefixIcon: Icon(Icons.music_note),
                        errorText: snapshot.data,
                      ),
                      textInputAction: TextInputAction.done,
                      onChanged: widget.presenter.validateMusic,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: widget.presenter.isFormValidStream,
        initialData: false,
        builder: (context, isFormValid) {
          return FloatingActionButton(
            child: StreamBuilder<bool>(
              stream: widget.presenter.isLoadingStream,
              initialData: false,
              builder: (context, isLoading) {
                if (isLoading.data == true) {
                  return CircularProgressIndicator();
                }

                return Icon(Icons.search);
              },
            ),
            onPressed:
                isFormValid.data == true ? widget.presenter.search : null,
          );
        },
      ),
    );
  }
}
