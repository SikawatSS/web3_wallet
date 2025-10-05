part of 'wallet_bloc.dart';

@immutable
sealed class WalletState {}

final class WalletInitial extends WalletState {}

class BalanceLoadingState extends WalletState {
  BalanceLoadingState();
}

class UpdateBalanceState extends WalletState {
  final Balance balance;
  final bool isFromCache;

  UpdateBalanceState({required this.balance, this.isFromCache = false});
}

class BalanceErrorState extends WalletState {
  final Failure failure;

  BalanceErrorState({required this.failure});
}

class TokenBalancesLoadingState extends WalletState {
  TokenBalancesLoadingState();
}

class UpdateTokenBalancesState extends WalletState {
  final List<TokenBalance> tokenBalances;
  final bool isFromCache;

  UpdateTokenBalancesState({
    required this.tokenBalances,
    this.isFromCache = false,
  });
}

class TokenBalancesErrorState extends WalletState {
  final Failure failure;

  TokenBalancesErrorState({required this.failure});
}

class UpdateAddressState extends WalletState {
  final String address;

  UpdateAddressState({required this.address});
}
