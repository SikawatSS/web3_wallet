class TokenBalance {
  final String tokenName;
  final String tokenSymbol;
  final String tokenQuantity;
  final String tokenDivisor;
  final String? contractAddress;

  TokenBalance({
    required this.tokenName,
    required this.tokenSymbol,
    required this.tokenQuantity,
    required this.tokenDivisor,
    this.contractAddress,
  });

  double get tokenAmount {
    final quantity = BigInt.parse(tokenQuantity);
    final divisor = BigInt.parse(tokenDivisor);
    return quantity / divisor;
  }

  String toTokenString({int decimals = 4}) {
    return tokenAmount.toStringAsFixed(decimals);
  }

  @override
  String toString() => '$tokenAmount $tokenSymbol';

  Map<String, dynamic> toJson() {
    return {
      'tokenName': tokenName,
      'tokenSymbol': tokenSymbol,
      'tokenQuantity': tokenQuantity,
      'tokenDivisor': tokenDivisor,
      'tokenAmount': tokenAmount,
      'contractAddress': contractAddress,
    };
  }
}

extension TokenBalanceExtension on TokenBalance {}
