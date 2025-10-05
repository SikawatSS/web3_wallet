import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/balance.dart';
import 'package:web3_wallet/presentation/wallet/widget/balance/balance_amount.dart';

import '../../../helpers/test_helper.dart';

void main() {
  group('BalanceAmount Golden Tests', () {
    testWidgets('should match golden file for 1 ETH balance', (
      WidgetTester tester,
    ) async {
      // Arrange
      final balance = Balance(
        weiAmount: BigInt.parse('1000000000000000000'),
      ); // 1 ETH

      // Act
      await tester.pumpWidget(
        createTestWidget(
          BalanceAmount(balance: balance),
        ),
      );

      // Assert
      await expectLater(
        find.byType(BalanceAmount),
        matchesGoldenFile('goldens/balance_amount_1eth.png'),
      );
    });

    testWidgets('should match golden file for zero balance', (
      WidgetTester tester,
    ) async {
      // Arrange
      final balance = Balance(weiAmount: BigInt.zero);

      // Act
      await tester.pumpWidget(
        createTestWidget(
          BalanceAmount(balance: balance),
        ),
      );

      // Assert
      await expectLater(
        find.byType(BalanceAmount),
        matchesGoldenFile('goldens/balance_amount_zero.png'),
      );
    });

    testWidgets('should match golden file for large balance', (
      WidgetTester tester,
    ) async {
      // Arrange
      final balance = Balance(
        weiAmount: BigInt.parse('123456789000000000000'),
      ); // 123.456789 ETH

      // Act
      await tester.pumpWidget(
        createTestWidget(
          BalanceAmount(balance: balance),
        ),
      );

      // Assert
      await expectLater(
        find.byType(BalanceAmount),
        matchesGoldenFile('goldens/balance_amount_large.png'),
      );
    });
  });
}
