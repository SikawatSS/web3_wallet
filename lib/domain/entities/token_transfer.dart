class TokenTransfer {
  final String blockNumber;
  final String timeStamp;
  final String hash;
  final String from;
  final String to;
  final String value;
  final String contractAddress;
  final String tokenName;
  final String tokenSymbol;
  final String tokenDecimal;

  TokenTransfer({
    required this.blockNumber,
    required this.timeStamp,
    required this.hash,
    required this.from,
    required this.to,
    required this.value,
    required this.contractAddress,
    required this.tokenName,
    required this.tokenSymbol,
    required this.tokenDecimal,
  });

  Map<String, dynamic> toJson() {
    return {
      'blockNumber': blockNumber,
      'timeStamp': timeStamp,
      'hash': hash,
      'from': from,
      'to': to,
      'value': value,
      'contractAddress': contractAddress,
      'tokenName': tokenName,
      'tokenSymbol': tokenSymbol,
      'tokenDecimal': tokenDecimal,
    };
  }
}
