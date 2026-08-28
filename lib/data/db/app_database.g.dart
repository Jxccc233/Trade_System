// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $InstrumentsTable extends Instruments
    with TableInfo<$InstrumentsTable, Instrument> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstrumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 12),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _marketMeta = const VerificationMeta('market');
  @override
  late final GeneratedColumn<String> market = GeneratedColumn<String>(
      'market', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 4),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(InstrumentType.stock));
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, code, name, market, type, isFavorite, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'instruments';
  @override
  VerificationContext validateIntegrity(Insertable<Instrument> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('market')) {
      context.handle(_marketMeta,
          market.isAcceptableOrUnknown(data['market']!, _marketMeta));
    } else if (isInserting) {
      context.missing(_marketMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {code, market},
      ];
  @override
  Instrument map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Instrument(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      market: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}market'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $InstrumentsTable createAlias(String alias) {
    return $InstrumentsTable(attachedDatabase, alias);
  }
}

class Instrument extends DataClass implements Insertable<Instrument> {
  final int id;
  final String code;
  final String name;
  final String market;

  /// 见 [InstrumentType]
  final String type;
  final bool isFavorite;
  final DateTime createdAt;
  const Instrument(
      {required this.id,
      required this.code,
      required this.name,
      required this.market,
      required this.type,
      required this.isFavorite,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['market'] = Variable<String>(market);
    map['type'] = Variable<String>(type);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  InstrumentsCompanion toCompanion(bool nullToAbsent) {
    return InstrumentsCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      market: Value(market),
      type: Value(type),
      isFavorite: Value(isFavorite),
      createdAt: Value(createdAt),
    );
  }

  factory Instrument.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Instrument(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      market: serializer.fromJson<String>(json['market']),
      type: serializer.fromJson<String>(json['type']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'market': serializer.toJson<String>(market),
      'type': serializer.toJson<String>(type),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Instrument copyWith(
          {int? id,
          String? code,
          String? name,
          String? market,
          String? type,
          bool? isFavorite,
          DateTime? createdAt}) =>
      Instrument(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        market: market ?? this.market,
        type: type ?? this.type,
        isFavorite: isFavorite ?? this.isFavorite,
        createdAt: createdAt ?? this.createdAt,
      );
  Instrument copyWithCompanion(InstrumentsCompanion data) {
    return Instrument(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      market: data.market.present ? data.market.value : this.market,
      type: data.type.present ? data.type.value : this.type,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Instrument(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('market: $market, ')
          ..write('type: $type, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, name, market, type, isFavorite, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Instrument &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.market == this.market &&
          other.type == this.type &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt);
}

class InstrumentsCompanion extends UpdateCompanion<Instrument> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String> market;
  final Value<String> type;
  final Value<bool> isFavorite;
  final Value<DateTime> createdAt;
  const InstrumentsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.market = const Value.absent(),
    this.type = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InstrumentsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    required String market,
    this.type = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : code = Value(code),
        name = Value(name),
        market = Value(market);
  static Insertable<Instrument> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? market,
    Expression<String>? type,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (market != null) 'market': market,
      if (type != null) 'type': type,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InstrumentsCompanion copyWith(
      {Value<int>? id,
      Value<String>? code,
      Value<String>? name,
      Value<String>? market,
      Value<String>? type,
      Value<bool>? isFavorite,
      Value<DateTime>? createdAt}) {
    return InstrumentsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      market: market ?? this.market,
      type: type ?? this.type,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (market.present) {
      map['market'] = Variable<String>(market.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstrumentsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('market: $market, ')
          ..write('type: $type, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TradesTable extends Trades with TableInfo<$TradesTable, Trade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TradesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _instrumentIdMeta =
      const VerificationMeta('instrumentId');
  @override
  late final GeneratedColumn<int> instrumentId = GeneratedColumn<int>(
      'instrument_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES instruments (id)'));
  static const VerificationMeta _tradedAtMeta =
      const VerificationMeta('tradedAt');
  @override
  late final GeneratedColumn<DateTime> tradedAt = GeneratedColumn<DateTime>(
      'traded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sideMeta = const VerificationMeta('side');
  @override
  late final GeneratedColumn<String> side = GeneratedColumn<String>(
      'side', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _feeMeta = const VerificationMeta('fee');
  @override
  late final GeneratedColumn<double> fee = GeneratedColumn<double>(
      'fee', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emotionMeta =
      const VerificationMeta('emotion');
  @override
  late final GeneratedColumn<String> emotion = GeneratedColumn<String>(
      'emotion', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tagIdsMeta = const VerificationMeta('tagIds');
  @override
  late final GeneratedColumn<String> tagIds = GeneratedColumn<String>(
      'tag_ids', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _imagesMeta = const VerificationMeta('images');
  @override
  late final GeneratedColumn<String> images = GeneratedColumn<String>(
      'images', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        instrumentId,
        tradedAt,
        side,
        price,
        quantity,
        fee,
        reason,
        emotion,
        tagIds,
        images,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trades';
  @override
  VerificationContext validateIntegrity(Insertable<Trade> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('instrument_id')) {
      context.handle(
          _instrumentIdMeta,
          instrumentId.isAcceptableOrUnknown(
              data['instrument_id']!, _instrumentIdMeta));
    } else if (isInserting) {
      context.missing(_instrumentIdMeta);
    }
    if (data.containsKey('traded_at')) {
      context.handle(_tradedAtMeta,
          tradedAt.isAcceptableOrUnknown(data['traded_at']!, _tradedAtMeta));
    } else if (isInserting) {
      context.missing(_tradedAtMeta);
    }
    if (data.containsKey('side')) {
      context.handle(
          _sideMeta, side.isAcceptableOrUnknown(data['side']!, _sideMeta));
    } else if (isInserting) {
      context.missing(_sideMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('fee')) {
      context.handle(
          _feeMeta, fee.isAcceptableOrUnknown(data['fee']!, _feeMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('emotion')) {
      context.handle(_emotionMeta,
          emotion.isAcceptableOrUnknown(data['emotion']!, _emotionMeta));
    }
    if (data.containsKey('tag_ids')) {
      context.handle(_tagIdsMeta,
          tagIds.isAcceptableOrUnknown(data['tag_ids']!, _tagIdsMeta));
    }
    if (data.containsKey('images')) {
      context.handle(_imagesMeta,
          images.isAcceptableOrUnknown(data['images']!, _imagesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trade(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      instrumentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}instrument_id'])!,
      tradedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}traded_at'])!,
      side: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}side'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      fee: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fee'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      emotion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emotion']),
      tagIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag_ids'])!,
      images: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}images'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TradesTable createAlias(String alias) {
    return $TradesTable(attachedDatabase, alias);
  }
}

class Trade extends DataClass implements Insertable<Trade> {
  final int id;
  final int instrumentId;

  /// 成交时间（盘后补记也允许）
  final DateTime tradedAt;

  /// 见 [TradeSide]
  final String side;
  final double price;
  final double quantity;
  final double fee;

  /// 买卖理由
  final String? reason;

  /// 情绪标记（冷静 / 冲动 / FOMO / 止损……）
  final String? emotion;

  /// JSON 数组：标签 id 列表
  final String tagIds;

  /// JSON 数组：截图相对路径列表
  final String images;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Trade(
      {required this.id,
      required this.instrumentId,
      required this.tradedAt,
      required this.side,
      required this.price,
      required this.quantity,
      required this.fee,
      this.reason,
      this.emotion,
      required this.tagIds,
      required this.images,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['instrument_id'] = Variable<int>(instrumentId);
    map['traded_at'] = Variable<DateTime>(tradedAt);
    map['side'] = Variable<String>(side);
    map['price'] = Variable<double>(price);
    map['quantity'] = Variable<double>(quantity);
    map['fee'] = Variable<double>(fee);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || emotion != null) {
      map['emotion'] = Variable<String>(emotion);
    }
    map['tag_ids'] = Variable<String>(tagIds);
    map['images'] = Variable<String>(images);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TradesCompanion toCompanion(bool nullToAbsent) {
    return TradesCompanion(
      id: Value(id),
      instrumentId: Value(instrumentId),
      tradedAt: Value(tradedAt),
      side: Value(side),
      price: Value(price),
      quantity: Value(quantity),
      fee: Value(fee),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      emotion: emotion == null && nullToAbsent
          ? const Value.absent()
          : Value(emotion),
      tagIds: Value(tagIds),
      images: Value(images),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Trade.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trade(
      id: serializer.fromJson<int>(json['id']),
      instrumentId: serializer.fromJson<int>(json['instrumentId']),
      tradedAt: serializer.fromJson<DateTime>(json['tradedAt']),
      side: serializer.fromJson<String>(json['side']),
      price: serializer.fromJson<double>(json['price']),
      quantity: serializer.fromJson<double>(json['quantity']),
      fee: serializer.fromJson<double>(json['fee']),
      reason: serializer.fromJson<String?>(json['reason']),
      emotion: serializer.fromJson<String?>(json['emotion']),
      tagIds: serializer.fromJson<String>(json['tagIds']),
      images: serializer.fromJson<String>(json['images']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'instrumentId': serializer.toJson<int>(instrumentId),
      'tradedAt': serializer.toJson<DateTime>(tradedAt),
      'side': serializer.toJson<String>(side),
      'price': serializer.toJson<double>(price),
      'quantity': serializer.toJson<double>(quantity),
      'fee': serializer.toJson<double>(fee),
      'reason': serializer.toJson<String?>(reason),
      'emotion': serializer.toJson<String?>(emotion),
      'tagIds': serializer.toJson<String>(tagIds),
      'images': serializer.toJson<String>(images),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Trade copyWith(
          {int? id,
          int? instrumentId,
          DateTime? tradedAt,
          String? side,
          double? price,
          double? quantity,
          double? fee,
          Value<String?> reason = const Value.absent(),
          Value<String?> emotion = const Value.absent(),
          String? tagIds,
          String? images,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Trade(
        id: id ?? this.id,
        instrumentId: instrumentId ?? this.instrumentId,
        tradedAt: tradedAt ?? this.tradedAt,
        side: side ?? this.side,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        fee: fee ?? this.fee,
        reason: reason.present ? reason.value : this.reason,
        emotion: emotion.present ? emotion.value : this.emotion,
        tagIds: tagIds ?? this.tagIds,
        images: images ?? this.images,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Trade copyWithCompanion(TradesCompanion data) {
    return Trade(
      id: data.id.present ? data.id.value : this.id,
      instrumentId: data.instrumentId.present
          ? data.instrumentId.value
          : this.instrumentId,
      tradedAt: data.tradedAt.present ? data.tradedAt.value : this.tradedAt,
      side: data.side.present ? data.side.value : this.side,
      price: data.price.present ? data.price.value : this.price,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      fee: data.fee.present ? data.fee.value : this.fee,
      reason: data.reason.present ? data.reason.value : this.reason,
      emotion: data.emotion.present ? data.emotion.value : this.emotion,
      tagIds: data.tagIds.present ? data.tagIds.value : this.tagIds,
      images: data.images.present ? data.images.value : this.images,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trade(')
          ..write('id: $id, ')
          ..write('instrumentId: $instrumentId, ')
          ..write('tradedAt: $tradedAt, ')
          ..write('side: $side, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('fee: $fee, ')
          ..write('reason: $reason, ')
          ..write('emotion: $emotion, ')
          ..write('tagIds: $tagIds, ')
          ..write('images: $images, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, instrumentId, tradedAt, side, price,
      quantity, fee, reason, emotion, tagIds, images, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trade &&
          other.id == this.id &&
          other.instrumentId == this.instrumentId &&
          other.tradedAt == this.tradedAt &&
          other.side == this.side &&
          other.price == this.price &&
          other.quantity == this.quantity &&
          other.fee == this.fee &&
          other.reason == this.reason &&
          other.emotion == this.emotion &&
          other.tagIds == this.tagIds &&
          other.images == this.images &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TradesCompanion extends UpdateCompanion<Trade> {
  final Value<int> id;
  final Value<int> instrumentId;
  final Value<DateTime> tradedAt;
  final Value<String> side;
  final Value<double> price;
  final Value<double> quantity;
  final Value<double> fee;
  final Value<String?> reason;
  final Value<String?> emotion;
  final Value<String> tagIds;
  final Value<String> images;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TradesCompanion({
    this.id = const Value.absent(),
    this.instrumentId = const Value.absent(),
    this.tradedAt = const Value.absent(),
    this.side = const Value.absent(),
    this.price = const Value.absent(),
    this.quantity = const Value.absent(),
    this.fee = const Value.absent(),
    this.reason = const Value.absent(),
    this.emotion = const Value.absent(),
    this.tagIds = const Value.absent(),
    this.images = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TradesCompanion.insert({
    this.id = const Value.absent(),
    required int instrumentId,
    required DateTime tradedAt,
    required String side,
    required double price,
    required double quantity,
    this.fee = const Value.absent(),
    this.reason = const Value.absent(),
    this.emotion = const Value.absent(),
    this.tagIds = const Value.absent(),
    this.images = const Value.absent(),
    this.createdAt = const Value.absent(),
    required DateTime updatedAt,
  })  : instrumentId = Value(instrumentId),
        tradedAt = Value(tradedAt),
        side = Value(side),
        price = Value(price),
        quantity = Value(quantity),
        updatedAt = Value(updatedAt);
  static Insertable<Trade> custom({
    Expression<int>? id,
    Expression<int>? instrumentId,
    Expression<DateTime>? tradedAt,
    Expression<String>? side,
    Expression<double>? price,
    Expression<double>? quantity,
    Expression<double>? fee,
    Expression<String>? reason,
    Expression<String>? emotion,
    Expression<String>? tagIds,
    Expression<String>? images,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (instrumentId != null) 'instrument_id': instrumentId,
      if (tradedAt != null) 'traded_at': tradedAt,
      if (side != null) 'side': side,
      if (price != null) 'price': price,
      if (quantity != null) 'quantity': quantity,
      if (fee != null) 'fee': fee,
      if (reason != null) 'reason': reason,
      if (emotion != null) 'emotion': emotion,
      if (tagIds != null) 'tag_ids': tagIds,
      if (images != null) 'images': images,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TradesCompanion copyWith(
      {Value<int>? id,
      Value<int>? instrumentId,
      Value<DateTime>? tradedAt,
      Value<String>? side,
      Value<double>? price,
      Value<double>? quantity,
      Value<double>? fee,
      Value<String?>? reason,
      Value<String?>? emotion,
      Value<String>? tagIds,
      Value<String>? images,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return TradesCompanion(
      id: id ?? this.id,
      instrumentId: instrumentId ?? this.instrumentId,
      tradedAt: tradedAt ?? this.tradedAt,
      side: side ?? this.side,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      fee: fee ?? this.fee,
      reason: reason ?? this.reason,
      emotion: emotion ?? this.emotion,
      tagIds: tagIds ?? this.tagIds,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (instrumentId.present) {
      map['instrument_id'] = Variable<int>(instrumentId.value);
    }
    if (tradedAt.present) {
      map['traded_at'] = Variable<DateTime>(tradedAt.value);
    }
    if (side.present) {
      map['side'] = Variable<String>(side.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (fee.present) {
      map['fee'] = Variable<double>(fee.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (emotion.present) {
      map['emotion'] = Variable<String>(emotion.value);
    }
    if (tagIds.present) {
      map['tag_ids'] = Variable<String>(tagIds.value);
    }
    if (images.present) {
      map['images'] = Variable<String>(images.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TradesCompanion(')
          ..write('id: $id, ')
          ..write('instrumentId: $instrumentId, ')
          ..write('tradedAt: $tradedAt, ')
          ..write('side: $side, ')
          ..write('price: $price, ')
          ..write('quantity: $quantity, ')
          ..write('fee: $fee, ')
          ..write('reason: $reason, ')
          ..write('emotion: $emotion, ')
          ..write('tagIds: $tagIds, ')
          ..write('images: $images, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyReviewsTable extends DailyReviews
    with TableInfo<$DailyReviewsTable, DailyReview> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyReviewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 10, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _marketNoteMeta =
      const VerificationMeta('marketNote');
  @override
  late final GeneratedColumn<String> marketNote = GeneratedColumn<String>(
      'market_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _didRightMeta =
      const VerificationMeta('didRight');
  @override
  late final GeneratedColumn<String> didRight = GeneratedColumn<String>(
      'did_right', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _didWrongMeta =
      const VerificationMeta('didWrong');
  @override
  late final GeneratedColumn<String> didWrong = GeneratedColumn<String>(
      'did_wrong', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _planMeta = const VerificationMeta('plan');
  @override
  late final GeneratedColumn<String> plan = GeneratedColumn<String>(
      'plan', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
      'mood', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _checklistMeta =
      const VerificationMeta('checklist');
  @override
  late final GeneratedColumn<String> checklist = GeneratedColumn<String>(
      'checklist', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _imagesMeta = const VerificationMeta('images');
  @override
  late final GeneratedColumn<String> images = GeneratedColumn<String>(
      'images', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        marketNote,
        didRight,
        didWrong,
        plan,
        mood,
        checklist,
        images,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_reviews';
  @override
  VerificationContext validateIntegrity(Insertable<DailyReview> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('market_note')) {
      context.handle(
          _marketNoteMeta,
          marketNote.isAcceptableOrUnknown(
              data['market_note']!, _marketNoteMeta));
    }
    if (data.containsKey('did_right')) {
      context.handle(_didRightMeta,
          didRight.isAcceptableOrUnknown(data['did_right']!, _didRightMeta));
    }
    if (data.containsKey('did_wrong')) {
      context.handle(_didWrongMeta,
          didWrong.isAcceptableOrUnknown(data['did_wrong']!, _didWrongMeta));
    }
    if (data.containsKey('plan')) {
      context.handle(
          _planMeta, plan.isAcceptableOrUnknown(data['plan']!, _planMeta));
    }
    if (data.containsKey('mood')) {
      context.handle(
          _moodMeta, mood.isAcceptableOrUnknown(data['mood']!, _moodMeta));
    }
    if (data.containsKey('checklist')) {
      context.handle(_checklistMeta,
          checklist.isAcceptableOrUnknown(data['checklist']!, _checklistMeta));
    }
    if (data.containsKey('images')) {
      context.handle(_imagesMeta,
          images.isAcceptableOrUnknown(data['images']!, _imagesMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {date},
      ];
  @override
  DailyReview map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyReview(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      marketNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}market_note']),
      didRight: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}did_right']),
      didWrong: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}did_wrong']),
      plan: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan']),
      mood: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mood']),
      checklist: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}checklist'])!,
      images: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}images'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DailyReviewsTable createAlias(String alias) {
    return $DailyReviewsTable(attachedDatabase, alias);
  }
}

class DailyReview extends DataClass implements Insertable<DailyReview> {
  final int id;

  /// yyyy-MM-dd，唯一
  final String date;
  final String? marketNote;
  final String? didRight;
  final String? didWrong;
  final String? plan;

  /// 心态自评 1–5
  final int? mood;

  /// JSON 对象：纪律清单 {条目: 是否做到}
  final String checklist;
  final String images;
  final DateTime updatedAt;
  const DailyReview(
      {required this.id,
      required this.date,
      this.marketNote,
      this.didRight,
      this.didWrong,
      this.plan,
      this.mood,
      required this.checklist,
      required this.images,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || marketNote != null) {
      map['market_note'] = Variable<String>(marketNote);
    }
    if (!nullToAbsent || didRight != null) {
      map['did_right'] = Variable<String>(didRight);
    }
    if (!nullToAbsent || didWrong != null) {
      map['did_wrong'] = Variable<String>(didWrong);
    }
    if (!nullToAbsent || plan != null) {
      map['plan'] = Variable<String>(plan);
    }
    if (!nullToAbsent || mood != null) {
      map['mood'] = Variable<int>(mood);
    }
    map['checklist'] = Variable<String>(checklist);
    map['images'] = Variable<String>(images);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyReviewsCompanion toCompanion(bool nullToAbsent) {
    return DailyReviewsCompanion(
      id: Value(id),
      date: Value(date),
      marketNote: marketNote == null && nullToAbsent
          ? const Value.absent()
          : Value(marketNote),
      didRight: didRight == null && nullToAbsent
          ? const Value.absent()
          : Value(didRight),
      didWrong: didWrong == null && nullToAbsent
          ? const Value.absent()
          : Value(didWrong),
      plan: plan == null && nullToAbsent ? const Value.absent() : Value(plan),
      mood: mood == null && nullToAbsent ? const Value.absent() : Value(mood),
      checklist: Value(checklist),
      images: Value(images),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyReview.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyReview(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      marketNote: serializer.fromJson<String?>(json['marketNote']),
      didRight: serializer.fromJson<String?>(json['didRight']),
      didWrong: serializer.fromJson<String?>(json['didWrong']),
      plan: serializer.fromJson<String?>(json['plan']),
      mood: serializer.fromJson<int?>(json['mood']),
      checklist: serializer.fromJson<String>(json['checklist']),
      images: serializer.fromJson<String>(json['images']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'marketNote': serializer.toJson<String?>(marketNote),
      'didRight': serializer.toJson<String?>(didRight),
      'didWrong': serializer.toJson<String?>(didWrong),
      'plan': serializer.toJson<String?>(plan),
      'mood': serializer.toJson<int?>(mood),
      'checklist': serializer.toJson<String>(checklist),
      'images': serializer.toJson<String>(images),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyReview copyWith(
          {int? id,
          String? date,
          Value<String?> marketNote = const Value.absent(),
          Value<String?> didRight = const Value.absent(),
          Value<String?> didWrong = const Value.absent(),
          Value<String?> plan = const Value.absent(),
          Value<int?> mood = const Value.absent(),
          String? checklist,
          String? images,
          DateTime? updatedAt}) =>
      DailyReview(
        id: id ?? this.id,
        date: date ?? this.date,
        marketNote: marketNote.present ? marketNote.value : this.marketNote,
        didRight: didRight.present ? didRight.value : this.didRight,
        didWrong: didWrong.present ? didWrong.value : this.didWrong,
        plan: plan.present ? plan.value : this.plan,
        mood: mood.present ? mood.value : this.mood,
        checklist: checklist ?? this.checklist,
        images: images ?? this.images,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DailyReview copyWithCompanion(DailyReviewsCompanion data) {
    return DailyReview(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      marketNote:
          data.marketNote.present ? data.marketNote.value : this.marketNote,
      didRight: data.didRight.present ? data.didRight.value : this.didRight,
      didWrong: data.didWrong.present ? data.didWrong.value : this.didWrong,
      plan: data.plan.present ? data.plan.value : this.plan,
      mood: data.mood.present ? data.mood.value : this.mood,
      checklist: data.checklist.present ? data.checklist.value : this.checklist,
      images: data.images.present ? data.images.value : this.images,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyReview(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('marketNote: $marketNote, ')
          ..write('didRight: $didRight, ')
          ..write('didWrong: $didWrong, ')
          ..write('plan: $plan, ')
          ..write('mood: $mood, ')
          ..write('checklist: $checklist, ')
          ..write('images: $images, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, marketNote, didRight, didWrong,
      plan, mood, checklist, images, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyReview &&
          other.id == this.id &&
          other.date == this.date &&
          other.marketNote == this.marketNote &&
          other.didRight == this.didRight &&
          other.didWrong == this.didWrong &&
          other.plan == this.plan &&
          other.mood == this.mood &&
          other.checklist == this.checklist &&
          other.images == this.images &&
          other.updatedAt == this.updatedAt);
}

class DailyReviewsCompanion extends UpdateCompanion<DailyReview> {
  final Value<int> id;
  final Value<String> date;
  final Value<String?> marketNote;
  final Value<String?> didRight;
  final Value<String?> didWrong;
  final Value<String?> plan;
  final Value<int?> mood;
  final Value<String> checklist;
  final Value<String> images;
  final Value<DateTime> updatedAt;
  const DailyReviewsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.marketNote = const Value.absent(),
    this.didRight = const Value.absent(),
    this.didWrong = const Value.absent(),
    this.plan = const Value.absent(),
    this.mood = const Value.absent(),
    this.checklist = const Value.absent(),
    this.images = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DailyReviewsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    this.marketNote = const Value.absent(),
    this.didRight = const Value.absent(),
    this.didWrong = const Value.absent(),
    this.plan = const Value.absent(),
    this.mood = const Value.absent(),
    this.checklist = const Value.absent(),
    this.images = const Value.absent(),
    required DateTime updatedAt,
  })  : date = Value(date),
        updatedAt = Value(updatedAt);
  static Insertable<DailyReview> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? marketNote,
    Expression<String>? didRight,
    Expression<String>? didWrong,
    Expression<String>? plan,
    Expression<int>? mood,
    Expression<String>? checklist,
    Expression<String>? images,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (marketNote != null) 'market_note': marketNote,
      if (didRight != null) 'did_right': didRight,
      if (didWrong != null) 'did_wrong': didWrong,
      if (plan != null) 'plan': plan,
      if (mood != null) 'mood': mood,
      if (checklist != null) 'checklist': checklist,
      if (images != null) 'images': images,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DailyReviewsCompanion copyWith(
      {Value<int>? id,
      Value<String>? date,
      Value<String?>? marketNote,
      Value<String?>? didRight,
      Value<String?>? didWrong,
      Value<String?>? plan,
      Value<int?>? mood,
      Value<String>? checklist,
      Value<String>? images,
      Value<DateTime>? updatedAt}) {
    return DailyReviewsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      marketNote: marketNote ?? this.marketNote,
      didRight: didRight ?? this.didRight,
      didWrong: didWrong ?? this.didWrong,
      plan: plan ?? this.plan,
      mood: mood ?? this.mood,
      checklist: checklist ?? this.checklist,
      images: images ?? this.images,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (marketNote.present) {
      map['market_note'] = Variable<String>(marketNote.value);
    }
    if (didRight.present) {
      map['did_right'] = Variable<String>(didRight.value);
    }
    if (didWrong.present) {
      map['did_wrong'] = Variable<String>(didWrong.value);
    }
    if (plan.present) {
      map['plan'] = Variable<String>(plan.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (checklist.present) {
      map['checklist'] = Variable<String>(checklist.value);
    }
    if (images.present) {
      map['images'] = Variable<String>(images.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyReviewsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('marketNote: $marketNote, ')
          ..write('didRight: $didRight, ')
          ..write('didWrong: $didWrong, ')
          ..write('plan: $plan, ')
          ..write('mood: $mood, ')
          ..write('checklist: $checklist, ')
          ..write('images: $images, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PriceEntriesTable extends PriceEntries
    with TableInfo<$PriceEntriesTable, PriceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _instrumentIdMeta =
      const VerificationMeta('instrumentId');
  @override
  late final GeneratedColumn<int> instrumentId = GeneratedColumn<int>(
      'instrument_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES instruments (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 10, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, instrumentId, date, price];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price_entries';
  @override
  VerificationContext validateIntegrity(Insertable<PriceEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('instrument_id')) {
      context.handle(
          _instrumentIdMeta,
          instrumentId.isAcceptableOrUnknown(
              data['instrument_id']!, _instrumentIdMeta));
    } else if (isInserting) {
      context.missing(_instrumentIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {instrumentId, date},
      ];
  @override
  PriceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      instrumentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}instrument_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
    );
  }

  @override
  $PriceEntriesTable createAlias(String alias) {
    return $PriceEntriesTable(attachedDatabase, alias);
  }
}

class PriceEntry extends DataClass implements Insertable<PriceEntry> {
  final int id;
  final int instrumentId;

  /// yyyy-MM-dd
  final String date;
  final double price;
  const PriceEntry(
      {required this.id,
      required this.instrumentId,
      required this.date,
      required this.price});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['instrument_id'] = Variable<int>(instrumentId);
    map['date'] = Variable<String>(date);
    map['price'] = Variable<double>(price);
    return map;
  }

  PriceEntriesCompanion toCompanion(bool nullToAbsent) {
    return PriceEntriesCompanion(
      id: Value(id),
      instrumentId: Value(instrumentId),
      date: Value(date),
      price: Value(price),
    );
  }

  factory PriceEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceEntry(
      id: serializer.fromJson<int>(json['id']),
      instrumentId: serializer.fromJson<int>(json['instrumentId']),
      date: serializer.fromJson<String>(json['date']),
      price: serializer.fromJson<double>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'instrumentId': serializer.toJson<int>(instrumentId),
      'date': serializer.toJson<String>(date),
      'price': serializer.toJson<double>(price),
    };
  }

  PriceEntry copyWith(
          {int? id, int? instrumentId, String? date, double? price}) =>
      PriceEntry(
        id: id ?? this.id,
        instrumentId: instrumentId ?? this.instrumentId,
        date: date ?? this.date,
        price: price ?? this.price,
      );
  PriceEntry copyWithCompanion(PriceEntriesCompanion data) {
    return PriceEntry(
      id: data.id.present ? data.id.value : this.id,
      instrumentId: data.instrumentId.present
          ? data.instrumentId.value
          : this.instrumentId,
      date: data.date.present ? data.date.value : this.date,
      price: data.price.present ? data.price.value : this.price,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PriceEntry(')
          ..write('id: $id, ')
          ..write('instrumentId: $instrumentId, ')
          ..write('date: $date, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, instrumentId, date, price);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriceEntry &&
          other.id == this.id &&
          other.instrumentId == this.instrumentId &&
          other.date == this.date &&
          other.price == this.price);
}

class PriceEntriesCompanion extends UpdateCompanion<PriceEntry> {
  final Value<int> id;
  final Value<int> instrumentId;
  final Value<String> date;
  final Value<double> price;
  const PriceEntriesCompanion({
    this.id = const Value.absent(),
    this.instrumentId = const Value.absent(),
    this.date = const Value.absent(),
    this.price = const Value.absent(),
  });
  PriceEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int instrumentId,
    required String date,
    required double price,
  })  : instrumentId = Value(instrumentId),
        date = Value(date),
        price = Value(price);
  static Insertable<PriceEntry> custom({
    Expression<int>? id,
    Expression<int>? instrumentId,
    Expression<String>? date,
    Expression<double>? price,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (instrumentId != null) 'instrument_id': instrumentId,
      if (date != null) 'date': date,
      if (price != null) 'price': price,
    });
  }

  PriceEntriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? instrumentId,
      Value<String>? date,
      Value<double>? price}) {
    return PriceEntriesCompanion(
      id: id ?? this.id,
      instrumentId: instrumentId ?? this.instrumentId,
      date: date ?? this.date,
      price: price ?? this.price,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (instrumentId.present) {
      map['instrument_id'] = Variable<int>(instrumentId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriceEntriesCompanion(')
          ..write('id: $id, ')
          ..write('instrumentId: $instrumentId, ')
          ..write('date: $date, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }
}

class $DailySnapshotsTable extends DailySnapshots
    with TableInfo<$DailySnapshotsTable, DailySnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailySnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 10, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _principalMeta =
      const VerificationMeta('principal');
  @override
  late final GeneratedColumn<double> principal = GeneratedColumn<double>(
      'principal', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _marketValueMeta =
      const VerificationMeta('marketValue');
  @override
  late final GeneratedColumn<double> marketValue = GeneratedColumn<double>(
      'market_value', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _cashMeta = const VerificationMeta('cash');
  @override
  late final GeneratedColumn<double> cash = GeneratedColumn<double>(
      'cash', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _realizedPnlCumMeta =
      const VerificationMeta('realizedPnlCum');
  @override
  late final GeneratedColumn<double> realizedPnlCum = GeneratedColumn<double>(
      'realized_pnl_cum', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, principal, marketValue, cash, realizedPnlCum, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_snapshots';
  @override
  VerificationContext validateIntegrity(Insertable<DailySnapshot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('principal')) {
      context.handle(_principalMeta,
          principal.isAcceptableOrUnknown(data['principal']!, _principalMeta));
    }
    if (data.containsKey('market_value')) {
      context.handle(
          _marketValueMeta,
          marketValue.isAcceptableOrUnknown(
              data['market_value']!, _marketValueMeta));
    }
    if (data.containsKey('cash')) {
      context.handle(
          _cashMeta, cash.isAcceptableOrUnknown(data['cash']!, _cashMeta));
    }
    if (data.containsKey('realized_pnl_cum')) {
      context.handle(
          _realizedPnlCumMeta,
          realizedPnlCum.isAcceptableOrUnknown(
              data['realized_pnl_cum']!, _realizedPnlCumMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {date},
      ];
  @override
  DailySnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailySnapshot(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      principal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}principal']),
      marketValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}market_value'])!,
      cash: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cash']),
      realizedPnlCum: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}realized_pnl_cum'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DailySnapshotsTable createAlias(String alias) {
    return $DailySnapshotsTable(attachedDatabase, alias);
  }
}

class DailySnapshot extends DataClass implements Insertable<DailySnapshot> {
  final int id;
  final String date;

  /// 期初本金（允许后补，用于真实收益率）
  final double? principal;
  final double marketValue;
  final double? cash;
  final double realizedPnlCum;
  final DateTime createdAt;
  const DailySnapshot(
      {required this.id,
      required this.date,
      this.principal,
      required this.marketValue,
      this.cash,
      required this.realizedPnlCum,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || principal != null) {
      map['principal'] = Variable<double>(principal);
    }
    map['market_value'] = Variable<double>(marketValue);
    if (!nullToAbsent || cash != null) {
      map['cash'] = Variable<double>(cash);
    }
    map['realized_pnl_cum'] = Variable<double>(realizedPnlCum);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DailySnapshotsCompanion toCompanion(bool nullToAbsent) {
    return DailySnapshotsCompanion(
      id: Value(id),
      date: Value(date),
      principal: principal == null && nullToAbsent
          ? const Value.absent()
          : Value(principal),
      marketValue: Value(marketValue),
      cash: cash == null && nullToAbsent ? const Value.absent() : Value(cash),
      realizedPnlCum: Value(realizedPnlCum),
      createdAt: Value(createdAt),
    );
  }

  factory DailySnapshot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailySnapshot(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      principal: serializer.fromJson<double?>(json['principal']),
      marketValue: serializer.fromJson<double>(json['marketValue']),
      cash: serializer.fromJson<double?>(json['cash']),
      realizedPnlCum: serializer.fromJson<double>(json['realizedPnlCum']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'principal': serializer.toJson<double?>(principal),
      'marketValue': serializer.toJson<double>(marketValue),
      'cash': serializer.toJson<double?>(cash),
      'realizedPnlCum': serializer.toJson<double>(realizedPnlCum),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DailySnapshot copyWith(
          {int? id,
          String? date,
          Value<double?> principal = const Value.absent(),
          double? marketValue,
          Value<double?> cash = const Value.absent(),
          double? realizedPnlCum,
          DateTime? createdAt}) =>
      DailySnapshot(
        id: id ?? this.id,
        date: date ?? this.date,
        principal: principal.present ? principal.value : this.principal,
        marketValue: marketValue ?? this.marketValue,
        cash: cash.present ? cash.value : this.cash,
        realizedPnlCum: realizedPnlCum ?? this.realizedPnlCum,
        createdAt: createdAt ?? this.createdAt,
      );
  DailySnapshot copyWithCompanion(DailySnapshotsCompanion data) {
    return DailySnapshot(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      principal: data.principal.present ? data.principal.value : this.principal,
      marketValue:
          data.marketValue.present ? data.marketValue.value : this.marketValue,
      cash: data.cash.present ? data.cash.value : this.cash,
      realizedPnlCum: data.realizedPnlCum.present
          ? data.realizedPnlCum.value
          : this.realizedPnlCum,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailySnapshot(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('principal: $principal, ')
          ..write('marketValue: $marketValue, ')
          ..write('cash: $cash, ')
          ..write('realizedPnlCum: $realizedPnlCum, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, date, principal, marketValue, cash, realizedPnlCum, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailySnapshot &&
          other.id == this.id &&
          other.date == this.date &&
          other.principal == this.principal &&
          other.marketValue == this.marketValue &&
          other.cash == this.cash &&
          other.realizedPnlCum == this.realizedPnlCum &&
          other.createdAt == this.createdAt);
}

class DailySnapshotsCompanion extends UpdateCompanion<DailySnapshot> {
  final Value<int> id;
  final Value<String> date;
  final Value<double?> principal;
  final Value<double> marketValue;
  final Value<double?> cash;
  final Value<double> realizedPnlCum;
  final Value<DateTime> createdAt;
  const DailySnapshotsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.principal = const Value.absent(),
    this.marketValue = const Value.absent(),
    this.cash = const Value.absent(),
    this.realizedPnlCum = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DailySnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    this.principal = const Value.absent(),
    this.marketValue = const Value.absent(),
    this.cash = const Value.absent(),
    this.realizedPnlCum = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : date = Value(date);
  static Insertable<DailySnapshot> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<double>? principal,
    Expression<double>? marketValue,
    Expression<double>? cash,
    Expression<double>? realizedPnlCum,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (principal != null) 'principal': principal,
      if (marketValue != null) 'market_value': marketValue,
      if (cash != null) 'cash': cash,
      if (realizedPnlCum != null) 'realized_pnl_cum': realizedPnlCum,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DailySnapshotsCompanion copyWith(
      {Value<int>? id,
      Value<String>? date,
      Value<double?>? principal,
      Value<double>? marketValue,
      Value<double?>? cash,
      Value<double>? realizedPnlCum,
      Value<DateTime>? createdAt}) {
    return DailySnapshotsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      principal: principal ?? this.principal,
      marketValue: marketValue ?? this.marketValue,
      cash: cash ?? this.cash,
      realizedPnlCum: realizedPnlCum ?? this.realizedPnlCum,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (principal.present) {
      map['principal'] = Variable<double>(principal.value);
    }
    if (marketValue.present) {
      map['market_value'] = Variable<double>(marketValue.value);
    }
    if (cash.present) {
      map['cash'] = Variable<double>(cash.value);
    }
    if (realizedPnlCum.present) {
      map['realized_pnl_cum'] = Variable<double>(realizedPnlCum.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailySnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('principal: $principal, ')
          ..write('marketValue: $marketValue, ')
          ..write('cash: $cash, ')
          ..write('realizedPnlCum: $realizedPnlCum, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 16),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('STRATEGY'));
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xFF3B82F6));
  @override
  List<GeneratedColumn> get $columns => [id, name, type, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(Insertable<Tag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {name, type},
      ];
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String name;

  /// STRATEGY / SECTOR / EMOTION
  final String type;

  /// 0xAARRGGBB
  final int color;
  const Tag(
      {required this.id,
      required this.name,
      required this.type,
      required this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['color'] = Variable<int>(color);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      color: Value(color),
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      color: serializer.fromJson<int>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'color': serializer.toJson<int>(color),
    };
  }

  Tag copyWith({int? id, String? name, String? type, int? color}) => Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        color: color ?? this.color,
      );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.color == this.color);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<int> color;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.color = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.type = const Value.absent(),
    this.color = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (color != null) 'color': color,
    });
  }

  TagsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? type,
      Value<int>? color}) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<AppSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value']),
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String? value;
  const AppSetting({required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
    );
  }

  factory AppSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  AppSetting copyWith(
          {String? key, Value<String?> value = const Value.absent()}) =>
      AppSetting(
        key: key ?? this.key,
        value: value.present ? value.value : this.value,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String?> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith(
      {Value<String>? key, Value<String?>? value, Value<int>? rowid}) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $InstrumentsTable instruments = $InstrumentsTable(this);
  late final $TradesTable trades = $TradesTable(this);
  late final $DailyReviewsTable dailyReviews = $DailyReviewsTable(this);
  late final $PriceEntriesTable priceEntries = $PriceEntriesTable(this);
  late final $DailySnapshotsTable dailySnapshots = $DailySnapshotsTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        instruments,
        trades,
        dailyReviews,
        priceEntries,
        dailySnapshots,
        tags,
        appSettings
      ];
}

typedef $$InstrumentsTableCreateCompanionBuilder = InstrumentsCompanion
    Function({
  Value<int> id,
  required String code,
  required String name,
  required String market,
  Value<String> type,
  Value<bool> isFavorite,
  Value<DateTime> createdAt,
});
typedef $$InstrumentsTableUpdateCompanionBuilder = InstrumentsCompanion
    Function({
  Value<int> id,
  Value<String> code,
  Value<String> name,
  Value<String> market,
  Value<String> type,
  Value<bool> isFavorite,
  Value<DateTime> createdAt,
});

final class $$InstrumentsTableReferences
    extends BaseReferences<_$AppDatabase, $InstrumentsTable, Instrument> {
  $$InstrumentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TradesTable, List<Trade>> _tradesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.trades,
          aliasName:
              $_aliasNameGenerator(db.instruments.id, db.trades.instrumentId));

  $$TradesTableProcessedTableManager get tradesRefs {
    final manager = $$TradesTableTableManager($_db, $_db.trades)
        .filter((f) => f.instrumentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tradesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PriceEntriesTable, List<PriceEntry>>
      _priceEntriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.priceEntries,
              aliasName: $_aliasNameGenerator(
                  db.instruments.id, db.priceEntries.instrumentId));

  $$PriceEntriesTableProcessedTableManager get priceEntriesRefs {
    final manager = $$PriceEntriesTableTableManager($_db, $_db.priceEntries)
        .filter((f) => f.instrumentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_priceEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$InstrumentsTableFilterComposer
    extends Composer<_$AppDatabase, $InstrumentsTable> {
  $$InstrumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get market => $composableBuilder(
      column: $table.market, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> tradesRefs(
      Expression<bool> Function($$TradesTableFilterComposer f) f) {
    final $$TradesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trades,
        getReferencedColumn: (t) => t.instrumentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TradesTableFilterComposer(
              $db: $db,
              $table: $db.trades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> priceEntriesRefs(
      Expression<bool> Function($$PriceEntriesTableFilterComposer f) f) {
    final $$PriceEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.priceEntries,
        getReferencedColumn: (t) => t.instrumentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PriceEntriesTableFilterComposer(
              $db: $db,
              $table: $db.priceEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InstrumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $InstrumentsTable> {
  $$InstrumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get market => $composableBuilder(
      column: $table.market, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$InstrumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InstrumentsTable> {
  $$InstrumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get market =>
      $composableBuilder(column: $table.market, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> tradesRefs<T extends Object>(
      Expression<T> Function($$TradesTableAnnotationComposer a) f) {
    final $$TradesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trades,
        getReferencedColumn: (t) => t.instrumentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TradesTableAnnotationComposer(
              $db: $db,
              $table: $db.trades,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> priceEntriesRefs<T extends Object>(
      Expression<T> Function($$PriceEntriesTableAnnotationComposer a) f) {
    final $$PriceEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.priceEntries,
        getReferencedColumn: (t) => t.instrumentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PriceEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.priceEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$InstrumentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InstrumentsTable,
    Instrument,
    $$InstrumentsTableFilterComposer,
    $$InstrumentsTableOrderingComposer,
    $$InstrumentsTableAnnotationComposer,
    $$InstrumentsTableCreateCompanionBuilder,
    $$InstrumentsTableUpdateCompanionBuilder,
    (Instrument, $$InstrumentsTableReferences),
    Instrument,
    PrefetchHooks Function({bool tradesRefs, bool priceEntriesRefs})> {
  $$InstrumentsTableTableManager(_$AppDatabase db, $InstrumentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstrumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InstrumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InstrumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> market = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              InstrumentsCompanion(
            id: id,
            code: code,
            name: name,
            market: market,
            type: type,
            isFavorite: isFavorite,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            required String name,
            required String market,
            Value<String> type = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              InstrumentsCompanion.insert(
            id: id,
            code: code,
            name: name,
            market: market,
            type: type,
            isFavorite: isFavorite,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InstrumentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {tradesRefs = false, priceEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (tradesRefs) db.trades,
                if (priceEntriesRefs) db.priceEntries
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tradesRefs)
                    await $_getPrefetchedData<Instrument, $InstrumentsTable,
                            Trade>(
                        currentTable: table,
                        referencedTable:
                            $$InstrumentsTableReferences._tradesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InstrumentsTableReferences(db, table, p0)
                                .tradesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.instrumentId == item.id),
                        typedResults: items),
                  if (priceEntriesRefs)
                    await $_getPrefetchedData<Instrument, $InstrumentsTable,
                            PriceEntry>(
                        currentTable: table,
                        referencedTable: $$InstrumentsTableReferences
                            ._priceEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InstrumentsTableReferences(db, table, p0)
                                .priceEntriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.instrumentId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$InstrumentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InstrumentsTable,
    Instrument,
    $$InstrumentsTableFilterComposer,
    $$InstrumentsTableOrderingComposer,
    $$InstrumentsTableAnnotationComposer,
    $$InstrumentsTableCreateCompanionBuilder,
    $$InstrumentsTableUpdateCompanionBuilder,
    (Instrument, $$InstrumentsTableReferences),
    Instrument,
    PrefetchHooks Function({bool tradesRefs, bool priceEntriesRefs})>;
typedef $$TradesTableCreateCompanionBuilder = TradesCompanion Function({
  Value<int> id,
  required int instrumentId,
  required DateTime tradedAt,
  required String side,
  required double price,
  required double quantity,
  Value<double> fee,
  Value<String?> reason,
  Value<String?> emotion,
  Value<String> tagIds,
  Value<String> images,
  Value<DateTime> createdAt,
  required DateTime updatedAt,
});
typedef $$TradesTableUpdateCompanionBuilder = TradesCompanion Function({
  Value<int> id,
  Value<int> instrumentId,
  Value<DateTime> tradedAt,
  Value<String> side,
  Value<double> price,
  Value<double> quantity,
  Value<double> fee,
  Value<String?> reason,
  Value<String?> emotion,
  Value<String> tagIds,
  Value<String> images,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$TradesTableReferences
    extends BaseReferences<_$AppDatabase, $TradesTable, Trade> {
  $$TradesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InstrumentsTable _instrumentIdTable(_$AppDatabase db) =>
      db.instruments.createAlias(
          $_aliasNameGenerator(db.trades.instrumentId, db.instruments.id));

  $$InstrumentsTableProcessedTableManager get instrumentId {
    final $_column = $_itemColumn<int>('instrument_id')!;

    final manager = $$InstrumentsTableTableManager($_db, $_db.instruments)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_instrumentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TradesTableFilterComposer
    extends Composer<_$AppDatabase, $TradesTable> {
  $$TradesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get tradedAt => $composableBuilder(
      column: $table.tradedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get side => $composableBuilder(
      column: $table.side, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fee => $composableBuilder(
      column: $table.fee, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emotion => $composableBuilder(
      column: $table.emotion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagIds => $composableBuilder(
      column: $table.tagIds, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get images => $composableBuilder(
      column: $table.images, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$InstrumentsTableFilterComposer get instrumentId {
    final $$InstrumentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.instrumentId,
        referencedTable: $db.instruments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InstrumentsTableFilterComposer(
              $db: $db,
              $table: $db.instruments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TradesTableOrderingComposer
    extends Composer<_$AppDatabase, $TradesTable> {
  $$TradesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get tradedAt => $composableBuilder(
      column: $table.tradedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get side => $composableBuilder(
      column: $table.side, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fee => $composableBuilder(
      column: $table.fee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emotion => $composableBuilder(
      column: $table.emotion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagIds => $composableBuilder(
      column: $table.tagIds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get images => $composableBuilder(
      column: $table.images, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$InstrumentsTableOrderingComposer get instrumentId {
    final $$InstrumentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.instrumentId,
        referencedTable: $db.instruments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InstrumentsTableOrderingComposer(
              $db: $db,
              $table: $db.instruments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TradesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TradesTable> {
  $$TradesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get tradedAt =>
      $composableBuilder(column: $table.tradedAt, builder: (column) => column);

  GeneratedColumn<String> get side =>
      $composableBuilder(column: $table.side, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get fee =>
      $composableBuilder(column: $table.fee, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get emotion =>
      $composableBuilder(column: $table.emotion, builder: (column) => column);

  GeneratedColumn<String> get tagIds =>
      $composableBuilder(column: $table.tagIds, builder: (column) => column);

  GeneratedColumn<String> get images =>
      $composableBuilder(column: $table.images, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$InstrumentsTableAnnotationComposer get instrumentId {
    final $$InstrumentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.instrumentId,
        referencedTable: $db.instruments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InstrumentsTableAnnotationComposer(
              $db: $db,
              $table: $db.instruments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TradesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TradesTable,
    Trade,
    $$TradesTableFilterComposer,
    $$TradesTableOrderingComposer,
    $$TradesTableAnnotationComposer,
    $$TradesTableCreateCompanionBuilder,
    $$TradesTableUpdateCompanionBuilder,
    (Trade, $$TradesTableReferences),
    Trade,
    PrefetchHooks Function({bool instrumentId})> {
  $$TradesTableTableManager(_$AppDatabase db, $TradesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TradesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TradesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TradesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> instrumentId = const Value.absent(),
            Value<DateTime> tradedAt = const Value.absent(),
            Value<String> side = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> fee = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<String?> emotion = const Value.absent(),
            Value<String> tagIds = const Value.absent(),
            Value<String> images = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              TradesCompanion(
            id: id,
            instrumentId: instrumentId,
            tradedAt: tradedAt,
            side: side,
            price: price,
            quantity: quantity,
            fee: fee,
            reason: reason,
            emotion: emotion,
            tagIds: tagIds,
            images: images,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int instrumentId,
            required DateTime tradedAt,
            required String side,
            required double price,
            required double quantity,
            Value<double> fee = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<String?> emotion = const Value.absent(),
            Value<String> tagIds = const Value.absent(),
            Value<String> images = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            required DateTime updatedAt,
          }) =>
              TradesCompanion.insert(
            id: id,
            instrumentId: instrumentId,
            tradedAt: tradedAt,
            side: side,
            price: price,
            quantity: quantity,
            fee: fee,
            reason: reason,
            emotion: emotion,
            tagIds: tagIds,
            images: images,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TradesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({instrumentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (instrumentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.instrumentId,
                    referencedTable:
                        $$TradesTableReferences._instrumentIdTable(db),
                    referencedColumn:
                        $$TradesTableReferences._instrumentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TradesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TradesTable,
    Trade,
    $$TradesTableFilterComposer,
    $$TradesTableOrderingComposer,
    $$TradesTableAnnotationComposer,
    $$TradesTableCreateCompanionBuilder,
    $$TradesTableUpdateCompanionBuilder,
    (Trade, $$TradesTableReferences),
    Trade,
    PrefetchHooks Function({bool instrumentId})>;
typedef $$DailyReviewsTableCreateCompanionBuilder = DailyReviewsCompanion
    Function({
  Value<int> id,
  required String date,
  Value<String?> marketNote,
  Value<String?> didRight,
  Value<String?> didWrong,
  Value<String?> plan,
  Value<int?> mood,
  Value<String> checklist,
  Value<String> images,
  required DateTime updatedAt,
});
typedef $$DailyReviewsTableUpdateCompanionBuilder = DailyReviewsCompanion
    Function({
  Value<int> id,
  Value<String> date,
  Value<String?> marketNote,
  Value<String?> didRight,
  Value<String?> didWrong,
  Value<String?> plan,
  Value<int?> mood,
  Value<String> checklist,
  Value<String> images,
  Value<DateTime> updatedAt,
});

class $$DailyReviewsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyReviewsTable> {
  $$DailyReviewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get marketNote => $composableBuilder(
      column: $table.marketNote, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get didRight => $composableBuilder(
      column: $table.didRight, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get didWrong => $composableBuilder(
      column: $table.didWrong, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get plan => $composableBuilder(
      column: $table.plan, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get checklist => $composableBuilder(
      column: $table.checklist, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get images => $composableBuilder(
      column: $table.images, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DailyReviewsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyReviewsTable> {
  $$DailyReviewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get marketNote => $composableBuilder(
      column: $table.marketNote, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get didRight => $composableBuilder(
      column: $table.didRight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get didWrong => $composableBuilder(
      column: $table.didWrong, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get plan => $composableBuilder(
      column: $table.plan, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get checklist => $composableBuilder(
      column: $table.checklist, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get images => $composableBuilder(
      column: $table.images, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DailyReviewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyReviewsTable> {
  $$DailyReviewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get marketNote => $composableBuilder(
      column: $table.marketNote, builder: (column) => column);

  GeneratedColumn<String> get didRight =>
      $composableBuilder(column: $table.didRight, builder: (column) => column);

  GeneratedColumn<String> get didWrong =>
      $composableBuilder(column: $table.didWrong, builder: (column) => column);

  GeneratedColumn<String> get plan =>
      $composableBuilder(column: $table.plan, builder: (column) => column);

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get checklist =>
      $composableBuilder(column: $table.checklist, builder: (column) => column);

  GeneratedColumn<String> get images =>
      $composableBuilder(column: $table.images, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyReviewsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailyReviewsTable,
    DailyReview,
    $$DailyReviewsTableFilterComposer,
    $$DailyReviewsTableOrderingComposer,
    $$DailyReviewsTableAnnotationComposer,
    $$DailyReviewsTableCreateCompanionBuilder,
    $$DailyReviewsTableUpdateCompanionBuilder,
    (
      DailyReview,
      BaseReferences<_$AppDatabase, $DailyReviewsTable, DailyReview>
    ),
    DailyReview,
    PrefetchHooks Function()> {
  $$DailyReviewsTableTableManager(_$AppDatabase db, $DailyReviewsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyReviewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyReviewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyReviewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String?> marketNote = const Value.absent(),
            Value<String?> didRight = const Value.absent(),
            Value<String?> didWrong = const Value.absent(),
            Value<String?> plan = const Value.absent(),
            Value<int?> mood = const Value.absent(),
            Value<String> checklist = const Value.absent(),
            Value<String> images = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              DailyReviewsCompanion(
            id: id,
            date: date,
            marketNote: marketNote,
            didRight: didRight,
            didWrong: didWrong,
            plan: plan,
            mood: mood,
            checklist: checklist,
            images: images,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String date,
            Value<String?> marketNote = const Value.absent(),
            Value<String?> didRight = const Value.absent(),
            Value<String?> didWrong = const Value.absent(),
            Value<String?> plan = const Value.absent(),
            Value<int?> mood = const Value.absent(),
            Value<String> checklist = const Value.absent(),
            Value<String> images = const Value.absent(),
            required DateTime updatedAt,
          }) =>
              DailyReviewsCompanion.insert(
            id: id,
            date: date,
            marketNote: marketNote,
            didRight: didRight,
            didWrong: didWrong,
            plan: plan,
            mood: mood,
            checklist: checklist,
            images: images,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyReviewsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailyReviewsTable,
    DailyReview,
    $$DailyReviewsTableFilterComposer,
    $$DailyReviewsTableOrderingComposer,
    $$DailyReviewsTableAnnotationComposer,
    $$DailyReviewsTableCreateCompanionBuilder,
    $$DailyReviewsTableUpdateCompanionBuilder,
    (
      DailyReview,
      BaseReferences<_$AppDatabase, $DailyReviewsTable, DailyReview>
    ),
    DailyReview,
    PrefetchHooks Function()>;
typedef $$PriceEntriesTableCreateCompanionBuilder = PriceEntriesCompanion
    Function({
  Value<int> id,
  required int instrumentId,
  required String date,
  required double price,
});
typedef $$PriceEntriesTableUpdateCompanionBuilder = PriceEntriesCompanion
    Function({
  Value<int> id,
  Value<int> instrumentId,
  Value<String> date,
  Value<double> price,
});

final class $$PriceEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $PriceEntriesTable, PriceEntry> {
  $$PriceEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $InstrumentsTable _instrumentIdTable(_$AppDatabase db) =>
      db.instruments.createAlias($_aliasNameGenerator(
          db.priceEntries.instrumentId, db.instruments.id));

  $$InstrumentsTableProcessedTableManager get instrumentId {
    final $_column = $_itemColumn<int>('instrument_id')!;

    final manager = $$InstrumentsTableTableManager($_db, $_db.instruments)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_instrumentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PriceEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PriceEntriesTable> {
  $$PriceEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  $$InstrumentsTableFilterComposer get instrumentId {
    final $$InstrumentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.instrumentId,
        referencedTable: $db.instruments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InstrumentsTableFilterComposer(
              $db: $db,
              $table: $db.instruments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PriceEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PriceEntriesTable> {
  $$PriceEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  $$InstrumentsTableOrderingComposer get instrumentId {
    final $$InstrumentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.instrumentId,
        referencedTable: $db.instruments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InstrumentsTableOrderingComposer(
              $db: $db,
              $table: $db.instruments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PriceEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PriceEntriesTable> {
  $$PriceEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  $$InstrumentsTableAnnotationComposer get instrumentId {
    final $$InstrumentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.instrumentId,
        referencedTable: $db.instruments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InstrumentsTableAnnotationComposer(
              $db: $db,
              $table: $db.instruments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PriceEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PriceEntriesTable,
    PriceEntry,
    $$PriceEntriesTableFilterComposer,
    $$PriceEntriesTableOrderingComposer,
    $$PriceEntriesTableAnnotationComposer,
    $$PriceEntriesTableCreateCompanionBuilder,
    $$PriceEntriesTableUpdateCompanionBuilder,
    (PriceEntry, $$PriceEntriesTableReferences),
    PriceEntry,
    PrefetchHooks Function({bool instrumentId})> {
  $$PriceEntriesTableTableManager(_$AppDatabase db, $PriceEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PriceEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PriceEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PriceEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> instrumentId = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<double> price = const Value.absent(),
          }) =>
              PriceEntriesCompanion(
            id: id,
            instrumentId: instrumentId,
            date: date,
            price: price,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int instrumentId,
            required String date,
            required double price,
          }) =>
              PriceEntriesCompanion.insert(
            id: id,
            instrumentId: instrumentId,
            date: date,
            price: price,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PriceEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({instrumentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (instrumentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.instrumentId,
                    referencedTable:
                        $$PriceEntriesTableReferences._instrumentIdTable(db),
                    referencedColumn:
                        $$PriceEntriesTableReferences._instrumentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PriceEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PriceEntriesTable,
    PriceEntry,
    $$PriceEntriesTableFilterComposer,
    $$PriceEntriesTableOrderingComposer,
    $$PriceEntriesTableAnnotationComposer,
    $$PriceEntriesTableCreateCompanionBuilder,
    $$PriceEntriesTableUpdateCompanionBuilder,
    (PriceEntry, $$PriceEntriesTableReferences),
    PriceEntry,
    PrefetchHooks Function({bool instrumentId})>;
typedef $$DailySnapshotsTableCreateCompanionBuilder = DailySnapshotsCompanion
    Function({
  Value<int> id,
  required String date,
  Value<double?> principal,
  Value<double> marketValue,
  Value<double?> cash,
  Value<double> realizedPnlCum,
  Value<DateTime> createdAt,
});
typedef $$DailySnapshotsTableUpdateCompanionBuilder = DailySnapshotsCompanion
    Function({
  Value<int> id,
  Value<String> date,
  Value<double?> principal,
  Value<double> marketValue,
  Value<double?> cash,
  Value<double> realizedPnlCum,
  Value<DateTime> createdAt,
});

class $$DailySnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $DailySnapshotsTable> {
  $$DailySnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get principal => $composableBuilder(
      column: $table.principal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get marketValue => $composableBuilder(
      column: $table.marketValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cash => $composableBuilder(
      column: $table.cash, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get realizedPnlCum => $composableBuilder(
      column: $table.realizedPnlCum,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DailySnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailySnapshotsTable> {
  $$DailySnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get principal => $composableBuilder(
      column: $table.principal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get marketValue => $composableBuilder(
      column: $table.marketValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cash => $composableBuilder(
      column: $table.cash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get realizedPnlCum => $composableBuilder(
      column: $table.realizedPnlCum,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DailySnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailySnapshotsTable> {
  $$DailySnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get principal =>
      $composableBuilder(column: $table.principal, builder: (column) => column);

  GeneratedColumn<double> get marketValue => $composableBuilder(
      column: $table.marketValue, builder: (column) => column);

  GeneratedColumn<double> get cash =>
      $composableBuilder(column: $table.cash, builder: (column) => column);

  GeneratedColumn<double> get realizedPnlCum => $composableBuilder(
      column: $table.realizedPnlCum, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DailySnapshotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailySnapshotsTable,
    DailySnapshot,
    $$DailySnapshotsTableFilterComposer,
    $$DailySnapshotsTableOrderingComposer,
    $$DailySnapshotsTableAnnotationComposer,
    $$DailySnapshotsTableCreateCompanionBuilder,
    $$DailySnapshotsTableUpdateCompanionBuilder,
    (
      DailySnapshot,
      BaseReferences<_$AppDatabase, $DailySnapshotsTable, DailySnapshot>
    ),
    DailySnapshot,
    PrefetchHooks Function()> {
  $$DailySnapshotsTableTableManager(
      _$AppDatabase db, $DailySnapshotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailySnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailySnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailySnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<double?> principal = const Value.absent(),
            Value<double> marketValue = const Value.absent(),
            Value<double?> cash = const Value.absent(),
            Value<double> realizedPnlCum = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DailySnapshotsCompanion(
            id: id,
            date: date,
            principal: principal,
            marketValue: marketValue,
            cash: cash,
            realizedPnlCum: realizedPnlCum,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String date,
            Value<double?> principal = const Value.absent(),
            Value<double> marketValue = const Value.absent(),
            Value<double?> cash = const Value.absent(),
            Value<double> realizedPnlCum = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DailySnapshotsCompanion.insert(
            id: id,
            date: date,
            principal: principal,
            marketValue: marketValue,
            cash: cash,
            realizedPnlCum: realizedPnlCum,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailySnapshotsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailySnapshotsTable,
    DailySnapshot,
    $$DailySnapshotsTableFilterComposer,
    $$DailySnapshotsTableOrderingComposer,
    $$DailySnapshotsTableAnnotationComposer,
    $$DailySnapshotsTableCreateCompanionBuilder,
    $$DailySnapshotsTableUpdateCompanionBuilder,
    (
      DailySnapshot,
      BaseReferences<_$AppDatabase, $DailySnapshotsTable, DailySnapshot>
    ),
    DailySnapshot,
    PrefetchHooks Function()>;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  required String name,
  Value<String> type,
  Value<int> color,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> type,
  Value<int> color,
});

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);
}

class $$TagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
    Tag,
    PrefetchHooks Function()> {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> color = const Value.absent(),
          }) =>
              TagsCompanion(
            id: id,
            name: name,
            type: type,
            color: color,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> type = const Value.absent(),
            Value<int> color = const Value.absent(),
          }) =>
              TagsCompanion.insert(
            id: id,
            name: name,
            type: type,
            color: color,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
    Tag,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableCreateCompanionBuilder = AppSettingsCompanion
    Function({
  required String key,
  Value<String?> value,
  Value<int> rowid,
});
typedef $$AppSettingsTableUpdateCompanionBuilder = AppSettingsCompanion
    Function({
  Value<String> key,
  Value<String?> value,
  Value<int> rowid,
});

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String?> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            Value<String?> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTable,
    AppSetting,
    $$AppSettingsTableFilterComposer,
    $$AppSettingsTableOrderingComposer,
    $$AppSettingsTableAnnotationComposer,
    $$AppSettingsTableCreateCompanionBuilder,
    $$AppSettingsTableUpdateCompanionBuilder,
    (AppSetting, BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>),
    AppSetting,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$InstrumentsTableTableManager get instruments =>
      $$InstrumentsTableTableManager(_db, _db.instruments);
  $$TradesTableTableManager get trades =>
      $$TradesTableTableManager(_db, _db.trades);
  $$DailyReviewsTableTableManager get dailyReviews =>
      $$DailyReviewsTableTableManager(_db, _db.dailyReviews);
  $$PriceEntriesTableTableManager get priceEntries =>
      $$PriceEntriesTableTableManager(_db, _db.priceEntries);
  $$DailySnapshotsTableTableManager get dailySnapshots =>
      $$DailySnapshotsTableTableManager(_db, _db.dailySnapshots);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
