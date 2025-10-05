import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3_wallet/core/di.dart';
import 'package:web3_wallet/presentation/wallet/bloc/wallet/wallet_bloc.dart';
import 'package:web3_wallet/presentation/wallet/widget/balance/balance_amount.dart';
import 'package:web3_wallet/presentation/wallet/widget/balance/balance_shimmer.dart';
import 'package:web3_wallet/presentation/wallet/widget/token/tokens_shimmer.dart';
import 'package:web3_wallet/presentation/wallet/widget/token/wallet_tokens.dart';
import 'package:web3_wallet/presentation/wallet/widget/wallet_address.dart';
import 'package:web3_wallet/presentation/wallet/widget/wallet_appbar.dart';
import 'package:web3_wallet/util/extention/locale_extension.dart';
import 'package:web3_wallet/util/widgets/custom_toast.dart';

class WalletLandingPage extends StatefulWidget {
  const WalletLandingPage({super.key});

  @override
  State<WalletLandingPage> createState() => _WalletLandingPageState();
}

class _WalletLandingPageState extends State<WalletLandingPage> {
  late final WalletBloc _walletBloc;

  @override
  void initState() {
    super.initState();

    _walletBloc = WalletBloc(
      getBalanceUseCase: getIt.get(),
      getCachedBalanceUseCase: getIt.get(),
      getTokenBalancesUseCase: getIt.get(),
      getCachedTokenBalancesUseCase: getIt.get(),
      address: dotenv.env['ADDRESS']!,
    );
    _walletBloc.add(InitialWalletEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //AppBar
          const WalletAppbar(),
          //Address
          BlocConsumer<WalletBloc, WalletState>(
            bloc: _walletBloc,
            listener: (context, state) {},
            buildWhen: (previous, current) => current is UpdateAddressState,
            builder: (context, state) {
              if (state is UpdateAddressState) {
                return WalletAddress(address: state.address);
              }

              return const SizedBox.shrink();
            },
          ),
          //ETH Balance
          BlocConsumer<WalletBloc, WalletState>(
            bloc: _walletBloc,
            listener: (context, state) {},
            buildWhen: (previous, current) =>
                current is UpdateBalanceState ||
                current is BalanceErrorState ||
                current is BalanceLoadingState,
            builder: (context, state) {
              if (state is BalanceLoadingState) {
                return const BalanceShimmer();
              }

              if (state is BalanceErrorState) {
                return const BalanceShimmer();
              }

              if (state is UpdateBalanceState) {
                return BalanceAmount(balance: state.balance);
              }

              return const SizedBox.shrink();
            },
          ),
          //Token Balance
          BlocConsumer<WalletBloc, WalletState>(
            bloc: _walletBloc,
            listener: (context, state) {
              if (state is TokenBalancesErrorState ||
                  state is BalanceErrorState) {
                AppToast.showError(
                  context,
                  message: context.l10n.unknownErrorDescription,
                  duration: Duration.zero,
                  onPress: () {
                    _walletBloc.add(OnRetryEvent());
                  },
                );
              }
            },
            buildWhen: (previous, current) =>
                current is UpdateTokenBalancesState ||
                current is TokenBalancesErrorState ||
                current is TokenBalancesLoadingState,
            builder: (context, state) {
              if (state is TokenBalancesLoadingState) {
                return const Expanded(child: TokensShimmer());
              }

              if (state is TokenBalancesErrorState) {
                return const Expanded(child: TokensShimmer());
              }

              if (state is UpdateTokenBalancesState) {
                return WalletTokens(coins: state.tokenBalances);
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
