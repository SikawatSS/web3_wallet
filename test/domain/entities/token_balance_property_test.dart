import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/token_balance.dart';

void main() {
  group('TokenBalance Property-Based Tests', () {
    // Helper to generate random decimal places (1-18)
    int randomDecimals() => Random().nextInt(18) + 1;

    // Helper to generate token quantity based on decimals
    String randomQuantity(int decimals) {
      final random = Random();
      final value = random.nextInt(1000000000); // Up to 1 billion
      return (BigInt.from(value) * BigInt.from(10).pow(decimals ~/ 2))
          .toString();
    }

    test('Property: Token amount is always non-negative', () {
      for (var i = 0; i < 100; i++) {
        final decimals = randomDecimals();
        final divisor = BigInt.from(10).pow(decimals).toString();
        final quantity = randomQuantity(decimals);

        final token = TokenBalance(
          tokenName: 'Test',
          tokenSymbol: 'TEST',
          tokenQuantity: quantity,
          tokenDivisor: divisor,
        );

        // Property: Amount should always be non-negative
        expect(token.tokenAmount, greaterThanOrEqualTo(0));
      }
    });

    test('Property: Zero quantity always equals zero amount', () {
      for (var i = 0; i < 20; i++) {
        final decimals = randomDecimals();
        final divisor = BigInt.from(10).pow(decimals).toString();

        final token = TokenBalance(
          tokenName: 'Test',
          tokenSymbol: 'TEST',
          tokenQuantity: '0',
          tokenDivisor: divisor,
        );

        // Property: 0 quantity = 0 amount
        expect(token.tokenAmount, equals(0.0));
      }
    });

    test('Property: Amount calculation is correct for known decimals', () {
      final testCases = [
        ('1000000', '1000000', 1.0), // 6 decimals: 1.0
        ('2000000', '1000000', 2.0), // 6 decimals: 2.0
        ('1000000000000000000', '1000000000000000000', 1.0), // 18 decimals: 1.0
        ('2000000000000000000', '1000000000000000000', 2.0), // 18 decimals: 2.0
        ('500000', '1000000', 0.5), // 6 decimals: 0.5
        ('500000000000000000', '1000000000000000000', 0.5), // 18 decimals: 0.5
      ];

      for (final (quantity, divisor, expectedAmount) in testCases) {
        final token = TokenBalance(
          tokenName: 'Test',
          tokenSymbol: 'TEST',
          tokenQuantity: quantity,
          tokenDivisor: divisor,
        );

        // Property: Known values should convert exactly
        expect(token.tokenAmount, closeTo(expectedAmount, 0.000001));
      }
    });

    test('Property: Doubling quantity doubles amount', () {
      for (var i = 0; i < 50; i++) {
        final decimals = randomDecimals();
        final divisor = BigInt.from(10).pow(decimals).toString();
        final quantity = randomQuantity(decimals);
        final doubleQuantity = (BigInt.parse(quantity) * BigInt.from(2))
            .toString();

        final token1 = TokenBalance(
          tokenName: 'Test',
          tokenSymbol: 'TEST',
          tokenQuantity: quantity,
          tokenDivisor: divisor,
        );

        final token2 = TokenBalance(
          tokenName: 'Test',
          tokenSymbol: 'TEST',
          tokenQuantity: doubleQuantity,
          tokenDivisor: divisor,
        );

        // Property: 2x quantity = 2x amount
        expect(token2.tokenAmount, closeTo(token1.tokenAmount * 2, 0.000001));
      }
    });

    test('Property: String formatting with 4 decimals', () {
      for (var i = 0; i < 50; i++) {
        final decimals = randomDecimals();
        final divisor = BigInt.from(10).pow(decimals).toString();
        final quantity = randomQuantity(decimals);

        final token = TokenBalance(
          tokenName: 'Test',
          tokenSymbol: 'TEST',
          tokenQuantity: quantity,
          tokenDivisor: divisor,
        );

        final amountString = token.toTokenString();

        // Property: Should format with 4 decimal places
        expect(amountString, matches(RegExp(r'^\d+\.\d{4}$')));
      }
    });

    test('Property: Amount string has consistent format', () {
      for (var i = 0; i < 30; i++) {
        final decimals = randomDecimals();
        final divisor = BigInt.from(10).pow(decimals).toString();
        final quantity = randomQuantity(decimals);

        final token = TokenBalance(
          tokenName: 'Test',
          tokenSymbol: 'TEST',
          tokenQuantity: quantity,
          tokenDivisor: divisor,
        );

        final amountString = token.toTokenString();

        // Property: Should always return a valid decimal string
        expect(double.tryParse(amountString), isNotNull);
        expect(amountString, matches(RegExp(r'^\d+\.\d+$')));
      }
    });

    test('Property: Same quantity and divisor produce same amount', () {
      for (var i = 0; i < 30; i++) {
        final decimals = randomDecimals();
        final divisor = BigInt.from(10).pow(decimals).toString();
        final quantity = randomQuantity(decimals);

        final token1 = TokenBalance(
          tokenName: 'Test1',
          tokenSymbol: 'TST1',
          tokenQuantity: quantity,
          tokenDivisor: divisor,
        );

        final token2 = TokenBalance(
          tokenName: 'Test2',
          tokenSymbol: 'TST2',
          tokenQuantity: quantity,
          tokenDivisor: divisor,
        );

        // Property: Same math, same result (regardless of name/symbol)
        expect(token1.tokenAmount, equals(token2.tokenAmount));
      }
    });

    test('Property: Handles all decimal places from 1 to 18', () {
      for (var decimals = 1; decimals <= 18; decimals++) {
        final divisor = BigInt.from(10).pow(decimals).toString();
        final quantity = divisor; // 1 token

        final token = TokenBalance(
          tokenName: 'Test',
          tokenSymbol: 'TEST',
          tokenQuantity: quantity,
          tokenDivisor: divisor,
        );

        // Property: 1 token should equal 1.0 regardless of decimals
        expect(token.tokenAmount, closeTo(1.0, 0.000001));
      }
    });

    test('Property: Very small amounts do not underflow', () {
      for (var i = 0; i < 20; i++) {
        const decimals = 18; // Maximum decimals
        final divisor = BigInt.from(10).pow(decimals).toString();
        const quantity = '1'; // 1 wei equivalent

        final token = TokenBalance(
          tokenName: 'Test',
          tokenSymbol: 'TEST',
          tokenQuantity: quantity,
          tokenDivisor: divisor,
        );

        // Property: Should not throw, should return valid number
        expect(() => token.tokenAmount, returnsNormally);
        expect(token.tokenAmount.isFinite, isTrue);
        expect(token.tokenAmount.isNaN, isFalse);
        expect(token.tokenAmount, greaterThanOrEqualTo(0));
      }
    });

    test('Property: toJson preserves all data', () {
      for (var i = 0; i < 30; i++) {
        final decimals = randomDecimals();
        final divisor = BigInt.from(10).pow(decimals).toString();
        final quantity = randomQuantity(decimals);
        final name = 'Token$i';
        final symbol = 'TOK$i';

        final token = TokenBalance(
          tokenName: name,
          tokenSymbol: symbol,
          tokenQuantity: quantity,
          tokenDivisor: divisor,
        );

        final json = token.toJson();

        // Property: All fields should be preserved in JSON
        expect(json['tokenName'], equals(name));
        expect(json['tokenSymbol'], equals(symbol));
        expect(json['tokenQuantity'], equals(quantity));
        expect(json['tokenDivisor'], equals(divisor));
      }
    });
  });
}
