import 'package:flutter/material.dart';

import '../../../dependency_management/dependency_management.dart';
import '../../../ui/ui.dart';

class SearchButton extends StatelessWidget {
  final presenter = Get.i().get<LyricsSearchPresenter>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LyricsSearchState>(
      stream: presenter.stateStream,
      builder: (context, snapshot) {
        return FloatingActionButton(
          child:
              snapshot.data?.isLoading == true ? Loading() : Icon(Icons.search),
          backgroundColor: snapshot?.data?.isFormValid != true
              ? Colors.grey
              : Theme.of(context).accentColor,
          onPressed: snapshot.data?.isFormValid == true
              ? snapshot.data?.isLoading == true
                  ? () {}
                  : () => presenter.fireEvent(SearchLyricEvent())
              : null,
        );
      },
    );
  }
}
