/// Mock data fixtures for TokenBalance-related tests
class TokenBalanceFixture {
  /// Valid token transfer response
  static Map<String, dynamic> validTokenTransferResponse() {
    return {
      'status': '1',
      'message': 'OK',
      'result': [
        {
          'blockNumber': '5000000',
          'timeStamp': '1678901234',
          'hash': '0xabc123',
          'nonce': '1',
          'blockHash': '0xdef456',
          'from': '0x0000000000000000000000000000000000000000',
          'contractAddress': '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
          'to': '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb',
          'value': '1000000', // 1 USDC (6 decimals)
          'tokenName': 'USD Coin',
          'tokenSymbol': 'USDC',
          'tokenDecimal': '6',
          'transactionIndex': '1',
          'gas': '21000',
          'gasPrice': '1000000000',
          'gasUsed': '21000',
          'cumulativeGasUsed': '21000',
          'input': 'deprecated',
          'confirmations': '100',
        },
      ],
    };
  }

  /// Multiple token transfers (in and out)
  static Map<String, dynamic> multipleTransfersResponse(String walletAddress) {
    return {
      'status': '1',
      'message': 'OK',
      'result': [
        // Incoming 10 USDC
        {
          'blockNumber': '5000001',
          'timeStamp': '1678901234',
          'hash': '0xabc123',
          'from': '0x0000000000000000000000000000000000000000',
          'contractAddress': '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
          'to': walletAddress,
          'value': '10000000',
          'tokenName': 'USD Coin',
          'tokenSymbol': 'USDC',
          'tokenDecimal': '6',
        },
        // Outgoing 3 USDC
        {
          'blockNumber': '5000002',
          'timeStamp': '1678901235',
          'hash': '0xabc124',
          'from': walletAddress,
          'contractAddress': '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
          'to': '0x1111111111111111111111111111111111111111',
          'value': '3000000',
          'tokenName': 'USD Coin',
          'tokenSymbol': 'USDC',
          'tokenDecimal': '6',
        },
        // Incoming 5 USDC
        {
          'blockNumber': '5000003',
          'timeStamp': '1678901236',
          'hash': '0xabc125',
          'from': '0x2222222222222222222222222222222222222222',
          'contractAddress': '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
          'to': walletAddress,
          'value': '5000000',
          'tokenName': 'USD Coin',
          'tokenSymbol': 'USDC',
          'tokenDecimal': '6',
        },
        // Different token (DAI) incoming 100 DAI
        {
          'blockNumber': '5000004',
          'timeStamp': '1678901237',
          'hash': '0xabc126',
          'from': '0x3333333333333333333333333333333333333333',
          'contractAddress': '0x6b175474e89094c44da98b954eedeac495271d0f',
          'to': walletAddress,
          'value': '100000000000000000000',
          'tokenName': 'Dai Stablecoin',
          'tokenSymbol': 'DAI',
          'tokenDecimal': '18',
        },
      ],
    };
  }

  /// Empty token list response
  static Map<String, dynamic> emptyTokenListResponse() {
    return {
      'status': '1',
      'message': 'OK',
      'result': [],
    };
  }

  /// No transactions found (status 0)
  static Map<String, dynamic> noTransactionsResponse() {
    return {
      'status': '0',
      'message': 'No transactions found',
      'result': null,
    };
  }

  /// All outgoing transfers (zero balance)
  static Map<String, dynamic> zeroBalanceResponse(String walletAddress) {
    return {
      'status': '1',
      'message': 'OK',
      'result': [
        // Incoming 10 USDC
        {
          'blockNumber': '5000005',
          'timeStamp': '1678901240',
          'hash': '0xabc127',
          'from': '0x0000000000000000000000000000000000000000',
          'contractAddress': '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
          'to': walletAddress,
          'value': '10000000',
          'tokenName': 'USD Coin',
          'tokenSymbol': 'USDC',
          'tokenDecimal': '6',
        },
        // Outgoing 10 USDC (all spent)
        {
          'blockNumber': '5000006',
          'timeStamp': '1678901241',
          'hash': '0xabc128',
          'from': walletAddress,
          'contractAddress': '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
          'to': '0x1111111111111111111111111111111111111111',
          'value': '10000000',
          'tokenName': 'USD Coin',
          'tokenSymbol': 'USDC',
          'tokenDecimal': '6',
        },
      ],
    };
  }

  /// Single token balance model data
  static Map<String, dynamic> singleTokenBalanceData() {
    return {
      'TokenName': 'USD Coin',
      'TokenSymbol': 'USDC',
      'TokenQuantity': '1000000',
      'TokenDivisor': '1000000',
      'ContractAddress': '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48',
    };
  }

  /// Token balance with missing contract address
  static Map<String, dynamic> tokenBalanceWithoutContractAddress() {
    return {
      'TokenName': 'Test Token',
      'TokenSymbol': 'TEST',
      'TokenQuantity': '1000000',
      'TokenDivisor': '1000000',
    };
  }
}
