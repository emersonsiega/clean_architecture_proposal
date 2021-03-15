import 'package:flutter/material.dart';

import '../../../dependency_management/dependency_management.dart';
import '../../../ui/ui.dart';

class SearchButton extends StatelessWidget {
  final presenter = Get.i().get<LyricsSearchPresenter>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: presenter.isFormValidStream,
      initialData: false,
      builder: (context, isFormValid) {
        return StreamBuilder<bool>(
          stream: presenter.isLoadingStream,
          initialData: false,
          builder: (context, isLoading) {
            return FloatingActionButton(
              child: isLoading.data == true ? Loading() : Icon(Icons.search),
              onPressed: isFormValid.data == true
                  ? isLoading.data == true
                      ? () {}
                      : presenter.search
                  : null,
            );
          },
        );
      },
    );
  }
}
