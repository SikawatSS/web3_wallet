/// Mock data fixtures for Balance-related tests
class BalanceFixture {
  /// Valid API response for ETH balance
  static Map<String, dynamic> validBalanceResponse() {
    return {
      'status': '1',
      'message': 'OK',
      'result': '1000000000000000000', // 1 ETH in Wei
    };
  }

  /// Zero balance response
  static Map<String, dynamic> zeroBalanceResponse() {
    return {
      'status': '1',
      'message': 'OK',
      'result': '0',
    };
  }

  /// Very large balance response (1000 ETH)
  static Map<String, dynamic> largeBalanceResponse() {
    return {
      'status': '1',
      'message': 'OK',
      'result': '1000000000000000000000', // 1000 ETH in Wei
    };
  }

  /// Invalid response (missing result field)
  static Map<String, dynamic> missingResultResponse() {
    return {
      'status': '1',
      'message': 'OK',
    };
  }

  /// Invalid response (wrong type)
  static Map<String, dynamic> invalidTypeResponse() {
    return {
      'status': '1',
      'message': 'OK',
      'result': 123, // Should be String
    };
  }

  /// API error response
  static Map<String, dynamic> errorResponse() {
    return {
      'status': '0',
      'message': 'NOTOK',
      'result': 'Error! Invalid address format',
    };
  }
}
