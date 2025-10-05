import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/domain/entities/token_balance.dart';
import 'package:web3_wallet/presentation/wallet/widget/token/token_card.dart';

import '../../../helpers/test_helper.dart';

void main() {
  group('TokenCard Golden Tests', () {
    testWidgets('should match golden file for USDC token', (
      WidgetTester tester,
    ) async {
      // Arrange
      final tokenBalance = TokenBalance(
        tokenName: 'USD Coin',
        tokenSymbol: 'USDC',
        tokenQuantity: '1000000',
        tokenDivisor: '1000000',
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          TokenCard(coin: tokenBalance),
        ),
      );

      // Assert
      await expectLater(
        find.byType(TokenCard),
        matchesGoldenFile('goldens/token_card_usdc.png'),
      );
    });

    testWidgets('should match golden file for DAI token', (
      WidgetTester tester,
    ) async {
      // Arrange
      final tokenBalance = TokenBalance(
        tokenName: 'Dai Stablecoin',
        tokenSymbol: 'DAI',
        tokenQuantity: '2000000000000000000',
        tokenDivisor: '1000000000000000000',
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          TokenCard(coin: tokenBalance),
        ),
      );

      // Assert
      await expectLater(
        find.byType(TokenCard),
        matchesGoldenFile('goldens/token_card_dai.png'),
      );
    });

    testWidgets('should match golden file for fractional token balance', (
      WidgetTester tester,
    ) async {
      // Arrange
      final tokenBalance = TokenBalance(
        tokenName: 'Test Token',
        tokenSymbol: 'TEST',
        tokenQuantity: '123456',
        tokenDivisor: '1000000',
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          TokenCard(coin: tokenBalance),
        ),
      );

      // Assert
      await expectLater(
        find.byType(TokenCard),
        matchesGoldenFile('goldens/token_card_fractional.png'),
      );
    });
  });
}
