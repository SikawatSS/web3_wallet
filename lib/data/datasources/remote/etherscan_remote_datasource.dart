import 'package:dio/dio.dart';
import 'package:web3_wallet/core/api/api_client.dart';
import 'package:dartz/dartz.dart';
import 'package:web3_wallet/core/failure.dart';
import 'package:web3_wallet/data/models/balance_model.dart';
import 'package:web3_wallet/data/models/token_balance_model.dart';
import 'package:web3_wallet/data/models/token_transfer_model.dart';

abstract class EtherscanRemoteDataSource {
  Future<Either<Failure, BalanceModel>> getBalance({
    required String address,
    required int chainId,
  });

  Future<Either<Failure, List<TokenBalanceModel>>> getTokenBalances({
    required String address,
    required int chainId,
  });
}

class EtherscanRemoteDataSourceImpl implements EtherscanRemoteDataSource {
  final ApiClient apiClient;
  final String apiKey;
  final String apiUrl;

  EtherscanRemoteDataSourceImpl({
    required this.apiClient,
    required this.apiKey,
    required this.apiUrl,
  });

  @override
  Future<Either<Failure, BalanceModel>> getBalance({
    required String address,
    required int chainId,
  }) async {
    try {
      final response = await apiClient.get(
        apiUrl,
        queryParameters: {
          'chainid': chainId,
          'module': 'account',
          'action': 'balance',
          'address': address,
          'tag': 'latest',
          'apikey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        return Right(BalanceModel.fromJson(response.data));
      }

      return Left(
        Failure(
          message: response.data?.toString() ?? 'Unknown error',
          code: response.statusCode!,
        ),
      );
    } on DioException catch (e) {
      return Left(
        Failure(
          message: e.response?.data?.toString() ?? e.message ?? 'Network error',
          code: e.response?.statusCode ?? 0,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<TokenBalanceModel>>> getTokenBalances({
    required String address,
    required int chainId,
  }) async {
    try {
      final response = await apiClient.get(
        apiUrl,
        queryParameters: {
          'chainid': chainId,
          'module': 'account',
          'action': 'tokentx',
          'address': address,
          'page': 1,
          'offset': 10000,
          'startblock': 0,
          'endblock': 99999999,
          'sort': 'asc',
          'apikey': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == '0' || data['result'] == null) {
          return const Right([]);
        }

        if (data['status'] == '1' && data['result'] is List) {
          final List<dynamic> results = data['result'];

          final transfers = results
              .map((json) => TokenTransferModel.fromJson(json))
              .toList();

          final balances = _calculateBalancesFromTransfers(transfers, address);

          return Right(balances);
        }

        return Left(
          Failure(
            message: data['message']?.toString() ?? 'API error',
            code: response.statusCode!,
          ),
        );
      }

      return Left(
        Failure(
          message: response.data?.toString() ?? 'Unknown error',
          code: response.statusCode!,
        ),
      );
    } on DioException catch (e) {
      return Left(
        Failure(
          message: e.response?.data?.toString() ?? e.message ?? 'Network error',
          code: e.response?.statusCode ?? 0,
        ),
      );
    }
  }

  List<TokenBalanceModel> _calculateBalancesFromTransfers(
    List<TokenTransferModel> transfers,
    String walletAddress,
  ) {
    // Group transfers by token contract address
    final Map<String, List<TokenTransferModel>> tokenGroups = {};

    for (var transfer in transfers) {
      final contractAddr = transfer.contractAddress.toLowerCase();
      tokenGroups.putIfAbsent(contractAddr, () => []).add(transfer);
    }

    // Calculate balance for each token
    final List<TokenBalanceModel> balances = [];

    tokenGroups.forEach((contractAddress, tokenTransfers) {
      if (tokenTransfers.isEmpty) return;

      final firstTransfer = tokenTransfers.first;
      final decimals = int.parse(firstTransfer.tokenDecimal);
      final divisor = BigInt.from(10).pow(decimals);

      BigInt totalBalance = BigInt.zero;

      for (var transfer in tokenTransfers) {
        final value = BigInt.parse(transfer.value);
        final normalizedWallet = walletAddress.toLowerCase();

        if (transfer.to.toLowerCase() == normalizedWallet) {
          totalBalance += value;
        }
        if (transfer.from.toLowerCase() == normalizedWallet) {
          totalBalance -= value;
        }
      }

      if (totalBalance > BigInt.zero) {
        balances.add(
          TokenBalanceModel(
            tokenName: firstTransfer.tokenName,
            tokenSymbol: firstTransfer.tokenSymbol,
            tokenQuantity: totalBalance.toString(),
            tokenDivisor: divisor.toString(),
            contractAddress: contractAddress,
          ),
        );
      }
    });

    return balances;
  }
}
