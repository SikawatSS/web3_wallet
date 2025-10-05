import 'package:flutter_test/flutter_test.dart';
import 'package:web3_wallet/data/models/balance_model.dart';
import '../../fixtures/balance_fixture.dart';

void main() {
  group('BalanceModel', () {
    group('fromJson', () {
      test('should parse valid balance response correctly', () {
        // Arrange
        final json = BalanceFixture.validBalanceResponse();

        // Act
        final result = BalanceModel.fromJson(json);

        // Assert
        expect(result.weiAmount, equals(BigInt.parse('1000000000000000000')));
      });

      test('should parse zero balance correctly', () {
        // Arrange
        final json = BalanceFixture.zeroBalanceResponse();

        // Act
        final result = BalanceModel.fromJson(json);

        // Assert
        expect(result.weiAmount, equals(BigInt.zero));
      });

      test('should parse very large balance correctly', () {
        // Arrange
        final json = BalanceFixture.largeBalanceResponse();

        // Act
        final result = BalanceModel.fromJson(json);

        // Assert
        expect(
          result.weiAmount,
          equals(BigInt.parse('1000000000000000000000')),
        );
      });

      test('should throw exception when result field is missing', () {
        // Arrange
        final json = BalanceFixture.missingResultResponse();

        // Act & Assert
        expect(() => BalanceModel.fromJson(json), throwsA(isA<TypeError>()));
      });

      test('should throw exception when result is wrong type', () {
        // Arrange
        final json = BalanceFixture.invalidTypeResponse();

        // Act & Assert
        expect(() => BalanceModel.fromJson(json), throwsA(isA<TypeError>()));
      });

      test('should handle result as error string', () {
        // Arrange
        final json = BalanceFixture.errorResponse();

        // Act & Assert
        expect(
          () => BalanceModel.fromJson(json),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('inheritance', () {
      test('should extend Balance entity', () {
        // Arrange
        final json = BalanceFixture.validBalanceResponse();

        // Act
        final result = BalanceModel.fromJson(json);

        // Assert
        expect(result.weiAmount, isA<BigInt>());
        expect(result.toString(), equals('1000000000000000000'));
      });
    });
  });
}
