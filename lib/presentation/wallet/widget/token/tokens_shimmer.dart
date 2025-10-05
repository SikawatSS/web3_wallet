import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web3_wallet/util/colors.dart';
import 'package:web3_wallet/util/extention/locale_extension.dart';

class TokensShimmer extends StatelessWidget {
  const TokensShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            itemCount: 10,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.fromLTRB(24, index == 0 ? 8 : 16, 24, 16),
                child: Row(
                  spacing: 16,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.black,
                      highlightColor: AppColors.darkGrey,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Shimmer.fromColors(
                                baseColor: AppColors.black,
                                highlightColor: AppColors.darkGrey,
                                child: Container(
                                  height: 18,
                                  width: 56,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: AppColors.black,
                                highlightColor: AppColors.darkGrey,
                                child: Container(
                                  height: 18,
                                  width: 72,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Shimmer.fromColors(
                            baseColor: AppColors.black,
                            highlightColor: AppColors.darkGrey,
                            child: Container(
                              height: 16,
                              width: 120,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
    );
  }
}
