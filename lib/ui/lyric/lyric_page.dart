import 'package:flutter/material.dart';

import '../../domain/domain.dart';

class LyricPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LyricEntity entity = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("${entity.artist}"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Container(
            height: 35,
            width: double.infinity,
            child: Center(
              child: Text(
                "${entity.music}",
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Text(
          "${entity.lyric}",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
