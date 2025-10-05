part of 'wallet_bloc.dart';

@immutable
sealed class WalletEvent {}

class InitialWalletEvent extends WalletEvent {}

class OnRetryEvent extends WalletEvent {}
