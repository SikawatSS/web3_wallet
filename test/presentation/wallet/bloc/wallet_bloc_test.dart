import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet/core/failure.dart';
import 'package:web3_wallet/domain/entities/balance.dart';
import 'package:web3_wallet/domain/entities/token_balance.dart';
import 'package:web3_wallet/presentation/wallet/bloc/wallet/wallet_bloc.dart';

import '../../../helpers/test_helper.dart';

void main() {
  late WalletBloc walletBloc;
  late MockGetBalanceUseCase mockGetBalanceUseCase;
  late MockGetCachedBalanceUseCase mockGetCachedBalanceUseCase;
  late MockGetTokenBalancesUseCase mockGetTokenBalancesUseCase;
  late MockGetCachedTokenBalancesUseCase mockGetCachedTokenBalancesUseCase;

  setUp(() {
    mockGetBalanceUseCase = MockGetBalanceUseCase();
    mockGetCachedBalanceUseCase = MockGetCachedBalanceUseCase();
    mockGetTokenBalancesUseCase = MockGetTokenBalancesUseCase();
    mockGetCachedTokenBalancesUseCase = MockGetCachedTokenBalancesUseCase();

    walletBloc = WalletBloc(
      getBalanceUseCase: mockGetBalanceUseCase,
      getCachedBalanceUseCase: mockGetCachedBalanceUseCase,
      getTokenBalancesUseCase: mockGetTokenBalancesUseCase,
      getCachedTokenBalancesUseCase: mockGetCachedTokenBalancesUseCase,
      address: '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb',
      chainId: 11155111, // Sepolia
    );
  });

  tearDown(() {
    walletBloc.close();
  });

  final testBalance = Balance(weiAmount: BigInt.parse('1000000000000000000'));
  final testTokenBalances = [
    TokenBalance(
      tokenName: 'USD Coin',
      tokenSymbol: 'USDC',
      tokenQuantity: '1000000',
      tokenDivisor: '1000000',
    ),
  ];

  group('WalletBloc - InitialWalletEvent', () {
    blocTest<WalletBloc, WalletState>(
      'should emit UpdateAddressState with correct address',
      build: () {
        when(
          () => mockGetCachedBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer(
          (_) async => Left(Failure(message: 'No cache', code: 404)),
        );

        when(
          () => mockGetCachedTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer(
          (_) async => Left(Failure(message: 'No cache', code: 404)),
        );

        when(
          () => mockGetBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testBalance));

        when(
          () => mockGetTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testTokenBalances));

        return walletBloc;
      },
      act: (bloc) => bloc.add(InitialWalletEvent()),
      expect: () => [
        isA<UpdateAddressState>().having(
          (s) => s.address,
          'address',
          '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb',
        ),
        isA<BalanceLoadingState>(),
        isA<TokenBalancesLoadingState>(),
        isA<UpdateBalanceState>(),
        isA<UpdateTokenBalancesState>(),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'should emit cached balance then fresh balance (success flow)',
      build: () {
        when(
          () => mockGetCachedBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testBalance));

        when(
          () => mockGetCachedTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer(
          (_) async => Left(Failure(message: 'No cache', code: 404)),
        );

        when(
          () => mockGetBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testBalance));

        when(
          () => mockGetTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testTokenBalances));

        return walletBloc;
      },
      act: (bloc) => bloc.add(InitialWalletEvent()),
      expect: () => [
        isA<UpdateAddressState>(),
        isA<UpdateBalanceState>().having(
          (s) => s.isFromCache,
          'isFromCache',
          true,
        ),
        isA<TokenBalancesLoadingState>(),
        isA<UpdateBalanceState>().having(
          (s) => s.isFromCache,
          'isFromCache',
          false,
        ),
        isA<UpdateTokenBalancesState>(),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'should emit cached tokens then fresh tokens (success flow)',
      build: () {
        when(
          () => mockGetCachedBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer(
          (_) async => Left(Failure(message: 'No cache', code: 404)),
        );

        when(
          () => mockGetCachedTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testTokenBalances));

        when(
          () => mockGetBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testBalance));

        when(
          () => mockGetTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testTokenBalances));

        return walletBloc;
      },
      act: (bloc) => bloc.add(InitialWalletEvent()),
      expect: () => [
        isA<UpdateAddressState>(),
        isA<BalanceLoadingState>(),
        isA<UpdateTokenBalancesState>().having(
          (s) => s.isFromCache,
          'isFromCache',
          true,
        ),
        isA<UpdateBalanceState>(),
        isA<UpdateTokenBalancesState>().having(
          (s) => s.isFromCache,
          'isFromCache',
          false,
        ),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'should emit loading state when no cache, then success',
      build: () {
        when(
          () => mockGetCachedBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer(
          (_) async => Left(Failure(message: 'No cache', code: 404)),
        );

        when(
          () => mockGetCachedTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer(
          (_) async => Left(Failure(message: 'No cache', code: 404)),
        );

        when(
          () => mockGetBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testBalance));

        when(
          () => mockGetTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testTokenBalances));

        return walletBloc;
      },
      act: (bloc) => bloc.add(InitialWalletEvent()),
      expect: () => [
        isA<UpdateAddressState>(),
        isA<BalanceLoadingState>(),
        isA<TokenBalancesLoadingState>(),
        isA<UpdateBalanceState>(),
        isA<UpdateTokenBalancesState>(),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'should emit cached data then error when API fails',
      build: () {
        final testFailure = Failure(message: 'Network error', code: 500);

        when(
          () => mockGetCachedBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testBalance));

        when(
          () => mockGetCachedTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testTokenBalances));

        when(
          () => mockGetBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Left(testFailure));

        when(
          () => mockGetTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Left(testFailure));

        return walletBloc;
      },
      act: (bloc) => bloc.add(InitialWalletEvent()),
      expect: () => [
        isA<UpdateAddressState>(),
        isA<UpdateBalanceState>().having(
          (s) => s.isFromCache,
          'isFromCache',
          true,
        ),
        isA<UpdateTokenBalancesState>().having(
          (s) => s.isFromCache,
          'isFromCache',
          true,
        ),
        isA<BalanceErrorState>(),
        isA<TokenBalancesErrorState>(),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'should emit error states when both cache and API fail',
      build: () {
        final testFailure = Failure(message: 'Network error', code: 500);

        when(
          () => mockGetCachedBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer(
          (_) async => Left(Failure(message: 'No cache', code: 404)),
        );

        when(
          () => mockGetCachedTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer(
          (_) async => Left(Failure(message: 'No cache', code: 404)),
        );

        when(
          () => mockGetBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Left(testFailure));

        when(
          () => mockGetTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Left(testFailure));

        return walletBloc;
      },
      act: (bloc) => bloc.add(InitialWalletEvent()),
      expect: () => [
        isA<UpdateAddressState>(),
        isA<BalanceLoadingState>(),
        isA<TokenBalancesLoadingState>(),
        isA<BalanceErrorState>().having(
          (s) => s.failure.message,
          'message',
          'Network error',
        ),
        isA<TokenBalancesErrorState>().having(
          (s) => s.failure.message,
          'message',
          'Network error',
        ),
      ],
    );
  });

  group('WalletBloc - OnRetryEvent', () {
    blocTest<WalletBloc, WalletState>(
      'should emit loading states first',
      build: () {
        when(
          () => mockGetBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testBalance));

        when(
          () => mockGetTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testTokenBalances));

        return walletBloc;
      },
      act: (bloc) => bloc.add(OnRetryEvent()),
      expect: () => [
        isA<BalanceLoadingState>(),
        isA<TokenBalancesLoadingState>(),
        isA<UpdateBalanceState>(),
        isA<UpdateTokenBalancesState>(),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'should fetch and emit fresh balance and tokens',
      build: () {
        when(
          () => mockGetBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testBalance));

        when(
          () => mockGetTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testTokenBalances));

        return walletBloc;
      },
      act: (bloc) => bloc.add(OnRetryEvent()),
      expect: () => [
        isA<BalanceLoadingState>(),
        isA<TokenBalancesLoadingState>(),
        isA<UpdateBalanceState>()
            .having((s) => s.balance, 'balance', testBalance)
            .having((s) => s.isFromCache, 'isFromCache', false),
        isA<UpdateTokenBalancesState>()
            .having((s) => s.tokenBalances, 'tokenBalances', testTokenBalances)
            .having((s) => s.isFromCache, 'isFromCache', false),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'should emit error states when API fails',
      build: () {
        final testFailure = Failure(message: 'API error', code: 503);

        when(
          () => mockGetBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Left(testFailure));

        when(
          () => mockGetTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Left(testFailure));

        return walletBloc;
      },
      act: (bloc) => bloc.add(OnRetryEvent()),
      expect: () => [
        isA<BalanceLoadingState>(),
        isA<TokenBalancesLoadingState>(),
        isA<BalanceErrorState>().having(
          (s) => s.failure.message,
          'message',
          'API error',
        ),
        isA<TokenBalancesErrorState>().having(
          (s) => s.failure.message,
          'message',
          'API error',
        ),
      ],
    );
  });

  group('WalletBloc - Error Handling', () {
    blocTest<WalletBloc, WalletState>(
      'should handle balance fetch failure independently from tokens',
      build: () {
        final balanceFailure = Failure(message: 'Balance error', code: 500);

        when(
          () => mockGetCachedBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer(
          (_) async => Left(Failure(message: 'No cache', code: 404)),
        );

        when(
          () => mockGetCachedTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer(
          (_) async => Left(Failure(message: 'No cache', code: 404)),
        );

        when(
          () => mockGetBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Left(balanceFailure));

        when(
          () => mockGetTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testTokenBalances));

        return walletBloc;
      },
      act: (bloc) => bloc.add(InitialWalletEvent()),
      expect: () => [
        isA<UpdateAddressState>(),
        isA<BalanceLoadingState>(),
        isA<TokenBalancesLoadingState>(),
        isA<BalanceErrorState>().having(
          (s) => s.failure.message,
          'message',
          'Balance error',
        ),
        isA<UpdateTokenBalancesState>().having(
          (s) => s.tokenBalances,
          'tokenBalances',
          testTokenBalances,
        ),
      ],
    );

    blocTest<WalletBloc, WalletState>(
      'should handle token fetch failure independently from balance',
      build: () {
        final tokenFailure = Failure(message: 'Token error', code: 500);

        when(
          () => mockGetCachedBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer(
          (_) async => Left(Failure(message: 'No cache', code: 404)),
        );

        when(
          () => mockGetCachedTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer(
          (_) async => Left(Failure(message: 'No cache', code: 404)),
        );

        when(
          () => mockGetBalanceUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testBalance));

        when(
          () => mockGetTokenBalancesUseCase.call(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Left(tokenFailure));

        return walletBloc;
      },
      act: (bloc) => bloc.add(InitialWalletEvent()),
      expect: () => [
        isA<UpdateAddressState>(),
        isA<BalanceLoadingState>(),
        isA<TokenBalancesLoadingState>(),
        isA<UpdateBalanceState>().having(
          (s) => s.balance,
          'balance',
          testBalance,
        ),
        isA<TokenBalancesErrorState>().having(
          (s) => s.failure.message,
          'message',
          'Token error',
        ),
      ],
    );
  });
}
