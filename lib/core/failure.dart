class Failure {
  final String message;
  final int code;

  Failure({required this.message, required this.code});

  @override
  String toString() => 'Failure(message: $message, code: $code)';

  Map<String, dynamic> toJson() {
    return {
      'failure': {'message': message, 'code': code},
    };
  }
}
