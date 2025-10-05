import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/presentation/wallet/widget/wallet_address.dart';

import '../../../helpers/test_helper.dart';

void main() {
  group('WalletAddress Golden Tests', () {
    testWidgets('should match golden file for standard address', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testAddress = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb';

      // Act - Wrap in SizedBox to provide width constraint
      await tester.pumpWidget(
        createTestWidget(
          const SizedBox(
            width: 400,
            child: WalletAddress(address: testAddress),
          ),
        ),
      );

      // Assert
      await expectLater(
        find.byType(WalletAddress),
        matchesGoldenFile('goldens/wallet_address.png'),
      );
    });

    testWidgets('should match golden file for short address format', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testAddress = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb';

      // Act - Wrap in SizedBox to provide width constraint
      await tester.pumpWidget(
        createTestWidget(
          const SizedBox(
            width: 400,
            child: WalletAddress(address: testAddress),
          ),
        ),
      );

      // Assert - Verify shortened format is displayed
      expect(find.text('0x742d...0bEb'), findsOneWidget);

      await expectLater(
        find.byType(WalletAddress),
        matchesGoldenFile('goldens/wallet_address_shortened.png'),
      );
    });
  });
}
