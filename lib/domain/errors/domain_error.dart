enum DomainError { invalidQuery, unexpected }

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidQuery:
        return 'Invalid query. Try again with different values.';
      default:
        return 'Something wrong happened. Please, try again!';
    }
  }
}
