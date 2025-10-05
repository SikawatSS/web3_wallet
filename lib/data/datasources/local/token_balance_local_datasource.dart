import 'package:web3_wallet/core/db/app_database.dart';
import 'package:web3_wallet/data/models/token_balance_model.dart';

abstract class TokenBalanceLocalDataSource {
  /// Get cached token balances from local database
  Future<List<TokenBalanceModel>> getCachedTokenBalances({
    required String address,
    required int chainId,
  });

  /// Cache token balances to local database
  Future<void> cacheTokenBalances({
    required String address,
    required int chainId,
    required List<TokenBalanceModel> tokenBalances,
  });

  /// Delete cached token balances
  Future<void> deleteCachedTokenBalances({
    required String address,
    required int chainId,
  });

  /// Clear all cached token balances
  Future<void> clearAllTokenBalances();
}

class TokenBalanceLocalDataSourceImpl implements TokenBalanceLocalDataSource {
  final AppDatabase database;

  TokenBalanceLocalDataSourceImpl({required this.database});

  @override
  Future<List<TokenBalanceModel>> getCachedTokenBalances({
    required String address,
    required int chainId,
  }) async {
    final results = await database.tokenBalanceDao.getTokenBalances(
      address: address,
      chainId: chainId,
    );

    return results.map((entity) {
      return TokenBalanceModel(
        tokenName: entity.tokenName,
        tokenSymbol: entity.tokenSymbol,
        tokenQuantity: entity.tokenQuantity,
        tokenDivisor: entity.tokenDivisor,
        contractAddress: entity.contractAddress,
      );
    }).toList();
  }

  @override
  Future<void> cacheTokenBalances({
    required String address,
    required int chainId,
    required List<TokenBalanceModel> tokenBalances,
  }) async {
    // First, delete old cache for this address/chain
    await database.tokenBalanceDao.deleteTokenBalances(
      address: address,
      chainId: chainId,
    );

    // Then insert new data
    final tokenBalancesMaps = tokenBalances.map((token) {
      return {
        'contractAddress': token.contractAddress ?? '',
        'tokenName': token.tokenName,
        'tokenSymbol': token.tokenSymbol,
        'tokenQuantity': token.tokenQuantity,
        'tokenDivisor': token.tokenDivisor,
      };
    }).toList();

    await database.tokenBalanceDao.upsertTokenBalances(
      address: address,
      chainId: chainId,
      tokenBalances: tokenBalancesMaps,
    );
  }

  @override
  Future<void> deleteCachedTokenBalances({
    required String address,
    required int chainId,
  }) async {
    await database.tokenBalanceDao.deleteTokenBalances(
      address: address,
      chainId: chainId,
    );
  }

  @override
  Future<void> clearAllTokenBalances() async {
    await database.tokenBalanceDao.clearAllTokenBalances();
  }
}
