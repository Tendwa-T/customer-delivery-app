sealed class AppFailure {
  const AppFailure({required this.message});
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class DatabaseFailure extends AppFailure {
  const DatabaseFailure({
    super.message = 'A database error occured. Please try again.',
    this.cause,
  });

  final String? cause;
}

class RecordNotFound extends AppFailure {
  const RecordNotFound({
    super.message = "Couldn't fetch Delivery",
    required this.id,
  });

  final int id;
}

class EditNotAllowed extends AppFailure {
  const EditNotAllowed({required this.statusLabel})
    : super(message: 'This request cannot be modified: status "$statusLabel"');
  final String statusLabel;
}

class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure({super.message = 'Something went wrong', this.cause});

  final String? cause;
}
