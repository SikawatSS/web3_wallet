import 'package:flutter/material.dart';
import 'package:web3_wallet/domain/entities/token_balance.dart';
import 'package:web3_wallet/util/colors.dart';

class TokenCard extends StatelessWidget {
  final TokenBalance coin;

  const TokenCard({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              coin.tokenSymbol.isNotEmpty
                  ? coin.tokenSymbol[0].toUpperCase()
                  : '?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      coin.tokenSymbol,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Text(
                    coin.tokenAmount.toStringAsFixed(4),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
              Text(
                coin.tokenName,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.lightGrey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
