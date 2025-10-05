import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3_wallet/core/constant.dart';
import 'package:web3_wallet/core/failure.dart';
import 'package:web3_wallet/domain/entities/balance.dart';
import 'package:web3_wallet/domain/entities/token_balance.dart';
import 'package:web3_wallet/domain/usecase/balance_usecase.dart';
import 'package:web3_wallet/domain/usecase/cached_balance_usecase.dart';
import 'package:web3_wallet/domain/usecase/cached_token_balances_usecase.dart';
import 'package:web3_wallet/domain/usecase/token_balances_usecase.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetBalanceUseCase _getBalanceUseCase;
  final GetCachedBalanceUseCase _getCachedBalanceUseCase;
  final GetTokenBalancesUseCase _getTokenBalancesUseCase;
  final GetCachedTokenBalancesUseCase _getCachedTokenBalancesUseCase;
  final String address;
  final int chainId;

  WalletBloc({
    required GetBalanceUseCase getBalanceUseCase,
    required GetCachedBalanceUseCase getCachedBalanceUseCase,
    required GetTokenBalancesUseCase getTokenBalancesUseCase,
    required GetCachedTokenBalancesUseCase getCachedTokenBalancesUseCase,
    required this.address,
    this.chainId = AppConstant.SEPOLIA_CHAIN_ID,
  }) : _getBalanceUseCase = getBalanceUseCase,
       _getCachedBalanceUseCase = getCachedBalanceUseCase,
       _getTokenBalancesUseCase = getTokenBalancesUseCase,
       _getCachedTokenBalancesUseCase = getCachedTokenBalancesUseCase,
       super(WalletInitial()) {
    on<InitialWalletEvent>(_onInitialWalletEvent);
    on<OnRetryEvent>(_onRetryEvent);
  }

  FutureOr<void> _onInitialWalletEvent(
    InitialWalletEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(UpdateAddressState(address: address));

    await Future.wait([
      _getCachedBalance(emit: emit),
      _getCachedTokenBalances(emit: emit),
    ]);

    await Future.wait([
      _initBalance(emit: emit),
      _initTokenBalances(emit: emit),
    ]);
  }

  Future<void> _getCachedBalance({required Emitter<WalletState> emit}) async {
    final cachedResult = await _getCachedBalanceUseCase.call(
      address: address,
      chainId: chainId,
    );

    cachedResult.fold(
      (failure) {
        emit(BalanceLoadingState());
        debugPrint('No cached balance: ${failure.message}');
      },
      (cachedBalance) {
        emit(UpdateBalanceState(balance: cachedBalance, isFromCache: true));
        debugPrint('Cached ETH Balance: ${cachedBalance.toJson()}');
      },
    );
  }

  Future<void> _initBalance({required Emitter<WalletState> emit}) async {
    final result = await _getBalanceUseCase.call(
      address: address,
      chainId: chainId,
    );

    result.fold(
      (failure) {
        emit(BalanceErrorState(failure: failure));
        debugPrint('ETH Balance Error: ${failure.toJson()}');
      },
      (balance) {
        emit(UpdateBalanceState(balance: balance, isFromCache: false));
        debugPrint('Fresh ETH Balance: ${balance.toJson()}');
      },
    );
  }

  Future<void> _getCachedTokenBalances({
    required Emitter<WalletState> emit,
  }) async {
    final cachedResult = await _getCachedTokenBalancesUseCase.call(
      address: address,
      chainId: chainId,
    );

    cachedResult.fold(
      (failure) {
        emit(TokenBalancesLoadingState());
        debugPrint('No cached token balances: ${failure.message}');
      },
      (cachedTokenBalances) {
        emit(
          UpdateTokenBalancesState(
            tokenBalances: cachedTokenBalances,
            isFromCache: true,
          ),
        );
        debugPrint('Cached Token Balances: ${cachedTokenBalances.length}');
      },
    );
  }

  Future<void> _initTokenBalances({required Emitter<WalletState> emit}) async {
    final result = await _getTokenBalancesUseCase.call(
      address: address,
      chainId: chainId,
    );

    result.fold(
      (failure) {
        emit(TokenBalancesErrorState(failure: failure));
        debugPrint('Token Balances Error: ${failure.toJson()}');
      },
      (tokenBalances) {
        emit(
          UpdateTokenBalancesState(
            tokenBalances: tokenBalances,
            isFromCache: false,
          ),
        );
        debugPrint('Fresh Token Balances: ${tokenBalances.length}');
      },
    );
  }

  Future<void> _onRetryEvent(
    OnRetryEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(BalanceLoadingState());
    emit(TokenBalancesLoadingState());

    await Future.wait([
      _initBalance(emit: emit),
      _initTokenBalances(emit: emit),
    ]);
  }
}
