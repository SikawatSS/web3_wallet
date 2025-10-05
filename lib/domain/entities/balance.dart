class Balance {
  final BigInt weiAmount;

  Balance({required this.weiAmount});

  @override
  String toString() => '$weiAmount';

  Map<String, dynamic> toJson() {
    return {
      'balance': {'weiAmount': weiAmount.toString()},
    };
  }
}

extension BalanceExtension on Balance {
  double get ethAmount => weiAmount / BigInt.from(10).pow(18);

  String get toEthString => ethAmount.toStringAsFixed(4);

  String get toUsdtString {
    //ETH Pricing Update 3 Oct 2025
    const ethPrice = 4464.07;
    final usdtValue = ethAmount * ethPrice;

    return usdtValue.toStringAsFixed(2);
  }
}
