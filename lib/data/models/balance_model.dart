import 'package:web3_wallet/domain/entities/balance.dart';

class BalanceModel extends Balance {
  BalanceModel({required super.weiAmount});

  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    return BalanceModel(weiAmount: BigInt.parse(json['result'] as String));
  }
}
