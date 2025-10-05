import 'package:flutter/material.dart';
import 'package:web3_wallet/domain/entities/balance.dart';
import 'package:web3_wallet/util/extention/locale_extension.dart';

class BalanceAmount extends StatelessWidget {
  final Balance balance;

  const BalanceAmount({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.estTotalValue),
          const SizedBox(height: 8),
          Text(
            '${balance.toEthString} ${context.l10n.eth}',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontSize: 40),
          ),
          Text(
            '≈ ${balance.toUsdtString} ${context.l10n.usdt}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
