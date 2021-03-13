import 'package:meta/meta.dart';

import '../../domain/domain.dart';

import '../data.dart';

class RemoteLyricsSearch implements LyricsSearch {
  final HttpClient httpClient;
  final String url;

  RemoteLyricsSearch({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> search(LyricsSearchParams params) async {
    try {
      final lyricsRequest = "$url/${params.toUrlString()}";

      await httpClient.request(url: lyricsRequest);
    } on HttpError catch (error) {
      if (error == HttpError.notFound) {
        throw DomainError.invalidQuery;
      }

      throw DomainError.unexpected;
    }
  }
}
