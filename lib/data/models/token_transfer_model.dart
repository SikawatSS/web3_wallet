import 'package:web3_wallet/domain/entities/token_transfer.dart';

class TokenTransferModel extends TokenTransfer {
  TokenTransferModel({
    required super.blockNumber,
    required super.timeStamp,
    required super.hash,
    required super.from,
    required super.to,
    required super.value,
    required super.contractAddress,
    required super.tokenName,
    required super.tokenSymbol,
    required super.tokenDecimal,
  });

  factory TokenTransferModel.fromJson(Map<String, dynamic> json) {
    return TokenTransferModel(
      blockNumber: json['blockNumber'] as String,
      timeStamp: json['timeStamp'] as String,
      hash: json['hash'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      value: json['value'] as String,
      contractAddress: json['contractAddress'] as String,
      tokenName: json['tokenName'] as String? ?? 'Unknown',
      tokenSymbol: json['tokenSymbol'] as String? ?? 'UNKNOWN',
      tokenDecimal: json['tokenDecimal'] as String,
    );
  }
}
