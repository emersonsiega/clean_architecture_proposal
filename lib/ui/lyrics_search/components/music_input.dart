import 'package:flutter/material.dart';

import '../../../dependency_management/dependency_management.dart';
import '../../../ui/ui.dart';

class MusicInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.i().get<LyricsSearchPresenter>();

    return StreamBuilder<LyricsSearchState>(
      stream: presenter.stateStream,
      initialData: null,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: "Music",
            hintText: "Tears in Heaven",
            prefixIcon: Icon(Icons.music_note),
            errorText: snapshot.data?.musicError,
          ),
          textInputAction: TextInputAction.done,
          onChanged: (music) => presenter.fireEvent(
            ValidateMusicEvent(music),
          ),
        );
      },
    );
  }
}
