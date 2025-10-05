import 'package:flutter/material.dart';
import 'package:web3_wallet/util/colors.dart';
import 'package:web3_wallet/util/extention/locale_extension.dart';

class WalletAppbar extends StatelessWidget {
  const WalletAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text(
            context.l10n.overview,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 24),
          ),
          centerTitle: false,
          titleSpacing: 24,
          automaticallyImplyLeading: false,
        ),
        const Divider(height: 1, color: AppColors.lightGrey),
        const SizedBox(height: 24),
      ],
    );
  }
}
