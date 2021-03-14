import 'package:flutter/material.dart';

import '../../../dependency_management/dependency_management.dart';
import '../../../ui/ui.dart';

class MusicInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.i().get<LyricsSearchPresenter>();

    return StreamBuilder<String>(
      stream: presenter.musicErrorStream,
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
          onChanged: presenter.validateMusic,
        );
      },
    );
  }
}
