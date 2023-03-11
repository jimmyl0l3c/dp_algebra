class CalcExpressionException implements Exception {
  final String friendlyMessage;
  final Exception cause;

  CalcExpressionException({
    required this.friendlyMessage,
    required this.cause,
  });
}
