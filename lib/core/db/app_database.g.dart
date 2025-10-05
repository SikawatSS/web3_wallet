// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BalanceTableTable extends BalanceTable
    with TableInfo<$BalanceTableTable, BalanceEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BalanceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chainIdMeta = const VerificationMeta(
    'chainId',
  );
  @override
  late final GeneratedColumn<int> chainId = GeneratedColumn<int>(
    'chain_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weiAmountMeta = const VerificationMeta(
    'weiAmount',
  );
  @override
  late final GeneratedColumn<String> weiAmount = GeneratedColumn<String>(
    'wei_amount',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    address,
    chainId,
    weiAmount,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'balances';
  @override
  VerificationContext validateIntegrity(
    Insertable<BalanceEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('chain_id')) {
      context.handle(
        _chainIdMeta,
        chainId.isAcceptableOrUnknown(data['chain_id']!, _chainIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chainIdMeta);
    }
    if (data.containsKey('wei_amount')) {
      context.handle(
        _weiAmountMeta,
        weiAmount.isAcceptableOrUnknown(data['wei_amount']!, _weiAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_weiAmountMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {address, chainId};
  @override
  BalanceEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BalanceEntity(
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      chainId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chain_id'],
      )!,
      weiAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wei_amount'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BalanceTableTable createAlias(String alias) {
    return $BalanceTableTable(attachedDatabase, alias);
  }
}

class BalanceEntity extends DataClass implements Insertable<BalanceEntity> {
  final String address;
  final int chainId;
  final String weiAmount;
  final DateTime updatedAt;
  const BalanceEntity({
    required this.address,
    required this.chainId,
    required this.weiAmount,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['address'] = Variable<String>(address);
    map['chain_id'] = Variable<int>(chainId);
    map['wei_amount'] = Variable<String>(weiAmount);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BalanceTableCompanion toCompanion(bool nullToAbsent) {
    return BalanceTableCompanion(
      address: Value(address),
      chainId: Value(chainId),
      weiAmount: Value(weiAmount),
      updatedAt: Value(updatedAt),
    );
  }

  factory BalanceEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BalanceEntity(
      address: serializer.fromJson<String>(json['address']),
      chainId: serializer.fromJson<int>(json['chainId']),
      weiAmount: serializer.fromJson<String>(json['weiAmount']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'address': serializer.toJson<String>(address),
      'chainId': serializer.toJson<int>(chainId),
      'weiAmount': serializer.toJson<String>(weiAmount),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BalanceEntity copyWith({
    String? address,
    int? chainId,
    String? weiAmount,
    DateTime? updatedAt,
  }) => BalanceEntity(
    address: address ?? this.address,
    chainId: chainId ?? this.chainId,
    weiAmount: weiAmount ?? this.weiAmount,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BalanceEntity copyWithCompanion(BalanceTableCompanion data) {
    return BalanceEntity(
      address: data.address.present ? data.address.value : this.address,
      chainId: data.chainId.present ? data.chainId.value : this.chainId,
      weiAmount: data.weiAmount.present ? data.weiAmount.value : this.weiAmount,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BalanceEntity(')
          ..write('address: $address, ')
          ..write('chainId: $chainId, ')
          ..write('weiAmount: $weiAmount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(address, chainId, weiAmount, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BalanceEntity &&
          other.address == this.address &&
          other.chainId == this.chainId &&
          other.weiAmount == this.weiAmount &&
          other.updatedAt == this.updatedAt);
}

class BalanceTableCompanion extends UpdateCompanion<BalanceEntity> {
  final Value<String> address;
  final Value<int> chainId;
  final Value<String> weiAmount;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BalanceTableCompanion({
    this.address = const Value.absent(),
    this.chainId = const Value.absent(),
    this.weiAmount = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BalanceTableCompanion.insert({
    required String address,
    required int chainId,
    required String weiAmount,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : address = Value(address),
       chainId = Value(chainId),
       weiAmount = Value(weiAmount),
       updatedAt = Value(updatedAt);
  static Insertable<BalanceEntity> custom({
    Expression<String>? address,
    Expression<int>? chainId,
    Expression<String>? weiAmount,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (address != null) 'address': address,
      if (chainId != null) 'chain_id': chainId,
      if (weiAmount != null) 'wei_amount': weiAmount,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BalanceTableCompanion copyWith({
    Value<String>? address,
    Value<int>? chainId,
    Value<String>? weiAmount,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BalanceTableCompanion(
      address: address ?? this.address,
      chainId: chainId ?? this.chainId,
      weiAmount: weiAmount ?? this.weiAmount,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (chainId.present) {
      map['chain_id'] = Variable<int>(chainId.value);
    }
    if (weiAmount.present) {
      map['wei_amount'] = Variable<String>(weiAmount.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BalanceTableCompanion(')
          ..write('address: $address, ')
          ..write('chainId: $chainId, ')
          ..write('weiAmount: $weiAmount, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TokenBalanceTableTable extends TokenBalanceTable
    with TableInfo<$TokenBalanceTableTable, TokenBalanceEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TokenBalanceTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chainIdMeta = const VerificationMeta(
    'chainId',
  );
  @override
  late final GeneratedColumn<int> chainId = GeneratedColumn<int>(
    'chain_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contractAddressMeta = const VerificationMeta(
    'contractAddress',
  );
  @override
  late final GeneratedColumn<String> contractAddress = GeneratedColumn<String>(
    'contract_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenNameMeta = const VerificationMeta(
    'tokenName',
  );
  @override
  late final GeneratedColumn<String> tokenName = GeneratedColumn<String>(
    'token_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenSymbolMeta = const VerificationMeta(
    'tokenSymbol',
  );
  @override
  late final GeneratedColumn<String> tokenSymbol = GeneratedColumn<String>(
    'token_symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenQuantityMeta = const VerificationMeta(
    'tokenQuantity',
  );
  @override
  late final GeneratedColumn<String> tokenQuantity = GeneratedColumn<String>(
    'token_quantity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenDivisorMeta = const VerificationMeta(
    'tokenDivisor',
  );
  @override
  late final GeneratedColumn<String> tokenDivisor = GeneratedColumn<String>(
    'token_divisor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    address,
    chainId,
    contractAddress,
    tokenName,
    tokenSymbol,
    tokenQuantity,
    tokenDivisor,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'token_balances';
  @override
  VerificationContext validateIntegrity(
    Insertable<TokenBalanceEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('chain_id')) {
      context.handle(
        _chainIdMeta,
        chainId.isAcceptableOrUnknown(data['chain_id']!, _chainIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chainIdMeta);
    }
    if (data.containsKey('contract_address')) {
      context.handle(
        _contractAddressMeta,
        contractAddress.isAcceptableOrUnknown(
          data['contract_address']!,
          _contractAddressMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contractAddressMeta);
    }
    if (data.containsKey('token_name')) {
      context.handle(
        _tokenNameMeta,
        tokenName.isAcceptableOrUnknown(data['token_name']!, _tokenNameMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenNameMeta);
    }
    if (data.containsKey('token_symbol')) {
      context.handle(
        _tokenSymbolMeta,
        tokenSymbol.isAcceptableOrUnknown(
          data['token_symbol']!,
          _tokenSymbolMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tokenSymbolMeta);
    }
    if (data.containsKey('token_quantity')) {
      context.handle(
        _tokenQuantityMeta,
        tokenQuantity.isAcceptableOrUnknown(
          data['token_quantity']!,
          _tokenQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tokenQuantityMeta);
    }
    if (data.containsKey('token_divisor')) {
      context.handle(
        _tokenDivisorMeta,
        tokenDivisor.isAcceptableOrUnknown(
          data['token_divisor']!,
          _tokenDivisorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tokenDivisorMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {address, chainId, contractAddress};
  @override
  TokenBalanceEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TokenBalanceEntity(
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      chainId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chain_id'],
      )!,
      contractAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contract_address'],
      )!,
      tokenName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token_name'],
      )!,
      tokenSymbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token_symbol'],
      )!,
      tokenQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token_quantity'],
      )!,
      tokenDivisor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token_divisor'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TokenBalanceTableTable createAlias(String alias) {
    return $TokenBalanceTableTable(attachedDatabase, alias);
  }
}

class TokenBalanceEntity extends DataClass
    implements Insertable<TokenBalanceEntity> {
  final String address;
  final int chainId;
  final String contractAddress;
  final String tokenName;
  final String tokenSymbol;
  final String tokenQuantity;
  final String tokenDivisor;
  final DateTime updatedAt;
  const TokenBalanceEntity({
    required this.address,
    required this.chainId,
    required this.contractAddress,
    required this.tokenName,
    required this.tokenSymbol,
    required this.tokenQuantity,
    required this.tokenDivisor,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['address'] = Variable<String>(address);
    map['chain_id'] = Variable<int>(chainId);
    map['contract_address'] = Variable<String>(contractAddress);
    map['token_name'] = Variable<String>(tokenName);
    map['token_symbol'] = Variable<String>(tokenSymbol);
    map['token_quantity'] = Variable<String>(tokenQuantity);
    map['token_divisor'] = Variable<String>(tokenDivisor);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TokenBalanceTableCompanion toCompanion(bool nullToAbsent) {
    return TokenBalanceTableCompanion(
      address: Value(address),
      chainId: Value(chainId),
      contractAddress: Value(contractAddress),
      tokenName: Value(tokenName),
      tokenSymbol: Value(tokenSymbol),
      tokenQuantity: Value(tokenQuantity),
      tokenDivisor: Value(tokenDivisor),
      updatedAt: Value(updatedAt),
    );
  }

  factory TokenBalanceEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TokenBalanceEntity(
      address: serializer.fromJson<String>(json['address']),
      chainId: serializer.fromJson<int>(json['chainId']),
      contractAddress: serializer.fromJson<String>(json['contractAddress']),
      tokenName: serializer.fromJson<String>(json['tokenName']),
      tokenSymbol: serializer.fromJson<String>(json['tokenSymbol']),
      tokenQuantity: serializer.fromJson<String>(json['tokenQuantity']),
      tokenDivisor: serializer.fromJson<String>(json['tokenDivisor']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'address': serializer.toJson<String>(address),
      'chainId': serializer.toJson<int>(chainId),
      'contractAddress': serializer.toJson<String>(contractAddress),
      'tokenName': serializer.toJson<String>(tokenName),
      'tokenSymbol': serializer.toJson<String>(tokenSymbol),
      'tokenQuantity': serializer.toJson<String>(tokenQuantity),
      'tokenDivisor': serializer.toJson<String>(tokenDivisor),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TokenBalanceEntity copyWith({
    String? address,
    int? chainId,
    String? contractAddress,
    String? tokenName,
    String? tokenSymbol,
    String? tokenQuantity,
    String? tokenDivisor,
    DateTime? updatedAt,
  }) => TokenBalanceEntity(
    address: address ?? this.address,
    chainId: chainId ?? this.chainId,
    contractAddress: contractAddress ?? this.contractAddress,
    tokenName: tokenName ?? this.tokenName,
    tokenSymbol: tokenSymbol ?? this.tokenSymbol,
    tokenQuantity: tokenQuantity ?? this.tokenQuantity,
    tokenDivisor: tokenDivisor ?? this.tokenDivisor,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TokenBalanceEntity copyWithCompanion(TokenBalanceTableCompanion data) {
    return TokenBalanceEntity(
      address: data.address.present ? data.address.value : this.address,
      chainId: data.chainId.present ? data.chainId.value : this.chainId,
      contractAddress: data.contractAddress.present
          ? data.contractAddress.value
          : this.contractAddress,
      tokenName: data.tokenName.present ? data.tokenName.value : this.tokenName,
      tokenSymbol: data.tokenSymbol.present
          ? data.tokenSymbol.value
          : this.tokenSymbol,
      tokenQuantity: data.tokenQuantity.present
          ? data.tokenQuantity.value
          : this.tokenQuantity,
      tokenDivisor: data.tokenDivisor.present
          ? data.tokenDivisor.value
          : this.tokenDivisor,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TokenBalanceEntity(')
          ..write('address: $address, ')
          ..write('chainId: $chainId, ')
          ..write('contractAddress: $contractAddress, ')
          ..write('tokenName: $tokenName, ')
          ..write('tokenSymbol: $tokenSymbol, ')
          ..write('tokenQuantity: $tokenQuantity, ')
          ..write('tokenDivisor: $tokenDivisor, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    address,
    chainId,
    contractAddress,
    tokenName,
    tokenSymbol,
    tokenQuantity,
    tokenDivisor,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TokenBalanceEntity &&
          other.address == this.address &&
          other.chainId == this.chainId &&
          other.contractAddress == this.contractAddress &&
          other.tokenName == this.tokenName &&
          other.tokenSymbol == this.tokenSymbol &&
          other.tokenQuantity == this.tokenQuantity &&
          other.tokenDivisor == this.tokenDivisor &&
          other.updatedAt == this.updatedAt);
}

class TokenBalanceTableCompanion extends UpdateCompanion<TokenBalanceEntity> {
  final Value<String> address;
  final Value<int> chainId;
  final Value<String> contractAddress;
  final Value<String> tokenName;
  final Value<String> tokenSymbol;
  final Value<String> tokenQuantity;
  final Value<String> tokenDivisor;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TokenBalanceTableCompanion({
    this.address = const Value.absent(),
    this.chainId = const Value.absent(),
    this.contractAddress = const Value.absent(),
    this.tokenName = const Value.absent(),
    this.tokenSymbol = const Value.absent(),
    this.tokenQuantity = const Value.absent(),
    this.tokenDivisor = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TokenBalanceTableCompanion.insert({
    required String address,
    required int chainId,
    required String contractAddress,
    required String tokenName,
    required String tokenSymbol,
    required String tokenQuantity,
    required String tokenDivisor,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : address = Value(address),
       chainId = Value(chainId),
       contractAddress = Value(contractAddress),
       tokenName = Value(tokenName),
       tokenSymbol = Value(tokenSymbol),
       tokenQuantity = Value(tokenQuantity),
       tokenDivisor = Value(tokenDivisor),
       updatedAt = Value(updatedAt);
  static Insertable<TokenBalanceEntity> custom({
    Expression<String>? address,
    Expression<int>? chainId,
    Expression<String>? contractAddress,
    Expression<String>? tokenName,
    Expression<String>? tokenSymbol,
    Expression<String>? tokenQuantity,
    Expression<String>? tokenDivisor,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (address != null) 'address': address,
      if (chainId != null) 'chain_id': chainId,
      if (contractAddress != null) 'contract_address': contractAddress,
      if (tokenName != null) 'token_name': tokenName,
      if (tokenSymbol != null) 'token_symbol': tokenSymbol,
      if (tokenQuantity != null) 'token_quantity': tokenQuantity,
      if (tokenDivisor != null) 'token_divisor': tokenDivisor,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TokenBalanceTableCompanion copyWith({
    Value<String>? address,
    Value<int>? chainId,
    Value<String>? contractAddress,
    Value<String>? tokenName,
    Value<String>? tokenSymbol,
    Value<String>? tokenQuantity,
    Value<String>? tokenDivisor,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TokenBalanceTableCompanion(
      address: address ?? this.address,
      chainId: chainId ?? this.chainId,
      contractAddress: contractAddress ?? this.contractAddress,
      tokenName: tokenName ?? this.tokenName,
      tokenSymbol: tokenSymbol ?? this.tokenSymbol,
      tokenQuantity: tokenQuantity ?? this.tokenQuantity,
      tokenDivisor: tokenDivisor ?? this.tokenDivisor,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (chainId.present) {
      map['chain_id'] = Variable<int>(chainId.value);
    }
    if (contractAddress.present) {
      map['contract_address'] = Variable<String>(contractAddress.value);
    }
    if (tokenName.present) {
      map['token_name'] = Variable<String>(tokenName.value);
    }
    if (tokenSymbol.present) {
      map['token_symbol'] = Variable<String>(tokenSymbol.value);
    }
    if (tokenQuantity.present) {
      map['token_quantity'] = Variable<String>(tokenQuantity.value);
    }
    if (tokenDivisor.present) {
      map['token_divisor'] = Variable<String>(tokenDivisor.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TokenBalanceTableCompanion(')
          ..write('address: $address, ')
          ..write('chainId: $chainId, ')
          ..write('contractAddress: $contractAddress, ')
          ..write('tokenName: $tokenName, ')
          ..write('tokenSymbol: $tokenSymbol, ')
          ..write('tokenQuantity: $tokenQuantity, ')
          ..write('tokenDivisor: $tokenDivisor, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BalanceTableTable balanceTable = $BalanceTableTable(this);
  late final $TokenBalanceTableTable tokenBalanceTable =
      $TokenBalanceTableTable(this);
  late final BalanceDao balanceDao = BalanceDao(this as AppDatabase);
  late final TokenBalanceDao tokenBalanceDao = TokenBalanceDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    balanceTable,
    tokenBalanceTable,
  ];
}

typedef $$BalanceTableTableCreateCompanionBuilder =
    BalanceTableCompanion Function({
      required String address,
      required int chainId,
      required String weiAmount,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$BalanceTableTableUpdateCompanionBuilder =
    BalanceTableCompanion Function({
      Value<String> address,
      Value<int> chainId,
      Value<String> weiAmount,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$BalanceTableTableFilterComposer
    extends Composer<_$AppDatabase, $BalanceTableTable> {
  $$BalanceTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chainId => $composableBuilder(
    column: $table.chainId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weiAmount => $composableBuilder(
    column: $table.weiAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BalanceTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BalanceTableTable> {
  $$BalanceTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chainId => $composableBuilder(
    column: $table.chainId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weiAmount => $composableBuilder(
    column: $table.weiAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BalanceTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BalanceTableTable> {
  $$BalanceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<int> get chainId =>
      $composableBuilder(column: $table.chainId, builder: (column) => column);

  GeneratedColumn<String> get weiAmount =>
      $composableBuilder(column: $table.weiAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BalanceTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BalanceTableTable,
          BalanceEntity,
          $$BalanceTableTableFilterComposer,
          $$BalanceTableTableOrderingComposer,
          $$BalanceTableTableAnnotationComposer,
          $$BalanceTableTableCreateCompanionBuilder,
          $$BalanceTableTableUpdateCompanionBuilder,
          (
            BalanceEntity,
            BaseReferences<_$AppDatabase, $BalanceTableTable, BalanceEntity>,
          ),
          BalanceEntity,
          PrefetchHooks Function()
        > {
  $$BalanceTableTableTableManager(_$AppDatabase db, $BalanceTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BalanceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BalanceTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BalanceTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> address = const Value.absent(),
                Value<int> chainId = const Value.absent(),
                Value<String> weiAmount = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BalanceTableCompanion(
                address: address,
                chainId: chainId,
                weiAmount: weiAmount,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String address,
                required int chainId,
                required String weiAmount,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BalanceTableCompanion.insert(
                address: address,
                chainId: chainId,
                weiAmount: weiAmount,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BalanceTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BalanceTableTable,
      BalanceEntity,
      $$BalanceTableTableFilterComposer,
      $$BalanceTableTableOrderingComposer,
      $$BalanceTableTableAnnotationComposer,
      $$BalanceTableTableCreateCompanionBuilder,
      $$BalanceTableTableUpdateCompanionBuilder,
      (
        BalanceEntity,
        BaseReferences<_$AppDatabase, $BalanceTableTable, BalanceEntity>,
      ),
      BalanceEntity,
      PrefetchHooks Function()
    >;
typedef $$TokenBalanceTableTableCreateCompanionBuilder =
    TokenBalanceTableCompanion Function({
      required String address,
      required int chainId,
      required String contractAddress,
      required String tokenName,
      required String tokenSymbol,
      required String tokenQuantity,
      required String tokenDivisor,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TokenBalanceTableTableUpdateCompanionBuilder =
    TokenBalanceTableCompanion Function({
      Value<String> address,
      Value<int> chainId,
      Value<String> contractAddress,
      Value<String> tokenName,
      Value<String> tokenSymbol,
      Value<String> tokenQuantity,
      Value<String> tokenDivisor,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TokenBalanceTableTableFilterComposer
    extends Composer<_$AppDatabase, $TokenBalanceTableTable> {
  $$TokenBalanceTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chainId => $composableBuilder(
    column: $table.chainId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contractAddress => $composableBuilder(
    column: $table.contractAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tokenName => $composableBuilder(
    column: $table.tokenName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tokenSymbol => $composableBuilder(
    column: $table.tokenSymbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tokenQuantity => $composableBuilder(
    column: $table.tokenQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tokenDivisor => $composableBuilder(
    column: $table.tokenDivisor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TokenBalanceTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TokenBalanceTableTable> {
  $$TokenBalanceTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chainId => $composableBuilder(
    column: $table.chainId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contractAddress => $composableBuilder(
    column: $table.contractAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tokenName => $composableBuilder(
    column: $table.tokenName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tokenSymbol => $composableBuilder(
    column: $table.tokenSymbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tokenQuantity => $composableBuilder(
    column: $table.tokenQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tokenDivisor => $composableBuilder(
    column: $table.tokenDivisor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TokenBalanceTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TokenBalanceTableTable> {
  $$TokenBalanceTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<int> get chainId =>
      $composableBuilder(column: $table.chainId, builder: (column) => column);

  GeneratedColumn<String> get contractAddress => $composableBuilder(
    column: $table.contractAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tokenName =>
      $composableBuilder(column: $table.tokenName, builder: (column) => column);

  GeneratedColumn<String> get tokenSymbol => $composableBuilder(
    column: $table.tokenSymbol,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tokenQuantity => $composableBuilder(
    column: $table.tokenQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tokenDivisor => $composableBuilder(
    column: $table.tokenDivisor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TokenBalanceTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TokenBalanceTableTable,
          TokenBalanceEntity,
          $$TokenBalanceTableTableFilterComposer,
          $$TokenBalanceTableTableOrderingComposer,
          $$TokenBalanceTableTableAnnotationComposer,
          $$TokenBalanceTableTableCreateCompanionBuilder,
          $$TokenBalanceTableTableUpdateCompanionBuilder,
          (
            TokenBalanceEntity,
            BaseReferences<
              _$AppDatabase,
              $TokenBalanceTableTable,
              TokenBalanceEntity
            >,
          ),
          TokenBalanceEntity,
          PrefetchHooks Function()
        > {
  $$TokenBalanceTableTableTableManager(
    _$AppDatabase db,
    $TokenBalanceTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TokenBalanceTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TokenBalanceTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TokenBalanceTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> address = const Value.absent(),
                Value<int> chainId = const Value.absent(),
                Value<String> contractAddress = const Value.absent(),
                Value<String> tokenName = const Value.absent(),
                Value<String> tokenSymbol = const Value.absent(),
                Value<String> tokenQuantity = const Value.absent(),
                Value<String> tokenDivisor = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TokenBalanceTableCompanion(
                address: address,
                chainId: chainId,
                contractAddress: contractAddress,
                tokenName: tokenName,
                tokenSymbol: tokenSymbol,
                tokenQuantity: tokenQuantity,
                tokenDivisor: tokenDivisor,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String address,
                required int chainId,
                required String contractAddress,
                required String tokenName,
                required String tokenSymbol,
                required String tokenQuantity,
                required String tokenDivisor,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TokenBalanceTableCompanion.insert(
                address: address,
                chainId: chainId,
                contractAddress: contractAddress,
                tokenName: tokenName,
                tokenSymbol: tokenSymbol,
                tokenQuantity: tokenQuantity,
                tokenDivisor: tokenDivisor,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TokenBalanceTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TokenBalanceTableTable,
      TokenBalanceEntity,
      $$TokenBalanceTableTableFilterComposer,
      $$TokenBalanceTableTableOrderingComposer,
      $$TokenBalanceTableTableAnnotationComposer,
      $$TokenBalanceTableTableCreateCompanionBuilder,
      $$TokenBalanceTableTableUpdateCompanionBuilder,
      (
        TokenBalanceEntity,
        BaseReferences<
          _$AppDatabase,
          $TokenBalanceTableTable,
          TokenBalanceEntity
        >,
      ),
      TokenBalanceEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BalanceTableTableTableManager get balanceTable =>
      $$BalanceTableTableTableManager(_db, _db.balanceTable);
  $$TokenBalanceTableTableTableManager get tokenBalanceTable =>
      $$TokenBalanceTableTableTableManager(_db, _db.tokenBalanceTable);
}
