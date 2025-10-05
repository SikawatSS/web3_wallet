import 'package:flutter/material.dart';
import 'package:web3_wallet/domain/entities/token_balance.dart';
import 'package:web3_wallet/presentation/wallet/widget/token/token_card.dart';
import 'package:web3_wallet/util/colors.dart';
import 'package:web3_wallet/util/extention/locale_extension.dart';

class WalletTokens extends StatefulWidget {
  final List<TokenBalance> coins;

  const WalletTokens({super.key, required this.coins});

  @override
  State<WalletTokens> createState() => _WalletTokensState();
}

class _WalletTokensState extends State<WalletTokens> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Text(
                  context.l10n.crypto,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -4,
                  child: Container(
                    decoration: const BoxDecoration(color: AppColors.orange),
                    height: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: widget.coins.length,
              itemBuilder: (context, index) {
                final currentItem = widget.coins[index];

                return Padding(
                  padding: EdgeInsets.fromLTRB(24, index == 0 ? 8 : 16, 24, 16),
                  child: TokenCard(
                    key: ValueKey(currentItem.contractAddress),
                    coin: currentItem,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Divider(height: 1, color: AppColors.black),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
