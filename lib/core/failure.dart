class Failure {
  final String message;
  final int? statusCode;

  Failure({String? message, this.statusCode}) : message = message ?? 'Whoops! Try again';

  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode)';
}