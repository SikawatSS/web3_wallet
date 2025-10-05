import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/presentation/wallet/widget/balance/balance_shimmer.dart';
import 'package:web3_wallet/presentation/wallet/widget/token/tokens_shimmer.dart';

import '../../../helpers/test_helper.dart';

void main() {
  group('Shimmer Golden Tests', () {
    testWidgets('should match golden file for BalanceShimmer', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(const BalanceShimmer()));

      // Assert
      await expectLater(
        find.byType(BalanceShimmer),
        matchesGoldenFile('goldens/balance_shimmer.png'),
      );
    });

    testWidgets('should match golden file for TokensShimmer', (
      WidgetTester tester,
    ) async {
      // Act - Wrap in Column with Expanded to provide proper Flex parent
      await tester.pumpWidget(
        createTestWidget(
          const SizedBox(
            height: 400,
            child: Column(children: [Expanded(child: TokensShimmer())]),
          ),
        ),
      );

      // Assert
      await expectLater(
        find.byType(TokensShimmer),
        matchesGoldenFile('goldens/tokens_shimmer.png'),
      );
    });
  });
}
