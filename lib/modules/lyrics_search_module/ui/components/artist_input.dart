import 'package:flutter/material.dart';

import '../../../../shared/shared.dart';

import '../../ui/ui.dart';

class ArtistInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.i().get<LyricsSearchPresenter>();

    return StreamBuilder<String>(
      stream: presenter.artistErrorStream,
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
          onChanged: presenter.validateArtist,
        );
      },
    );
  }
}
