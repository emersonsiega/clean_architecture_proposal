abstract class GenericException implements Exception {
  String message;

  GenericException({this.message = ''});
}

class GetFullSearchError implements GenericException {
  @override
  String message;

  GetFullSearchError({this.message = ''});
}
