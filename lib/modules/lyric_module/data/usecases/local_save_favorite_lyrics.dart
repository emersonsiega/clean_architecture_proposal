import 'dart:convert';

import 'package:meta/meta.dart';

import '../../../../shared/shared.dart';

import '../../domain/domain.dart';

class LocalSaveFavoriteLyrics implements SaveFavoriteLyrics {
  final SaveLocalStorage saveLocalStorage;

  LocalSaveFavoriteLyrics({@required this.saveLocalStorage});

  @override
  Future<void> save(List<LyricEntity> entities) async {
    try {
      final localEntity = entities
          .map((entity) => LocalLyricModel.fromEntity(entity).toMap())
          .toList();

      await saveLocalStorage.save(
        key: 'favorites',
        value: jsonEncode(localEntity),
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
