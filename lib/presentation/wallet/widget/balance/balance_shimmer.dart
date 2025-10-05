import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web3_wallet/util/colors.dart';
import 'package:web3_wallet/util/extention/locale_extension.dart';

class BalanceShimmer extends StatelessWidget {
  const BalanceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.estTotalValue),
          const SizedBox(height: 8),
          Shimmer.fromColors(
            baseColor: AppColors.black,
            highlightColor: AppColors.darkGrey,
            child: Container(
              height: 48,
              width: 144,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
