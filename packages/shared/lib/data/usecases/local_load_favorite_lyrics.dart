import 'dart:convert';

import 'package:meta/meta.dart';

import '../../data/data.dart';
import '../../domain/domain.dart';

class LocalLoadFavoriteLyrics implements LoadFavoriteLyrics {
  final LoadLocalStorage loadLocalStorage;

  LocalLoadFavoriteLyrics({@required this.loadLocalStorage});

  @override
  Future<List<LyricEntity>> loadFavorites() async {
    try {
      final favorites = await loadLocalStorage.load('favorites');

      if (favorites?.isNotEmpty == true) {
        List favoriteMapList = jsonDecode(favorites);

        return favoriteMapList
            .map((entity) => LocalLyricModel.fromMap(entity).toEntity())
            .toList();
      }

      return null;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
