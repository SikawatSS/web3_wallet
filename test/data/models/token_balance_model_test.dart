import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/data/models/token_balance_model.dart';
import '../../fixtures/token_balance_fixture.dart';

void main() {
  group('TokenBalanceModel', () {
    group('fromJson', () {
      test('should parse valid token balance correctly', () {
        // Arrange
        final json = TokenBalanceFixture.singleTokenBalanceData();

        // Act
        final result = TokenBalanceModel.fromJson(json);

        // Assert
        expect(result.tokenName, equals('USD Coin'));
        expect(result.tokenSymbol, equals('USDC'));
        expect(result.tokenQuantity, equals('1000000'));
        expect(result.tokenDivisor, equals('1000000'));
        expect(
          result.contractAddress,
          equals('0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'),
        );
      });

      test('should parse token balance without contract address', () {
        // Arrange
        final json = TokenBalanceFixture.tokenBalanceWithoutContractAddress();

        // Act
        final result = TokenBalanceModel.fromJson(json);

        // Assert
        expect(result.tokenName, equals('Test Token'));
        expect(result.tokenSymbol, equals('TEST'));
        expect(result.tokenQuantity, equals('1000000'));
        expect(result.tokenDivisor, equals('1000000'));
        expect(result.contractAddress, isNull);
      });

      test('should throw exception when required field is missing', () {
        // Arrange
        final json = <String, dynamic>{
          'TokenName': 'Test',
          // Missing TokenSymbol
        };

        // Act & Assert
        expect(
          () => TokenBalanceModel.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });

      test('should throw exception when field type is wrong', () {
        // Arrange
        final json = <String, dynamic>{
          'TokenName': 123, // Should be String
          'TokenSymbol': 'TEST',
          'TokenQuantity': '1000000',
          'TokenDivisor': '1000000',
        };

        // Act & Assert
        expect(
          () => TokenBalanceModel.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('tokenAmount calculation', () {
      test('should calculate token amount correctly for 6 decimals (USDC)', () {
        // Arrange
        final model = TokenBalanceModel(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '1000000', // 1 USDC
          tokenDivisor: '1000000',
        );

        // Act
        final amount = model.tokenAmount;

        // Assert
        expect(amount, equals(1.0));
      });

      test('should calculate token amount correctly for 18 decimals (DAI)', () {
        // Arrange
        final model = TokenBalanceModel(
          tokenName: 'Dai Stablecoin',
          tokenSymbol: 'DAI',
          tokenQuantity: '1000000000000000000', // 1 DAI
          tokenDivisor: '1000000000000000000',
        );

        // Act
        final amount = model.tokenAmount;

        // Assert
        expect(amount, equals(1.0));
      });

      test('should calculate fractional token amounts', () {
        // Arrange
        final model = TokenBalanceModel(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '1500000', // 1.5 USDC
          tokenDivisor: '1000000',
        );

        // Act
        final amount = model.tokenAmount;

        // Assert
        expect(amount, equals(1.5));
      });

      test('should handle zero balance', () {
        // Arrange
        final model = TokenBalanceModel(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '0',
          tokenDivisor: '1000000',
        );

        // Act
        final amount = model.tokenAmount;

        // Assert
        expect(amount, equals(0.0));
      });

      test('should handle very large balances', () {
        // Arrange
        final model = TokenBalanceModel(
          tokenName: 'Test Token',
          tokenSymbol: 'TEST',
          tokenQuantity: '1000000000000000', // 1 million tokens (6 decimals)
          tokenDivisor: '1000000',
        );

        // Act
        final amount = model.tokenAmount;

        // Assert
        expect(amount, equals(1000000000.0));
      });
    });

    group('toTokenString', () {
      test('should format token amount with default 4 decimals', () {
        // Arrange
        final model = TokenBalanceModel(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '1234567', // 1.234567 USDC
          tokenDivisor: '1000000',
        );

        // Act
        final formatted = model.toTokenString();

        // Assert
        expect(formatted, equals('1.2346'));
      });

      test('should format token amount with custom decimals', () {
        // Arrange
        final model = TokenBalanceModel(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '1234567',
          tokenDivisor: '1000000',
        );

        // Act
        final formatted = model.toTokenString(decimals: 2);

        // Assert
        expect(formatted, equals('1.23'));
      });
    });

    group('toJson', () {
      test('should convert model to JSON correctly', () {
        // Arrange
        final model = TokenBalanceModel(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '1000000',
          tokenDivisor: '1000000',
          contractAddress: '0xabc123',
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['tokenName'], equals('USD Coin'));
        expect(json['tokenSymbol'], equals('USDC'));
        expect(json['tokenQuantity'], equals('1000000'));
        expect(json['tokenDivisor'], equals('1000000'));
        expect(json['tokenAmount'], equals(1.0));
        expect(json['contractAddress'], equals('0xabc123'));
      });
    });
  });
}
