import 'package:web3_wallet/domain/entities/token_balance.dart';

class TokenBalanceModel extends TokenBalance {
  TokenBalanceModel({
    required super.tokenName,
    required super.tokenSymbol,
    required super.tokenQuantity,
    required super.tokenDivisor,
    super.contractAddress,
  });

  factory TokenBalanceModel.fromJson(Map<String, dynamic> json) {
    return TokenBalanceModel(
      tokenName: json['TokenName'] as String,
      tokenSymbol: json['TokenSymbol'] as String,
      tokenQuantity: json['TokenQuantity'] as String,
      tokenDivisor: json['TokenDivisor'] as String,
      contractAddress: json['ContractAddress'] as String?,
    );
  }
}
