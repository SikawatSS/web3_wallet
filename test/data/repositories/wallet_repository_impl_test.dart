import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet/core/failure.dart';
import 'package:web3_wallet/data/models/balance_model.dart';
import 'package:web3_wallet/data/models/token_balance_model.dart';
import 'package:web3_wallet/data/repositories/wallet_repository_impl.dart';
import 'package:web3_wallet/domain/entities/balance.dart';
import 'package:web3_wallet/domain/entities/token_balance.dart';
import '../../helpers/test_helper.dart';

void main() {
  late WalletRepositoryImpl repository;
  late MockEtherscanRemoteDataSource mockRemoteDataSource;
  late MockBalanceLocalDataSource mockBalanceLocalDataSource;
  late MockTokenBalanceLocalDataSource mockTokenBalanceLocalDataSource;

  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(BalanceModel(weiAmount: BigInt.zero));
    registerFallbackValue(<TokenBalanceModel>[]);
  });

  setUp(() {
    mockRemoteDataSource = MockEtherscanRemoteDataSource();
    mockBalanceLocalDataSource = MockBalanceLocalDataSource();
    mockTokenBalanceLocalDataSource = MockTokenBalanceLocalDataSource();

    repository = WalletRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockBalanceLocalDataSource,
      tokenBalanceLocalDataSource: mockTokenBalanceLocalDataSource,
    );
  });

  const testAddress = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb';
  const testChainId = 11155111;

  group('WalletRepository - getBalance', () {
    final testBalance = BalanceModel(
      weiAmount: BigInt.parse('1000000000000000000'),
    );

    test(
      'should return balance from remote and cache it when successful',
      () async {
        // Arrange
        when(
          () => mockRemoteDataSource.getBalance(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Right(testBalance));

        when(
          () => mockBalanceLocalDataSource.cacheBalance(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
            balance: any(named: 'balance'),
          ),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await repository.getBalance(
          address: testAddress,
          chainId: testChainId,
        );

        // Assert
        expect(result, isA<Right<Failure, Balance>>());
        result.fold((failure) => fail('Should return balance'), (balance) {
          expect(balance.weiAmount, equals(testBalance.weiAmount));
        });

        // Verify cache was called
        verify(
          () => mockBalanceLocalDataSource.cacheBalance(
            address: testAddress,
            chainId: testChainId,
            balance: testBalance,
          ),
        ).called(1);
      },
    );

    test('should return cached balance when remote fails', () async {
      // Arrange
      final testFailure = Failure(message: 'Network error', code: 500);

      when(
        () => mockRemoteDataSource.getBalance(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
        ),
      ).thenAnswer((_) async => Left(testFailure));

      when(
        () => mockBalanceLocalDataSource.getCachedBalance(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
        ),
      ).thenAnswer((_) async => testBalance);

      // Act
      final result = await repository.getBalance(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Right<Failure, Balance>>());
      result.fold((failure) => fail('Should return cached balance'), (balance) {
        expect(balance.weiAmount, equals(testBalance.weiAmount));
      });
    });

    test('should return failure when both remote and cache fail', () async {
      // Arrange
      final testFailure = Failure(message: 'Network error', code: 500);

      when(
        () => mockRemoteDataSource.getBalance(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
        ),
      ).thenAnswer((_) async => Left(testFailure));

      when(
        () => mockBalanceLocalDataSource.getCachedBalance(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
        ),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.getBalance(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Left<Failure, Balance>>());
      result.fold((failure) {
        expect(failure.message, equals('Network error'));
        expect(failure.code, equals(500));
      }, (balance) => fail('Should return failure'));
    });

    test('should handle exception and return failure', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getBalance(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
        ),
      ).thenThrow(Exception('Unexpected error'));

      // Act
      final result = await repository.getBalance(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Left<Failure, Balance>>());
      result.fold((failure) {
        expect(failure.code, equals(500));
        expect(failure.message, contains('Failed to get balance'));
      }, (balance) => fail('Should return failure'));
    });
  });

  group('WalletRepository - getCachedBalance', () {
    final testBalance = BalanceModel(
      weiAmount: BigInt.parse('1000000000000000000'),
    );

    test('should return cached balance when available', () async {
      // Arrange
      when(
        () => mockBalanceLocalDataSource.getCachedBalance(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
        ),
      ).thenAnswer((_) async => testBalance);

      // Act
      final result = await repository.getCachedBalance(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Right<Failure, Balance>>());
      result.fold((failure) => fail('Should return cached balance'), (balance) {
        expect(balance.weiAmount, equals(testBalance.weiAmount));
      });
    });

    test('should return failure when cache is empty', () async {
      // Arrange
      when(
        () => mockBalanceLocalDataSource.getCachedBalance(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
        ),
      ).thenAnswer((_) async => null);

      // Act
      final result = await repository.getCachedBalance(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Left<Failure, Balance>>());
      result.fold((failure) {
        expect(failure.message, contains('No cached balance found'));
        expect(failure.code, equals(404));
      }, (balance) => fail('Should return failure'));
    });

    test('should return failure when exception occurs', () async {
      // Arrange
      when(
        () => mockBalanceLocalDataSource.getCachedBalance(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
        ),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getCachedBalance(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Left<Failure, Balance>>());
      result.fold((failure) {
        expect(failure.code, equals(500));
        expect(failure.message, contains('Failed to get cached balance'));
      }, (balance) => fail('Should return failure'));
    });
  });

  group('WalletRepository - getTokenBalances', () {
    final testTokenBalances = [
      TokenBalanceModel(
        tokenName: 'USD Coin',
        tokenSymbol: 'USDC',
        tokenQuantity: '1000000',
        tokenDivisor: '1000000',
      ),
      TokenBalanceModel(
        tokenName: 'Dai Stablecoin',
        tokenSymbol: 'DAI',
        tokenQuantity: '1000000000000000000',
        tokenDivisor: '1000000000000000000',
      ),
    ];

    test('should return token balances from remote and cache them', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getTokenBalances(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
        ),
      ).thenAnswer((_) async => Right(testTokenBalances));

      when(
        () => mockTokenBalanceLocalDataSource.cacheTokenBalances(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
          tokenBalances: any(named: 'tokenBalances'),
        ),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.getTokenBalances(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Right<Failure, List<TokenBalance>>>());
      result.fold((failure) => fail('Should return token balances'), (
        tokenBalances,
      ) {
        expect(tokenBalances.length, equals(2));
      });

      // Verify cache was called
      verify(
        () => mockTokenBalanceLocalDataSource.cacheTokenBalances(
          address: testAddress,
          chainId: testChainId,
          tokenBalances: testTokenBalances,
        ),
      ).called(1);
    });

    test('should return empty list from remote successfully', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getTokenBalances(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
        ),
      ).thenAnswer((_) async => const Right([]));

      when(
        () => mockTokenBalanceLocalDataSource.cacheTokenBalances(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
          tokenBalances: any(named: 'tokenBalances'),
        ),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.getTokenBalances(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Right<Failure, List<TokenBalance>>>());
      result.fold((failure) => fail('Should return empty list'), (
        tokenBalances,
      ) {
        expect(tokenBalances, isEmpty);
      });
    });

    test('should return cached token balances when remote fails', () async {
      // Arrange
      final testFailure = Failure(message: 'API error', code: 503);

      when(
        () => mockRemoteDataSource.getTokenBalances(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
        ),
      ).thenAnswer((_) async => Left(testFailure));

      when(
        () => mockTokenBalanceLocalDataSource.getCachedTokenBalances(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
        ),
      ).thenAnswer((_) async => testTokenBalances);

      // Act
      final result = await repository.getTokenBalances(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Right<Failure, List<TokenBalance>>>());
      result.fold((failure) => fail('Should return cached token balances'), (
        tokenBalances,
      ) {
        expect(tokenBalances.length, equals(2));
      });
    });

    test(
      'should return failure when remote fails and cache is empty',
      () async {
        // Arrange
        final testFailure = Failure(message: 'API error', code: 503);

        when(
          () => mockRemoteDataSource.getTokenBalances(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => Left(testFailure));

        when(
          () => mockTokenBalanceLocalDataSource.getCachedTokenBalances(
            address: any(named: 'address'),
            chainId: any(named: 'chainId'),
          ),
        ).thenAnswer((_) async => []);

        // Act
        final result = await repository.getTokenBalances(
          address: testAddress,
          chainId: testChainId,
        );

        // Assert
        expect(result, isA<Left<Failure, List<TokenBalance>>>());
        result.fold((failure) {
          expect(failure.message, equals('API error'));
          expect(failure.code, equals(503));
        }, (tokenBalances) => fail('Should return failure'));
      },
    );

    test('should handle exception and return failure', () async {
      // Arrange
      when(
        () => mockRemoteDataSource.getTokenBalances(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
        ),
      ).thenThrow(Exception('Unexpected error'));

      // Act
      final result = await repository.getTokenBalances(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Left<Failure, List<TokenBalance>>>());
      result.fold((failure) {
        expect(failure.code, equals(500));
        expect(failure.message, contains('Failed to get token balances'));
      }, (tokenBalances) => fail('Should return failure'));
    });
  });

  group('WalletRepository - getCachedTokenBalances', () {
    final testTokenBalances = [
      TokenBalanceModel(
        tokenName: 'USD Coin',
        tokenSymbol: 'USDC',
        tokenQuantity: '1000000',
        tokenDivisor: '1000000',
      ),
    ];

    test('should return cached token balances when available', () async {
      // Arrange
      when(
        () => mockTokenBalanceLocalDataSource.getCachedTokenBalances(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
        ),
      ).thenAnswer((_) async => testTokenBalances);

      // Act
      final result = await repository.getCachedTokenBalances(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Right<Failure, List<TokenBalance>>>());
      result.fold((failure) => fail('Should return cached token balances'), (
        tokenBalances,
      ) {
        expect(tokenBalances.length, equals(1));
      });
    });

    test('should return failure when cache is empty', () async {
      // Arrange
      when(
        () => mockTokenBalanceLocalDataSource.getCachedTokenBalances(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
        ),
      ).thenAnswer((_) async => []);

      // Act
      final result = await repository.getCachedTokenBalances(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Left<Failure, List<TokenBalance>>>());
      result.fold((failure) {
        expect(failure.message, contains('No cached token balances found'));
        expect(failure.code, equals(404));
      }, (tokenBalances) => fail('Should return failure'));
    });

    test('should return failure when exception occurs', () async {
      // Arrange
      when(
        () => mockTokenBalanceLocalDataSource.getCachedTokenBalances(
          address: any(named: 'address'),
          chainId: any(named: 'chainId'),
        ),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await repository.getCachedTokenBalances(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Left<Failure, List<TokenBalance>>>());
      result.fold((failure) {
        expect(failure.code, equals(500));
        expect(
          failure.message,
          contains('Failed to get cached token balances'),
        );
      }, (tokenBalances) => fail('Should return failure'));
    });
  });
}
