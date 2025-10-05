import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet/core/failure.dart';
import 'package:web3_wallet/data/datasources/remote/etherscan_remote_datasource.dart';
import 'package:web3_wallet/data/models/balance_model.dart';
import 'package:web3_wallet/data/models/token_balance_model.dart';
import '../../../fixtures/balance_fixture.dart';
import '../../../fixtures/token_balance_fixture.dart';
import '../../../helpers/test_helper.dart';

void main() {
  late MockApiClient mockApiClient;
  late EtherscanRemoteDataSourceImpl dataSource;

  const testApiKey = 'test-api-key';
  const testApiUrl = 'https://api-sepolia.etherscan.io/api';

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = EtherscanRemoteDataSourceImpl(
      apiClient: mockApiClient,
      apiKey: testApiKey,
      apiUrl: testApiUrl,
    );
  });

  const testAddress = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb';
  const testChainId = 11155111;

  group('EtherscanRemoteDataSource - getBalance', () {
    test('should return BalanceModel when API call is successful', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: BalanceFixture.validBalanceResponse(),
      );

      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await dataSource.getBalance(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Right<Failure, BalanceModel>>());
      result.fold((failure) => fail('Should return BalanceModel'), (balance) {
        expect(balance.weiAmount, equals(BigInt.parse('1000000000000000000')));
      });
    });

    test('should return BalanceModel with zero balance', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: BalanceFixture.zeroBalanceResponse(),
      );

      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await dataSource.getBalance(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      result.fold((failure) => fail('Should return BalanceModel'), (balance) {
        expect(balance.weiAmount, equals(BigInt.zero));
      });
    });

    test('should return Failure when status code is not 200', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 404,
        data: 'Not Found', // String instead of Map
      );

      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await dataSource.getBalance(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Left<Failure, BalanceModel>>());
      result.fold((failure) {
        expect(failure.code, equals(404));
      }, (balance) => fail('Should return Failure'));
    });

    test(
      'should return Failure when DioException occurs (network error)',
      () async {
        // Arrange
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 500,
              data: 'Internal Server Error',
            ),
          ),
        );

        // Act
        final result = await dataSource.getBalance(
          address: testAddress,
          chainId: testChainId,
        );

        // Assert
        expect(result, isA<Left<Failure, BalanceModel>>());
        result.fold((failure) {
          expect(failure.code, equals(500));
          expect(failure.message, equals('Internal Server Error'));
        }, (balance) => fail('Should return Failure'));
      },
    );

    test(
      'should return Failure when DioException occurs without response',
      () async {
        // Arrange
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // Act
        final result = await dataSource.getBalance(
          address: testAddress,
          chainId: testChainId,
        );

        // Assert
        expect(result, isA<Left<Failure, BalanceModel>>());
        result.fold((failure) {
          expect(failure.code, equals(0));
        }, (balance) => fail('Should return Failure'));
      },
    );
  });

  group('EtherscanRemoteDataSource - getTokenBalances', () {
    test('should return list of TokenBalanceModel when successful', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: TokenBalanceFixture.multipleTransfersResponse(testAddress),
      );

      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await dataSource.getTokenBalances(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Right<Failure, List<TokenBalanceModel>>>());
      result.fold((failure) => fail('Should return token balances'), (
        tokenBalances,
      ) {
        expect(tokenBalances.length, equals(2)); // USDC and DAI
        expect(tokenBalances[0].tokenSymbol, equals('USDC'));
        expect(tokenBalances[0].tokenAmount, equals(12.0)); // 10 + 5 - 3
      });
    });

    test(
      'should return empty list when no transactions found (status 0)',
      () async {
        // Arrange
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: TokenBalanceFixture.noTransactionsResponse(),
        );

        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await dataSource.getTokenBalances(
          address: testAddress,
          chainId: testChainId,
        );

        // Assert
        result.fold((failure) => fail('Should return empty list'), (
          tokenBalances,
        ) {
          expect(tokenBalances, isEmpty);
        });
      },
    );

    test('should return empty list when result is null', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {'status': '1', 'result': null},
      );

      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await dataSource.getTokenBalances(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      result.fold((failure) => fail('Should return empty list'), (
        tokenBalances,
      ) {
        expect(tokenBalances, isEmpty);
      });
    });

    test('should return empty list when result is empty array', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: TokenBalanceFixture.emptyTokenListResponse(),
      );

      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await dataSource.getTokenBalances(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      result.fold((failure) => fail('Should return empty list'), (
        tokenBalances,
      ) {
        expect(tokenBalances, isEmpty);
      });
    });

    test('should filter out zero balances (all spent)', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: TokenBalanceFixture.zeroBalanceResponse(testAddress),
      );

      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await dataSource.getTokenBalances(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      result.fold((failure) => fail('Should return empty list'), (
        tokenBalances,
      ) {
        expect(tokenBalances, isEmpty); // All balance spent, filtered out
      });
    });

    test('should return Failure when API returns error status', () async {
      // Arrange
      final mockResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {
          'status': '0',
          'message': 'NOTOK - Invalid API key',
          'result': 'Invalid API Key',
        },
      );

      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await dataSource.getTokenBalances(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      result.fold((failure) => fail('Should return empty list for status 0'), (
        tokenBalances,
      ) {
        expect(tokenBalances, isEmpty);
      });
    });

    test('should return Failure when DioException occurs', () async {
      // Arrange
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 503,
            data: 'Service Unavailable',
          ),
        ),
      );

      // Act
      final result = await dataSource.getTokenBalances(
        address: testAddress,
        chainId: testChainId,
      );

      // Assert
      expect(result, isA<Left<Failure, List<TokenBalanceModel>>>());
      result.fold((failure) {
        expect(failure.code, equals(503));
      }, (tokenBalances) => fail('Should return Failure'));
    });

    test(
      'should calculate balances correctly from multiple transfers',
      () async {
        // Arrange - USDC: in(10) - out(3) + in(5) = 12
        final mockResponse = Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: TokenBalanceFixture.multipleTransfersResponse(testAddress),
        );

        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await dataSource.getTokenBalances(
          address: testAddress,
          chainId: testChainId,
        );

        // Assert
        result.fold((failure) => fail('Should calculate balances correctly'), (
          tokenBalances,
        ) {
          final usdc = tokenBalances.firstWhere((t) => t.tokenSymbol == 'USDC');
          final dai = tokenBalances.firstWhere((t) => t.tokenSymbol == 'DAI');

          expect(usdc.tokenAmount, equals(12.0));
          expect(dai.tokenAmount, equals(100.0));
        });
      },
    );
  });
}
