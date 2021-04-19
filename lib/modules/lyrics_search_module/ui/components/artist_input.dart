import 'package:flutter/material.dart';

import '../../../../shared/shared.dart';

import '../../ui/ui.dart';

class ArtistInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.i().get<LyricsSearchPresenter>();

    return StreamBuilder<LyricsSearchState>(
      stream: presenter.stateStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: "Artist",
            hintText: "Eric Clapton",
            prefixIcon: Icon(Icons.person),
            errorText: snapshot.data?.form?.error(LyricsSearchFields.artist),
          ),
          textInputAction: TextInputAction.next,
          onChanged: (value) =>
              presenter.validate(LyricsSearchFields.artist, value),
        );
      },
    );
  }
}
