import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/balance.dart';

void main() {
  group('Balance', () {
    group('creation', () {
      test('should create balance with wei amount', () {
        // Arrange & Act
        final balance = Balance(weiAmount: BigInt.from(1000000000000000000));

        // Assert
        expect(balance.weiAmount, equals(BigInt.from(1000000000000000000)));
      });

      test('should create balance with zero', () {
        // Arrange & Act
        final balance = Balance(weiAmount: BigInt.zero);

        // Assert
        expect(balance.weiAmount, equals(BigInt.zero));
      });
    });

    group('BalanceExtension - ethAmount', () {
      test('should convert 1 ETH (wei) to ETH correctly', () {
        // Arrange
        final balance = Balance(weiAmount: BigInt.parse('1000000000000000000'));

        // Act
        final ethAmount = balance.ethAmount;

        // Assert
        expect(ethAmount, equals(1.0));
      });

      test('should convert 0.5 ETH (wei) to ETH correctly', () {
        // Arrange
        final balance = Balance(weiAmount: BigInt.parse('500000000000000000'));

        // Act
        final ethAmount = balance.ethAmount;

        // Assert
        expect(ethAmount, equals(0.5));
      });

      test('should convert very small amount correctly', () {
        // Arrange - 0.000000000000000001 ETH (1 wei)
        final balance = Balance(weiAmount: BigInt.one);

        // Act
        final ethAmount = balance.ethAmount;

        // Assert
        expect(ethAmount, closeTo(0.000000000000000001, 0.000000000000000001));
      });

      test('should convert very large amount correctly', () {
        // Arrange - 1000 ETH
        final balance = Balance(
          weiAmount: BigInt.parse('1000000000000000000000'),
        );

        // Act
        final ethAmount = balance.ethAmount;

        // Assert
        expect(ethAmount, equals(1000.0));
      });

      test('should handle zero balance', () {
        // Arrange
        final balance = Balance(weiAmount: BigInt.zero);

        // Act
        final ethAmount = balance.ethAmount;

        // Assert
        expect(ethAmount, equals(0.0));
      });
    });

    group('BalanceExtension - toEthString', () {
      test('should format ETH amount with 4 decimals', () {
        // Arrange
        final balance = Balance(weiAmount: BigInt.parse('1234567890123456789'));

        // Act
        final formatted = balance.toEthString;

        // Assert
        expect(formatted, equals('1.2346'));
      });

      test('should format zero with 4 decimals', () {
        // Arrange
        final balance = Balance(weiAmount: BigInt.zero);

        // Act
        final formatted = balance.toEthString;

        // Assert
        expect(formatted, equals('0.0000'));
      });

      test('should round correctly', () {
        // Arrange - 1.23456 ETH
        final balance = Balance(weiAmount: BigInt.parse('1234560000000000000'));

        // Act
        final formatted = balance.toEthString;

        // Assert
        expect(formatted, equals('1.2346'));
      });
    });

    group('BalanceExtension - toUsdtString', () {
      test('should convert ETH to USDT with correct price', () {
        // Arrange - 1 ETH
        final balance = Balance(weiAmount: BigInt.parse('1000000000000000000'));
        const ethPrice = 4464.07;

        // Act
        final usdtString = balance.toUsdtString;

        // Assert
        expect(usdtString, equals(ethPrice.toStringAsFixed(2)));
      });

      test('should format USDT with 2 decimals', () {
        // Arrange - 0.5 ETH
        final balance = Balance(weiAmount: BigInt.parse('500000000000000000'));
        const expectedUsdt = 4464.07 * 0.5;

        // Act
        final usdtString = balance.toUsdtString;

        // Assert
        expect(usdtString, equals(expectedUsdt.toStringAsFixed(2)));
      });

      test('should handle zero balance', () {
        // Arrange
        final balance = Balance(weiAmount: BigInt.zero);

        // Act
        final usdtString = balance.toUsdtString;

        // Assert
        expect(usdtString, equals('0.00'));
      });

      test('should handle large balance', () {
        // Arrange - 100 ETH
        final balance = Balance(
          weiAmount: BigInt.parse('100000000000000000000'),
        );
        const expectedUsdt = 4464.07 * 100;

        // Act
        final usdtString = balance.toUsdtString;

        // Assert
        expect(usdtString, equals(expectedUsdt.toStringAsFixed(2)));
      });
    });

    group('toJson', () {
      test('should convert balance to JSON correctly', () {
        // Arrange
        final balance = Balance(weiAmount: BigInt.parse('1000000000000000000'));

        // Act
        final json = balance.toJson();

        // Assert
        expect(json['balance'], isA<Map<String, dynamic>>());
        expect(json['balance']['weiAmount'], equals('1000000000000000000'));
      });

      test('should convert zero balance to JSON', () {
        // Arrange
        final balance = Balance(weiAmount: BigInt.zero);

        // Act
        final json = balance.toJson();

        // Assert
        expect(json['balance']['weiAmount'], equals('0'));
      });
    });

    group('toString', () {
      test('should return wei amount as string', () {
        // Arrange
        final balance = Balance(weiAmount: BigInt.parse('1000000000000000000'));

        // Act
        final string = balance.toString();

        // Assert
        expect(string, equals('1000000000000000000'));
      });
    });
  });
}
