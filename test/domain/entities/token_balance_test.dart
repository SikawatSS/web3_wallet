import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/token_balance.dart';

void main() {
  group('TokenBalance', () {
    group('creation', () {
      test('should create token balance with all fields', () {
        // Arrange & Act
        final tokenBalance = TokenBalance(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '1000000',
          tokenDivisor: '1000000',
          contractAddress: '0xabc123',
        );

        // Assert
        expect(tokenBalance.tokenName, equals('USD Coin'));
        expect(tokenBalance.tokenSymbol, equals('USDC'));
        expect(tokenBalance.tokenQuantity, equals('1000000'));
        expect(tokenBalance.tokenDivisor, equals('1000000'));
        expect(tokenBalance.contractAddress, equals('0xabc123'));
      });

      test('should create token balance without contract address', () {
        // Arrange & Act
        final tokenBalance = TokenBalance(
          tokenName: 'Test Token',
          tokenSymbol: 'TEST',
          tokenQuantity: '1000000',
          tokenDivisor: '1000000',
        );

        // Assert
        expect(tokenBalance.contractAddress, isNull);
      });
    });

    group('tokenAmount calculation', () {
      test('should calculate token amount for USDC (6 decimals)', () {
        // Arrange
        final tokenBalance = TokenBalance(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '1000000', // 1 USDC
          tokenDivisor: '1000000',
        );

        // Act
        final amount = tokenBalance.tokenAmount;

        // Assert
        expect(amount, equals(1.0));
      });

      test('should calculate token amount for DAI (18 decimals)', () {
        // Arrange
        final tokenBalance = TokenBalance(
          tokenName: 'Dai Stablecoin',
          tokenSymbol: 'DAI',
          tokenQuantity: '1000000000000000000', // 1 DAI
          tokenDivisor: '1000000000000000000',
        );

        // Act
        final amount = tokenBalance.tokenAmount;

        // Assert
        expect(amount, equals(1.0));
      });

      test('should calculate fractional amounts', () {
        // Arrange
        final tokenBalance = TokenBalance(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '1500000', // 1.5 USDC
          tokenDivisor: '1000000',
        );

        // Act
        final amount = tokenBalance.tokenAmount;

        // Assert
        expect(amount, equals(1.5));
      });

      test('should handle zero balance', () {
        // Arrange
        final tokenBalance = TokenBalance(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '0',
          tokenDivisor: '1000000',
        );

        // Act
        final amount = tokenBalance.tokenAmount;

        // Assert
        expect(amount, equals(0.0));
      });

      test('should handle very large amounts', () {
        // Arrange
        final tokenBalance = TokenBalance(
          tokenName: 'Test Token',
          tokenSymbol: 'TEST',
          tokenQuantity: '1000000000000', // 1 million tokens (6 decimals)
          tokenDivisor: '1000000',
        );

        // Act
        final amount = tokenBalance.tokenAmount;

        // Assert
        expect(amount, equals(1000000.0));
      });

      test('should handle very small amounts', () {
        // Arrange
        final tokenBalance = TokenBalance(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '1', // 0.000001 USDC
          tokenDivisor: '1000000',
        );

        // Act
        final amount = tokenBalance.tokenAmount;

        // Assert
        expect(amount, closeTo(0.000001, 0.0000001));
      });

      test('should calculate amount after transfers (in - out)', () {
        // Arrange - Simulating: received 10 USDC, sent 3 USDC = 7 USDC
        final tokenBalance = TokenBalance(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '7000000', // 7 USDC remaining
          tokenDivisor: '1000000',
        );

        // Act
        final amount = tokenBalance.tokenAmount;

        // Assert
        expect(amount, equals(7.0));
      });
    });

    group('toTokenString', () {
      test('should format with default 4 decimals', () {
        // Arrange
        final tokenBalance = TokenBalance(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '1234567', // 1.234567 USDC
          tokenDivisor: '1000000',
        );

        // Act
        final formatted = tokenBalance.toTokenString();

        // Assert
        expect(formatted, equals('1.2346'));
      });

      test('should format with custom decimals', () {
        // Arrange
        final tokenBalance = TokenBalance(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '1234567',
          tokenDivisor: '1000000',
        );

        // Act
        final formatted = tokenBalance.toTokenString(decimals: 2);

        // Assert
        expect(formatted, equals('1.23'));
      });

      test('should format zero with specified decimals', () {
        // Arrange
        final tokenBalance = TokenBalance(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '0',
          tokenDivisor: '1000000',
        );

        // Act
        final formatted = tokenBalance.toTokenString(decimals: 2);

        // Assert
        expect(formatted, equals('0.00'));
      });

      test('should format large numbers correctly', () {
        // Arrange
        final tokenBalance = TokenBalance(
          tokenName: 'Test Token',
          tokenSymbol: 'TEST',
          tokenQuantity: '123456789000', // 123456.789 (6 decimals)
          tokenDivisor: '1000000',
        );

        // Act
        final formatted = tokenBalance.toTokenString(decimals: 3);

        // Assert
        expect(formatted, equals('123456.789'));
      });
    });

    group('toString', () {
      test('should return formatted string with symbol', () {
        // Arrange
        final tokenBalance = TokenBalance(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '1000000',
          tokenDivisor: '1000000',
        );

        // Act
        final string = tokenBalance.toString();

        // Assert
        expect(string, equals('1.0 USDC'));
      });

      test('should include decimal places in toString', () {
        // Arrange
        final tokenBalance = TokenBalance(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '1500000',
          tokenDivisor: '1000000',
        );

        // Act
        final string = tokenBalance.toString();

        // Assert
        expect(string, equals('1.5 USDC'));
      });
    });

    group('toJson', () {
      test('should convert to JSON with all fields', () {
        // Arrange
        final tokenBalance = TokenBalance(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '1000000',
          tokenDivisor: '1000000',
          contractAddress: '0xabc123',
        );

        // Act
        final json = tokenBalance.toJson();

        // Assert
        expect(json['tokenName'], equals('USD Coin'));
        expect(json['tokenSymbol'], equals('USDC'));
        expect(json['tokenQuantity'], equals('1000000'));
        expect(json['tokenDivisor'], equals('1000000'));
        expect(json['tokenAmount'], equals(1.0));
        expect(json['contractAddress'], equals('0xabc123'));
      });

      test('should convert to JSON with null contract address', () {
        // Arrange
        final tokenBalance = TokenBalance(
          tokenName: 'Test Token',
          tokenSymbol: 'TEST',
          tokenQuantity: '1000000',
          tokenDivisor: '1000000',
        );

        // Act
        final json = tokenBalance.toJson();

        // Assert
        expect(json['contractAddress'], isNull);
      });
    });

    group('edge cases', () {
      test('should handle empty token list scenario', () {
        // Arrange - Simulating empty list by testing with zero
        final tokenBalance = TokenBalance(
          tokenName: 'USD Coin',
          tokenSymbol: 'USDC',
          tokenQuantity: '0',
          tokenDivisor: '1000000',
        );

        // Act
        final amount = tokenBalance.tokenAmount;

        // Assert
        expect(amount, equals(0.0));
      });

      test('should return Infinity when divisor is zero', () {
        // This test documents the behavior when divisor is "0"
        // In reality, this should be validated before creating TokenBalance
        // Dart returns Infinity for division by zero (not an exception)

        // Arrange
        final tokenBalance = TokenBalance(
          tokenName: 'Bad Token',
          tokenSymbol: 'BAD',
          tokenQuantity: '1000000',
          tokenDivisor: '0', // This will cause division by zero
        );

        // Act
        final amount = tokenBalance.tokenAmount;

        // Assert
        expect(amount, equals(double.infinity));
      });
    });
  });
}
