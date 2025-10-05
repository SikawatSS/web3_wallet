import 'package:flutter/material.dart';
import 'package:web3_wallet/util/extention/locale_extension.dart';

class WalletAddress extends StatelessWidget {
  final String address;

  const WalletAddress({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                context.l10n.wallet,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '${address.substring(0, 6)}...${address.substring(address.length - 4)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
