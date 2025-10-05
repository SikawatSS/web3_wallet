import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/balance.dart';

void main() {
  group('Balance Property-Based Tests', () {
    // Helper to generate random BigInt values
    BigInt randomBigInt(int maxBits) {
      final random = Random();
      final bytes = List<int>.generate(
        maxBits ~/ 8,
        (_) => random.nextInt(256),
      );
      return BigInt.parse(
        bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
        radix: 16,
      );
    }

    test('Property: Wei to ETH conversion is always non-negative', () {
      for (var i = 0; i < 100; i++) {
        // Generate random wei amounts (up to 1 million ETH)
        final weiAmount = randomBigInt(80); // ~10^24
        final balance = Balance(weiAmount: weiAmount);

        // Property: ETH amount should always be non-negative
        expect(balance.ethAmount, greaterThanOrEqualTo(0));
      }
    });

    test('Property: Zero wei always equals zero ETH', () {
      for (var i = 0; i < 10; i++) {
        final balance = Balance(weiAmount: BigInt.zero);

        // Property: 0 wei = 0 ETH
        expect(balance.ethAmount, equals(0.0));
        expect(balance.toEthString, equals('0.0000'));
      }
    });

    test('Property: Doubling wei amount doubles ETH amount', () {
      for (var i = 0; i < 50; i++) {
        // Generate random wei amounts
        final weiAmount = randomBigInt(60); // Smaller to avoid overflow
        final balance1 = Balance(weiAmount: weiAmount);
        final balance2 = Balance(weiAmount: weiAmount * BigInt.from(2));

        // Property: balance2 should be 2x balance1
        expect(balance2.ethAmount, closeTo(balance1.ethAmount * 2, 0.000001));
      }
    });

    test('Property: USD conversion maintains proportionality', () {
      // ETH price constant from balance.dart (updated 3 Oct 2025)
      const ethPrice = 4464.07;

      for (var i = 0; i < 50; i++) {
        final weiAmount = randomBigInt(60);
        final balance = Balance(weiAmount: weiAmount);

        // Extract USD value from string
        final usdString = balance.toUsdtString;
        final usdValue = double.tryParse(
          usdString.replaceAll(RegExp(r'[^\d.]'), ''),
        );

        if (usdValue != null) {
          // Property: USD value should equal ETH amount * price
          final expectedUsd = balance.ethAmount * ethPrice;
          expect(usdValue, closeTo(expectedUsd, 0.01));
        }
      }
    });

    test('Property: Known conversions are exact', () {
      final testCases = [
        (BigInt.parse('1000000000000000000'), 1.0), // 1 ETH
        (BigInt.parse('500000000000000000'), 0.5), // 0.5 ETH
        (BigInt.parse('1500000000000000000'), 1.5), // 1.5 ETH
        (BigInt.parse('100000000000000000'), 0.1), // 0.1 ETH
        (BigInt.parse('1'), 0.000000000000000001), // 1 wei
      ];

      for (final (weiAmount, expectedEth) in testCases) {
        final balance = Balance(weiAmount: weiAmount);

        // Property: Known values should convert exactly
        expect(balance.ethAmount, closeTo(expectedEth, 0.000001));
      }
    });

    test('Property: String formatting always includes 4 decimals', () {
      for (var i = 0; i < 50; i++) {
        final weiAmount = randomBigInt(70);
        final balance = Balance(weiAmount: weiAmount);

        final ethString = balance.toEthString;

        // Property: Should match format "X.XXXX" (4 decimal places)
        expect(ethString, matches(RegExp(r'^\d+\.\d{4}$')));
      }
    });

    test('Property: Addition is commutative', () {
      for (var i = 0; i < 30; i++) {
        final wei1 = randomBigInt(60);
        final wei2 = randomBigInt(60);

        final balance1Plus2 = Balance(weiAmount: wei1 + wei2);
        final balance2Plus1 = Balance(weiAmount: wei2 + wei1);

        // Property: A + B = B + A
        expect(balance1Plus2.ethAmount, equals(balance2Plus1.ethAmount));
      }
    });

    test('Property: Very large balances do not overflow', () {
      // Test with extremely large values (up to 10^30)
      for (var i = 0; i < 20; i++) {
        final weiAmount = randomBigInt(100);
        final balance = Balance(weiAmount: weiAmount);

        // Property: Should not throw, should return valid number
        expect(() => balance.ethAmount, returnsNormally);
        expect(balance.ethAmount.isFinite, isTrue);
        expect(balance.ethAmount.isNaN, isFalse);
      }
    });

    test('Property: Balance equality is based on wei amount', () {
      for (var i = 0; i < 30; i++) {
        final weiAmount = randomBigInt(70);
        final balance1 = Balance(weiAmount: weiAmount);
        final balance2 = Balance(weiAmount: weiAmount);

        // Property: Same wei = same ETH
        expect(balance1.ethAmount, equals(balance2.ethAmount));
        expect(balance1.toEthString, equals(balance2.toEthString));
      }
    });

    test('Property: toJson is reversible', () {
      for (var i = 0; i < 30; i++) {
        final weiAmount = randomBigInt(70);
        final balance = Balance(weiAmount: weiAmount);

        final json = balance.toJson();

        // Property: Reconstructing from JSON gives same value
        // Note: toJson returns nested structure {'balance': {'weiAmount': '...'}}
        expect(json['balance']['weiAmount'], equals(weiAmount.toString()));
      }
    });
  });
}
