import 'package:flutter/material.dart';

import '../../../dependency_management/dependency_management.dart';
import '../../../ui/ui.dart';

class ArtistInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.i().get<LyricsSearchPresenter>();

    return StreamBuilder<LyricsSearchState>(
      stream: presenter.stateStream,
      initialData: null,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: "Artist",
            hintText: "Eric Clapton",
            prefixIcon: Icon(Icons.person),
            errorText: snapshot.data?.artistError,
          ),
          textInputAction: TextInputAction.none,
          onChanged: (artist) {
            presenter.fireEvent(ValidateArtistEvent(artist));
          },
        );
      },
    );
  }
}
