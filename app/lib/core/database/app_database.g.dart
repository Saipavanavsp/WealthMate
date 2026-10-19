// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TransactionsTable extends Transactions with TableInfo<$TransactionsTable, TransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta('amountMinor');
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _merchantMeta = const VerificationMeta('merchant');
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<int> occurredAt = GeneratedColumn<int>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recurrenceMeta = const VerificationMeta('recurrence');
  @override
  late final GeneratedColumn<String> recurrence = GeneratedColumn<String>(
    'recurrence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    type,
    amountMinor,
    currency,
    category,
    merchant,
    note,
    occurredAt,
    recurrence,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<TransactionRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta, deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('type')) {
      context.handle(_typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(_amountMinorMeta, amountMinor.isAcceptableOrUnknown(data['amount_minor']!, _amountMinorMeta));
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta, currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta, category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('merchant')) {
      context.handle(_merchantMeta, merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta));
    }
    if (data.containsKey('note')) {
      context.handle(_noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('occurred_at')) {
      context.handle(_occurredAtMeta, occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta));
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('recurrence')) {
      context.handle(_recurrenceMeta, recurrence.isAcceptableOrUnknown(data['recurrence']!, _recurrenceMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      type: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      amountMinor: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}amount_minor'])!,
      currency: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      category: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      merchant: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}merchant']),
      note: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}note']),
      occurredAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}occurred_at'])!,
      recurrence: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}recurrence'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class TransactionRow extends DataClass implements Insertable<TransactionRow> {
  final String id;
  final int updatedAt;
  final bool deleted;
  final String type;
  final int amountMinor;
  final String currency;
  final String category;
  final String? merchant;
  final String? note;
  final int occurredAt;
  final String recurrence;
  const TransactionRow({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.type,
    required this.amountMinor,
    required this.currency,
    required this.category,
    this.merchant,
    this.note,
    required this.occurredAt,
    required this.recurrence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['type'] = Variable<String>(type);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || merchant != null) {
      map['merchant'] = Variable<String>(merchant);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['occurred_at'] = Variable<int>(occurredAt);
    map['recurrence'] = Variable<String>(recurrence);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      type: Value(type),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      category: Value(category),
      merchant: merchant == null && nullToAbsent ? const Value.absent() : Value(merchant),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      occurredAt: Value(occurredAt),
      recurrence: Value(recurrence),
    );
  }

  factory TransactionRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionRow(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      type: serializer.fromJson<String>(json['type']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      category: serializer.fromJson<String>(json['category']),
      merchant: serializer.fromJson<String?>(json['merchant']),
      note: serializer.fromJson<String?>(json['note']),
      occurredAt: serializer.fromJson<int>(json['occurredAt']),
      recurrence: serializer.fromJson<String>(json['recurrence']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'type': serializer.toJson<String>(type),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'category': serializer.toJson<String>(category),
      'merchant': serializer.toJson<String?>(merchant),
      'note': serializer.toJson<String?>(note),
      'occurredAt': serializer.toJson<int>(occurredAt),
      'recurrence': serializer.toJson<String>(recurrence),
    };
  }

  TransactionRow copyWith({
    String? id,
    int? updatedAt,
    bool? deleted,
    String? type,
    int? amountMinor,
    String? currency,
    String? category,
    Value<String?> merchant = const Value.absent(),
    Value<String?> note = const Value.absent(),
    int? occurredAt,
    String? recurrence,
  }) => TransactionRow(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    type: type ?? this.type,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    category: category ?? this.category,
    merchant: merchant.present ? merchant.value : this.merchant,
    note: note.present ? note.value : this.note,
    occurredAt: occurredAt ?? this.occurredAt,
    recurrence: recurrence ?? this.recurrence,
  );
  TransactionRow copyWithCompanion(TransactionsCompanion data) {
    return TransactionRow(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      type: data.type.present ? data.type.value : this.type,
      amountMinor: data.amountMinor.present ? data.amountMinor.value : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      category: data.category.present ? data.category.value : this.category,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      note: data.note.present ? data.note.value : this.note,
      occurredAt: data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
      recurrence: data.recurrence.present ? data.recurrence.value : this.recurrence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRow(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('type: $type, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('category: $category, ')
          ..write('merchant: $merchant, ')
          ..write('note: $note, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('recurrence: $recurrence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    deleted,
    type,
    amountMinor,
    currency,
    category,
    merchant,
    note,
    occurredAt,
    recurrence,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionRow &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.type == this.type &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.category == this.category &&
          other.merchant == this.merchant &&
          other.note == this.note &&
          other.occurredAt == this.occurredAt &&
          other.recurrence == this.recurrence);
}

class TransactionsCompanion extends UpdateCompanion<TransactionRow> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<String> type;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<String> category;
  final Value<String?> merchant;
  final Value<String?> note;
  final Value<int> occurredAt;
  final Value<String> recurrence;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.type = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.category = const Value.absent(),
    this.merchant = const Value.absent(),
    this.note = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required int updatedAt,
    this.deleted = const Value.absent(),
    required String type,
    required int amountMinor,
    this.currency = const Value.absent(),
    required String category,
    this.merchant = const Value.absent(),
    this.note = const Value.absent(),
    required int occurredAt,
    this.recurrence = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       type = Value(type),
       amountMinor = Value(amountMinor),
       category = Value(category),
       occurredAt = Value(occurredAt);
  static Insertable<TransactionRow> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<String>? type,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<String>? category,
    Expression<String>? merchant,
    Expression<String>? note,
    Expression<int>? occurredAt,
    Expression<String>? recurrence,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (type != null) 'type': type,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (category != null) 'category': category,
      if (merchant != null) 'merchant': merchant,
      if (note != null) 'note': note,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (recurrence != null) 'recurrence': recurrence,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<String>? type,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<String>? category,
    Value<String?>? merchant,
    Value<String?>? note,
    Value<int>? occurredAt,
    Value<String>? recurrence,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      type: type ?? this.type,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      merchant: merchant ?? this.merchant,
      note: note ?? this.note,
      occurredAt: occurredAt ?? this.occurredAt,
      recurrence: recurrence ?? this.recurrence,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<int>(occurredAt.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(recurrence.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('type: $type, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('category: $category, ')
          ..write('merchant: $merchant, ')
          ..write('note: $note, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('recurrence: $recurrence, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, GoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMinorMeta = const VerificationMeta('targetMinor');
  @override
  late final GeneratedColumn<int> targetMinor = GeneratedColumn<int>(
    'target_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedMinorMeta = const VerificationMeta('savedMinor');
  @override
  late final GeneratedColumn<int> savedMinor = GeneratedColumn<int>(
    'saved_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta('deadline');
  @override
  late final GeneratedColumn<int> deadline = GeneratedColumn<int>(
    'deadline',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, updatedAt, deleted, name, targetMinor, savedMinor, currency, deadline];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(Insertable<GoalRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta, deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_minor')) {
      context.handle(_targetMinorMeta, targetMinor.isAcceptableOrUnknown(data['target_minor']!, _targetMinorMeta));
    } else if (isInserting) {
      context.missing(_targetMinorMeta);
    }
    if (data.containsKey('saved_minor')) {
      context.handle(_savedMinorMeta, savedMinor.isAcceptableOrUnknown(data['saved_minor']!, _savedMinorMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta, currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('deadline')) {
      context.handle(_deadlineMeta, deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta));
    } else if (isInserting) {
      context.missing(_deadlineMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      targetMinor: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}target_minor'])!,
      savedMinor: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}saved_minor'])!,
      currency: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      deadline: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}deadline'])!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class GoalRow extends DataClass implements Insertable<GoalRow> {
  final String id;
  final int updatedAt;
  final bool deleted;
  final String name;
  final int targetMinor;
  final int savedMinor;
  final String currency;
  final int deadline;
  const GoalRow({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.name,
    required this.targetMinor,
    required this.savedMinor,
    required this.currency,
    required this.deadline,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['name'] = Variable<String>(name);
    map['target_minor'] = Variable<int>(targetMinor);
    map['saved_minor'] = Variable<int>(savedMinor);
    map['currency'] = Variable<String>(currency);
    map['deadline'] = Variable<int>(deadline);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      name: Value(name),
      targetMinor: Value(targetMinor),
      savedMinor: Value(savedMinor),
      currency: Value(currency),
      deadline: Value(deadline),
    );
  }

  factory GoalRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalRow(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      name: serializer.fromJson<String>(json['name']),
      targetMinor: serializer.fromJson<int>(json['targetMinor']),
      savedMinor: serializer.fromJson<int>(json['savedMinor']),
      currency: serializer.fromJson<String>(json['currency']),
      deadline: serializer.fromJson<int>(json['deadline']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'name': serializer.toJson<String>(name),
      'targetMinor': serializer.toJson<int>(targetMinor),
      'savedMinor': serializer.toJson<int>(savedMinor),
      'currency': serializer.toJson<String>(currency),
      'deadline': serializer.toJson<int>(deadline),
    };
  }

  GoalRow copyWith({
    String? id,
    int? updatedAt,
    bool? deleted,
    String? name,
    int? targetMinor,
    int? savedMinor,
    String? currency,
    int? deadline,
  }) => GoalRow(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    name: name ?? this.name,
    targetMinor: targetMinor ?? this.targetMinor,
    savedMinor: savedMinor ?? this.savedMinor,
    currency: currency ?? this.currency,
    deadline: deadline ?? this.deadline,
  );
  GoalRow copyWithCompanion(GoalsCompanion data) {
    return GoalRow(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      name: data.name.present ? data.name.value : this.name,
      targetMinor: data.targetMinor.present ? data.targetMinor.value : this.targetMinor,
      savedMinor: data.savedMinor.present ? data.savedMinor.value : this.savedMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalRow(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('targetMinor: $targetMinor, ')
          ..write('savedMinor: $savedMinor, ')
          ..write('currency: $currency, ')
          ..write('deadline: $deadline')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, updatedAt, deleted, name, targetMinor, savedMinor, currency, deadline);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalRow &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.name == this.name &&
          other.targetMinor == this.targetMinor &&
          other.savedMinor == this.savedMinor &&
          other.currency == this.currency &&
          other.deadline == this.deadline);
}

class GoalsCompanion extends UpdateCompanion<GoalRow> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<String> name;
  final Value<int> targetMinor;
  final Value<int> savedMinor;
  final Value<String> currency;
  final Value<int> deadline;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.name = const Value.absent(),
    this.targetMinor = const Value.absent(),
    this.savedMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.deadline = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required int updatedAt,
    this.deleted = const Value.absent(),
    required String name,
    required int targetMinor,
    this.savedMinor = const Value.absent(),
    this.currency = const Value.absent(),
    required int deadline,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       name = Value(name),
       targetMinor = Value(targetMinor),
       deadline = Value(deadline);
  static Insertable<GoalRow> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<String>? name,
    Expression<int>? targetMinor,
    Expression<int>? savedMinor,
    Expression<String>? currency,
    Expression<int>? deadline,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (name != null) 'name': name,
      if (targetMinor != null) 'target_minor': targetMinor,
      if (savedMinor != null) 'saved_minor': savedMinor,
      if (currency != null) 'currency': currency,
      if (deadline != null) 'deadline': deadline,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<String>? name,
    Value<int>? targetMinor,
    Value<int>? savedMinor,
    Value<String>? currency,
    Value<int>? deadline,
    Value<int>? rowid,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      name: name ?? this.name,
      targetMinor: targetMinor ?? this.targetMinor,
      savedMinor: savedMinor ?? this.savedMinor,
      currency: currency ?? this.currency,
      deadline: deadline ?? this.deadline,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetMinor.present) {
      map['target_minor'] = Variable<int>(targetMinor.value);
    }
    if (savedMinor.present) {
      map['saved_minor'] = Variable<int>(savedMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<int>(deadline.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('targetMinor: $targetMinor, ')
          ..write('savedMinor: $savedMinor, ')
          ..write('currency: $currency, ')
          ..write('deadline: $deadline, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupsTable extends Groups with TableInfo<$GroupsTable, GroupRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, updatedAt, deleted, name, currency];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(Insertable<GroupRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta, deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta, currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      currency: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
    );
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }
}

class GroupRow extends DataClass implements Insertable<GroupRow> {
  final String id;
  final int updatedAt;
  final bool deleted;
  final String name;
  final String currency;
  const GroupRow({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.name,
    required this.currency,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['name'] = Variable<String>(name);
    map['currency'] = Variable<String>(currency);
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      name: Value(name),
      currency: Value(currency),
    );
  }

  factory GroupRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupRow(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      name: serializer.fromJson<String>(json['name']),
      currency: serializer.fromJson<String>(json['currency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'name': serializer.toJson<String>(name),
      'currency': serializer.toJson<String>(currency),
    };
  }

  GroupRow copyWith({String? id, int? updatedAt, bool? deleted, String? name, String? currency}) => GroupRow(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    name: name ?? this.name,
    currency: currency ?? this.currency,
  );
  GroupRow copyWithCompanion(GroupsCompanion data) {
    return GroupRow(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      name: data.name.present ? data.name.value : this.name,
      currency: data.currency.present ? data.currency.value : this.currency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupRow(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, updatedAt, deleted, name, currency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupRow &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.name == this.name &&
          other.currency == this.currency);
}

class GroupsCompanion extends UpdateCompanion<GroupRow> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<String> name;
  final Value<String> currency;
  final Value<int> rowid;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.name = const Value.absent(),
    this.currency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupsCompanion.insert({
    required String id,
    required int updatedAt,
    this.deleted = const Value.absent(),
    required String name,
    this.currency = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       name = Value(name);
  static Insertable<GroupRow> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<String>? name,
    Expression<String>? currency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (name != null) 'name': name,
      if (currency != null) 'currency': currency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupsCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<String>? name,
    Value<String>? currency,
    Value<int>? rowid,
  }) {
    return GroupsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('currency: $currency, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupMembersTable extends GroupMembers with TableInfo<$GroupMembersTable, GroupMemberRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, updatedAt, deleted, groupId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_members';
  @override
  VerificationContext validateIntegrity(Insertable<GroupMemberRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta, deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta, groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupMemberRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupMemberRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      groupId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}group_id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $GroupMembersTable createAlias(String alias) {
    return $GroupMembersTable(attachedDatabase, alias);
  }
}

class GroupMemberRow extends DataClass implements Insertable<GroupMemberRow> {
  final String id;
  final int updatedAt;
  final bool deleted;
  final String groupId;
  final String name;
  const GroupMemberRow({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.groupId,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['group_id'] = Variable<String>(groupId);
    map['name'] = Variable<String>(name);
    return map;
  }

  GroupMembersCompanion toCompanion(bool nullToAbsent) {
    return GroupMembersCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      groupId: Value(groupId),
      name: Value(name),
    );
  }

  factory GroupMemberRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupMemberRow(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      groupId: serializer.fromJson<String>(json['groupId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'groupId': serializer.toJson<String>(groupId),
      'name': serializer.toJson<String>(name),
    };
  }

  GroupMemberRow copyWith({String? id, int? updatedAt, bool? deleted, String? groupId, String? name}) => GroupMemberRow(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    groupId: groupId ?? this.groupId,
    name: name ?? this.name,
  );
  GroupMemberRow copyWithCompanion(GroupMembersCompanion data) {
    return GroupMemberRow(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupMemberRow(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, updatedAt, deleted, groupId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupMemberRow &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.groupId == this.groupId &&
          other.name == this.name);
}

class GroupMembersCompanion extends UpdateCompanion<GroupMemberRow> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<String> groupId;
  final Value<String> name;
  final Value<int> rowid;
  const GroupMembersCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.groupId = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupMembersCompanion.insert({
    required String id,
    required int updatedAt,
    this.deleted = const Value.absent(),
    required String groupId,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       groupId = Value(groupId),
       name = Value(name);
  static Insertable<GroupMemberRow> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<String>? groupId,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (groupId != null) 'group_id': groupId,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupMembersCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<String>? groupId,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return GroupMembersCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupMembersCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupExpensesTable extends GroupExpenses with TableInfo<$GroupExpensesTable, GroupExpenseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta('amountMinor');
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidByMeta = const VerificationMeta('paidBy');
  @override
  late final GeneratedColumn<String> paidBy = GeneratedColumn<String>(
    'paid_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _splitTypeMeta = const VerificationMeta('splitType');
  @override
  late final GeneratedColumn<String> splitType = GeneratedColumn<String>(
    'split_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sharesMeta = const VerificationMeta('shares');
  @override
  late final GeneratedColumn<String> shares = GeneratedColumn<String>(
    'shares',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<int> occurredAt = GeneratedColumn<int>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    groupId,
    description,
    amountMinor,
    paidBy,
    splitType,
    shares,
    occurredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_expenses';
  @override
  VerificationContext validateIntegrity(Insertable<GroupExpenseRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta, deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta, groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(_descriptionMeta, description.isAcceptableOrUnknown(data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(_amountMinorMeta, amountMinor.isAcceptableOrUnknown(data['amount_minor']!, _amountMinorMeta));
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('paid_by')) {
      context.handle(_paidByMeta, paidBy.isAcceptableOrUnknown(data['paid_by']!, _paidByMeta));
    } else if (isInserting) {
      context.missing(_paidByMeta);
    }
    if (data.containsKey('split_type')) {
      context.handle(_splitTypeMeta, splitType.isAcceptableOrUnknown(data['split_type']!, _splitTypeMeta));
    } else if (isInserting) {
      context.missing(_splitTypeMeta);
    }
    if (data.containsKey('shares')) {
      context.handle(_sharesMeta, shares.isAcceptableOrUnknown(data['shares']!, _sharesMeta));
    } else if (isInserting) {
      context.missing(_sharesMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(_occurredAtMeta, occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta));
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupExpenseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupExpenseRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      groupId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}group_id'])!,
      description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      amountMinor: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}amount_minor'])!,
      paidBy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}paid_by'])!,
      splitType: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}split_type'])!,
      shares: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}shares'])!,
      occurredAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}occurred_at'])!,
    );
  }

  @override
  $GroupExpensesTable createAlias(String alias) {
    return $GroupExpensesTable(attachedDatabase, alias);
  }
}

class GroupExpenseRow extends DataClass implements Insertable<GroupExpenseRow> {
  final String id;
  final int updatedAt;
  final bool deleted;
  final String groupId;
  final String description;
  final int amountMinor;
  final String paidBy;
  final String splitType;

  /// JSON object of memberId -> owed amount in minor units.
  final String shares;
  final int occurredAt;
  const GroupExpenseRow({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.groupId,
    required this.description,
    required this.amountMinor,
    required this.paidBy,
    required this.splitType,
    required this.shares,
    required this.occurredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['group_id'] = Variable<String>(groupId);
    map['description'] = Variable<String>(description);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['paid_by'] = Variable<String>(paidBy);
    map['split_type'] = Variable<String>(splitType);
    map['shares'] = Variable<String>(shares);
    map['occurred_at'] = Variable<int>(occurredAt);
    return map;
  }

  GroupExpensesCompanion toCompanion(bool nullToAbsent) {
    return GroupExpensesCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      groupId: Value(groupId),
      description: Value(description),
      amountMinor: Value(amountMinor),
      paidBy: Value(paidBy),
      splitType: Value(splitType),
      shares: Value(shares),
      occurredAt: Value(occurredAt),
    );
  }

  factory GroupExpenseRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupExpenseRow(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      groupId: serializer.fromJson<String>(json['groupId']),
      description: serializer.fromJson<String>(json['description']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      paidBy: serializer.fromJson<String>(json['paidBy']),
      splitType: serializer.fromJson<String>(json['splitType']),
      shares: serializer.fromJson<String>(json['shares']),
      occurredAt: serializer.fromJson<int>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'groupId': serializer.toJson<String>(groupId),
      'description': serializer.toJson<String>(description),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'paidBy': serializer.toJson<String>(paidBy),
      'splitType': serializer.toJson<String>(splitType),
      'shares': serializer.toJson<String>(shares),
      'occurredAt': serializer.toJson<int>(occurredAt),
    };
  }

  GroupExpenseRow copyWith({
    String? id,
    int? updatedAt,
    bool? deleted,
    String? groupId,
    String? description,
    int? amountMinor,
    String? paidBy,
    String? splitType,
    String? shares,
    int? occurredAt,
  }) => GroupExpenseRow(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    groupId: groupId ?? this.groupId,
    description: description ?? this.description,
    amountMinor: amountMinor ?? this.amountMinor,
    paidBy: paidBy ?? this.paidBy,
    splitType: splitType ?? this.splitType,
    shares: shares ?? this.shares,
    occurredAt: occurredAt ?? this.occurredAt,
  );
  GroupExpenseRow copyWithCompanion(GroupExpensesCompanion data) {
    return GroupExpenseRow(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      description: data.description.present ? data.description.value : this.description,
      amountMinor: data.amountMinor.present ? data.amountMinor.value : this.amountMinor,
      paidBy: data.paidBy.present ? data.paidBy.value : this.paidBy,
      splitType: data.splitType.present ? data.splitType.value : this.splitType,
      shares: data.shares.present ? data.shares.value : this.shares,
      occurredAt: data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupExpenseRow(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('groupId: $groupId, ')
          ..write('description: $description, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('paidBy: $paidBy, ')
          ..write('splitType: $splitType, ')
          ..write('shares: $shares, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, updatedAt, deleted, groupId, description, amountMinor, paidBy, splitType, shares, occurredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupExpenseRow &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.groupId == this.groupId &&
          other.description == this.description &&
          other.amountMinor == this.amountMinor &&
          other.paidBy == this.paidBy &&
          other.splitType == this.splitType &&
          other.shares == this.shares &&
          other.occurredAt == this.occurredAt);
}

class GroupExpensesCompanion extends UpdateCompanion<GroupExpenseRow> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<String> groupId;
  final Value<String> description;
  final Value<int> amountMinor;
  final Value<String> paidBy;
  final Value<String> splitType;
  final Value<String> shares;
  final Value<int> occurredAt;
  final Value<int> rowid;
  const GroupExpensesCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.groupId = const Value.absent(),
    this.description = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.paidBy = const Value.absent(),
    this.splitType = const Value.absent(),
    this.shares = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupExpensesCompanion.insert({
    required String id,
    required int updatedAt,
    this.deleted = const Value.absent(),
    required String groupId,
    required String description,
    required int amountMinor,
    required String paidBy,
    required String splitType,
    required String shares,
    required int occurredAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       groupId = Value(groupId),
       description = Value(description),
       amountMinor = Value(amountMinor),
       paidBy = Value(paidBy),
       splitType = Value(splitType),
       shares = Value(shares),
       occurredAt = Value(occurredAt);
  static Insertable<GroupExpenseRow> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<String>? groupId,
    Expression<String>? description,
    Expression<int>? amountMinor,
    Expression<String>? paidBy,
    Expression<String>? splitType,
    Expression<String>? shares,
    Expression<int>? occurredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (groupId != null) 'group_id': groupId,
      if (description != null) 'description': description,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (paidBy != null) 'paid_by': paidBy,
      if (splitType != null) 'split_type': splitType,
      if (shares != null) 'shares': shares,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupExpensesCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<String>? groupId,
    Value<String>? description,
    Value<int>? amountMinor,
    Value<String>? paidBy,
    Value<String>? splitType,
    Value<String>? shares,
    Value<int>? occurredAt,
    Value<int>? rowid,
  }) {
    return GroupExpensesCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      groupId: groupId ?? this.groupId,
      description: description ?? this.description,
      amountMinor: amountMinor ?? this.amountMinor,
      paidBy: paidBy ?? this.paidBy,
      splitType: splitType ?? this.splitType,
      shares: shares ?? this.shares,
      occurredAt: occurredAt ?? this.occurredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (paidBy.present) {
      map['paid_by'] = Variable<String>(paidBy.value);
    }
    if (splitType.present) {
      map['split_type'] = Variable<String>(splitType.value);
    }
    if (shares.present) {
      map['shares'] = Variable<String>(shares.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<int>(occurredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupExpensesCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('groupId: $groupId, ')
          ..write('description: $description, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('paidBy: $paidBy, ')
          ..write('splitType: $splitType, ')
          ..write('shares: $shares, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettlementsTable extends Settlements with TableInfo<$SettlementsTable, SettlementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettlementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromMemberMeta = const VerificationMeta('fromMember');
  @override
  late final GeneratedColumn<String> fromMember = GeneratedColumn<String>(
    'from_member',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toMemberMeta = const VerificationMeta('toMember');
  @override
  late final GeneratedColumn<String> toMember = GeneratedColumn<String>(
    'to_member',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta('amountMinor');
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<int> occurredAt = GeneratedColumn<int>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    deleted,
    groupId,
    fromMember,
    toMember,
    amountMinor,
    occurredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settlements';
  @override
  VerificationContext validateIntegrity(Insertable<SettlementRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta, deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta, groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('from_member')) {
      context.handle(_fromMemberMeta, fromMember.isAcceptableOrUnknown(data['from_member']!, _fromMemberMeta));
    } else if (isInserting) {
      context.missing(_fromMemberMeta);
    }
    if (data.containsKey('to_member')) {
      context.handle(_toMemberMeta, toMember.isAcceptableOrUnknown(data['to_member']!, _toMemberMeta));
    } else if (isInserting) {
      context.missing(_toMemberMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(_amountMinorMeta, amountMinor.isAcceptableOrUnknown(data['amount_minor']!, _amountMinorMeta));
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(_occurredAtMeta, occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta));
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettlementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettlementRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      groupId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}group_id'])!,
      fromMember: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}from_member'])!,
      toMember: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}to_member'])!,
      amountMinor: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}amount_minor'])!,
      occurredAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}occurred_at'])!,
    );
  }

  @override
  $SettlementsTable createAlias(String alias) {
    return $SettlementsTable(attachedDatabase, alias);
  }
}

class SettlementRow extends DataClass implements Insertable<SettlementRow> {
  final String id;
  final int updatedAt;
  final bool deleted;
  final String groupId;
  final String fromMember;
  final String toMember;
  final int amountMinor;
  final int occurredAt;
  const SettlementRow({
    required this.id,
    required this.updatedAt,
    required this.deleted,
    required this.groupId,
    required this.fromMember,
    required this.toMember,
    required this.amountMinor,
    required this.occurredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    map['group_id'] = Variable<String>(groupId);
    map['from_member'] = Variable<String>(fromMember);
    map['to_member'] = Variable<String>(toMember);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['occurred_at'] = Variable<int>(occurredAt);
    return map;
  }

  SettlementsCompanion toCompanion(bool nullToAbsent) {
    return SettlementsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
      groupId: Value(groupId),
      fromMember: Value(fromMember),
      toMember: Value(toMember),
      amountMinor: Value(amountMinor),
      occurredAt: Value(occurredAt),
    );
  }

  factory SettlementRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettlementRow(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      groupId: serializer.fromJson<String>(json['groupId']),
      fromMember: serializer.fromJson<String>(json['fromMember']),
      toMember: serializer.fromJson<String>(json['toMember']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      occurredAt: serializer.fromJson<int>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
      'groupId': serializer.toJson<String>(groupId),
      'fromMember': serializer.toJson<String>(fromMember),
      'toMember': serializer.toJson<String>(toMember),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'occurredAt': serializer.toJson<int>(occurredAt),
    };
  }

  SettlementRow copyWith({
    String? id,
    int? updatedAt,
    bool? deleted,
    String? groupId,
    String? fromMember,
    String? toMember,
    int? amountMinor,
    int? occurredAt,
  }) => SettlementRow(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
    groupId: groupId ?? this.groupId,
    fromMember: fromMember ?? this.fromMember,
    toMember: toMember ?? this.toMember,
    amountMinor: amountMinor ?? this.amountMinor,
    occurredAt: occurredAt ?? this.occurredAt,
  );
  SettlementRow copyWithCompanion(SettlementsCompanion data) {
    return SettlementRow(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      fromMember: data.fromMember.present ? data.fromMember.value : this.fromMember,
      toMember: data.toMember.present ? data.toMember.value : this.toMember,
      amountMinor: data.amountMinor.present ? data.amountMinor.value : this.amountMinor,
      occurredAt: data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettlementRow(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('groupId: $groupId, ')
          ..write('fromMember: $fromMember, ')
          ..write('toMember: $toMember, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, updatedAt, deleted, groupId, fromMember, toMember, amountMinor, occurredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettlementRow &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted &&
          other.groupId == this.groupId &&
          other.fromMember == this.fromMember &&
          other.toMember == this.toMember &&
          other.amountMinor == this.amountMinor &&
          other.occurredAt == this.occurredAt);
}

class SettlementsCompanion extends UpdateCompanion<SettlementRow> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<bool> deleted;
  final Value<String> groupId;
  final Value<String> fromMember;
  final Value<String> toMember;
  final Value<int> amountMinor;
  final Value<int> occurredAt;
  final Value<int> rowid;
  const SettlementsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.groupId = const Value.absent(),
    this.fromMember = const Value.absent(),
    this.toMember = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettlementsCompanion.insert({
    required String id,
    required int updatedAt,
    this.deleted = const Value.absent(),
    required String groupId,
    required String fromMember,
    required String toMember,
    required int amountMinor,
    required int occurredAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       groupId = Value(groupId),
       fromMember = Value(fromMember),
       toMember = Value(toMember),
       amountMinor = Value(amountMinor),
       occurredAt = Value(occurredAt);
  static Insertable<SettlementRow> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<bool>? deleted,
    Expression<String>? groupId,
    Expression<String>? fromMember,
    Expression<String>? toMember,
    Expression<int>? amountMinor,
    Expression<int>? occurredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (groupId != null) 'group_id': groupId,
      if (fromMember != null) 'from_member': fromMember,
      if (toMember != null) 'to_member': toMember,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettlementsCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<bool>? deleted,
    Value<String>? groupId,
    Value<String>? fromMember,
    Value<String>? toMember,
    Value<int>? amountMinor,
    Value<int>? occurredAt,
    Value<int>? rowid,
  }) {
    return SettlementsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      groupId: groupId ?? this.groupId,
      fromMember: fromMember ?? this.fromMember,
      toMember: toMember ?? this.toMember,
      amountMinor: amountMinor ?? this.amountMinor,
      occurredAt: occurredAt ?? this.occurredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (fromMember.present) {
      map['from_member'] = Variable<String>(fromMember.value);
    }
    if (toMember.present) {
      map['to_member'] = Variable<String>(toMember.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<int>(occurredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettlementsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('groupId: $groupId, ')
          ..write('fromMember: $fromMember, ')
          ..write('toMember: $toMember, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillRemindersTable extends BillReminders with TableInfo<$BillRemindersTable, BillReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta('amountMinor');
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOfMonthMeta = const VerificationMeta('dayOfMonth');
  @override
  late final GeneratedColumn<int> dayOfMonth = GeneratedColumn<int>(
    'day_of_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, amountMinor, dayOfMonth, enabled];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_reminders';
  @override
  VerificationContext validateIntegrity(Insertable<BillReminderRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(_amountMinorMeta, amountMinor.isAcceptableOrUnknown(data['amount_minor']!, _amountMinorMeta));
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('day_of_month')) {
      context.handle(_dayOfMonthMeta, dayOfMonth.isAcceptableOrUnknown(data['day_of_month']!, _dayOfMonthMeta));
    } else if (isInserting) {
      context.missing(_dayOfMonthMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta, enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillReminderRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      amountMinor: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}amount_minor'])!,
      dayOfMonth: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}day_of_month'])!,
      enabled: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
    );
  }

  @override
  $BillRemindersTable createAlias(String alias) {
    return $BillRemindersTable(attachedDatabase, alias);
  }
}

class BillReminderRow extends DataClass implements Insertable<BillReminderRow> {
  final int id;
  final String title;
  final int amountMinor;
  final int dayOfMonth;
  final bool enabled;
  const BillReminderRow({
    required this.id,
    required this.title,
    required this.amountMinor,
    required this.dayOfMonth,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['day_of_month'] = Variable<int>(dayOfMonth);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  BillRemindersCompanion toCompanion(bool nullToAbsent) {
    return BillRemindersCompanion(
      id: Value(id),
      title: Value(title),
      amountMinor: Value(amountMinor),
      dayOfMonth: Value(dayOfMonth),
      enabled: Value(enabled),
    );
  }

  factory BillReminderRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillReminderRow(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      dayOfMonth: serializer.fromJson<int>(json['dayOfMonth']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'dayOfMonth': serializer.toJson<int>(dayOfMonth),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  BillReminderRow copyWith({int? id, String? title, int? amountMinor, int? dayOfMonth, bool? enabled}) =>
      BillReminderRow(
        id: id ?? this.id,
        title: title ?? this.title,
        amountMinor: amountMinor ?? this.amountMinor,
        dayOfMonth: dayOfMonth ?? this.dayOfMonth,
        enabled: enabled ?? this.enabled,
      );
  BillReminderRow copyWithCompanion(BillRemindersCompanion data) {
    return BillReminderRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amountMinor: data.amountMinor.present ? data.amountMinor.value : this.amountMinor,
      dayOfMonth: data.dayOfMonth.present ? data.dayOfMonth.value : this.dayOfMonth,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillReminderRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, amountMinor, dayOfMonth, enabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillReminderRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.amountMinor == this.amountMinor &&
          other.dayOfMonth == this.dayOfMonth &&
          other.enabled == this.enabled);
}

class BillRemindersCompanion extends UpdateCompanion<BillReminderRow> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> amountMinor;
  final Value<int> dayOfMonth;
  final Value<bool> enabled;
  const BillRemindersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.enabled = const Value.absent(),
  });
  BillRemindersCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required int amountMinor,
    required int dayOfMonth,
    this.enabled = const Value.absent(),
  }) : title = Value(title),
       amountMinor = Value(amountMinor),
       dayOfMonth = Value(dayOfMonth);
  static Insertable<BillReminderRow> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? amountMinor,
    Expression<int>? dayOfMonth,
    Expression<bool>? enabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (dayOfMonth != null) 'day_of_month': dayOfMonth,
      if (enabled != null) 'enabled': enabled,
    });
  }

  BillRemindersCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int>? amountMinor,
    Value<int>? dayOfMonth,
    Value<bool>? enabled,
  }) {
    return BillRemindersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amountMinor: amountMinor ?? this.amountMinor,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (dayOfMonth.present) {
      map['day_of_month'] = Variable<int>(dayOfMonth.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillRemindersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue with TableInfo<$SyncQueueTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
    'entity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _revisionMeta = const VerificationMeta('revision');
  @override
  late final GeneratedColumn<int> revision = GeneratedColumn<int>(
    'revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, entity, recordId, payload, revision, attempts, lastError, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<OutboxEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity')) {
      context.handle(_entityMeta, entity.isAcceptableOrUnknown(data['entity']!, _entityMeta));
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta, recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta, payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('revision')) {
      context.handle(_revisionMeta, revision.isAcceptableOrUnknown(data['revision']!, _revisionMeta));
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta, attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta, lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      entity: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}entity'])!,
      recordId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}record_id'])!,
      payload: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      revision: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}revision'])!,
      attempts: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      lastError: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  final int id;
  final String entity;
  final String recordId;
  final String payload;
  final int revision;
  final int attempts;
  final String? lastError;
  final int createdAt;
  const OutboxEntry({
    required this.id,
    required this.entity,
    required this.recordId,
    required this.payload,
    required this.revision,
    required this.attempts,
    this.lastError,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity'] = Variable<String>(entity);
    map['record_id'] = Variable<String>(recordId);
    map['payload'] = Variable<String>(payload);
    map['revision'] = Variable<int>(revision);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      entity: Value(entity),
      recordId: Value(recordId),
      payload: Value(payload),
      revision: Value(revision),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent ? const Value.absent() : Value(lastError),
      createdAt: Value(createdAt),
    );
  }

  factory OutboxEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      id: serializer.fromJson<int>(json['id']),
      entity: serializer.fromJson<String>(json['entity']),
      recordId: serializer.fromJson<String>(json['recordId']),
      payload: serializer.fromJson<String>(json['payload']),
      revision: serializer.fromJson<int>(json['revision']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entity': serializer.toJson<String>(entity),
      'recordId': serializer.toJson<String>(recordId),
      'payload': serializer.toJson<String>(payload),
      'revision': serializer.toJson<int>(revision),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  OutboxEntry copyWith({
    int? id,
    String? entity,
    String? recordId,
    String? payload,
    int? revision,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    int? createdAt,
  }) => OutboxEntry(
    id: id ?? this.id,
    entity: entity ?? this.entity,
    recordId: recordId ?? this.recordId,
    payload: payload ?? this.payload,
    revision: revision ?? this.revision,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
  );
  OutboxEntry copyWithCompanion(SyncQueueCompanion data) {
    return OutboxEntry(
      id: data.id.present ? data.id.value : this.id,
      entity: data.entity.present ? data.entity.value : this.entity,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      payload: data.payload.present ? data.payload.value : this.payload,
      revision: data.revision.present ? data.revision.value : this.revision,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('recordId: $recordId, ')
          ..write('payload: $payload, ')
          ..write('revision: $revision, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entity, recordId, payload, revision, attempts, lastError, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.id == this.id &&
          other.entity == this.entity &&
          other.recordId == this.recordId &&
          other.payload == this.payload &&
          other.revision == this.revision &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt);
}

class SyncQueueCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<int> id;
  final Value<String> entity;
  final Value<String> recordId;
  final Value<String> payload;
  final Value<int> revision;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<int> createdAt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.entity = const Value.absent(),
    this.recordId = const Value.absent(),
    this.payload = const Value.absent(),
    this.revision = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String entity,
    required String recordId,
    required String payload,
    this.revision = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    required int createdAt,
  }) : entity = Value(entity),
       recordId = Value(recordId),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<OutboxEntry> custom({
    Expression<int>? id,
    Expression<String>? entity,
    Expression<String>? recordId,
    Expression<String>? payload,
    Expression<int>? revision,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entity != null) 'entity': entity,
      if (recordId != null) 'record_id': recordId,
      if (payload != null) 'payload': payload,
      if (revision != null) 'revision': revision,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? entity,
    Value<String>? recordId,
    Value<String>? payload,
    Value<int>? revision,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<int>? createdAt,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      entity: entity ?? this.entity,
      recordId: recordId ?? this.recordId,
      payload: payload ?? this.payload,
      revision: revision ?? this.revision,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (revision.present) {
      map['revision'] = Variable<int>(revision.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entity: $entity, ')
          ..write('recordId: $recordId, ')
          ..write('payload: $payload, ')
          ..write('revision: $revision, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SyncMetaTable extends SyncMeta with TableInfo<$SyncMetaTable, SyncMetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_meta';
  @override
  VerificationContext validateIntegrity(Insertable<SyncMetaRow> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(_keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(_valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncMetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetaRow(
      key: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $SyncMetaTable createAlias(String alias) {
    return $SyncMetaTable(attachedDatabase, alias);
  }
}

class SyncMetaRow extends DataClass implements Insertable<SyncMetaRow> {
  final String key;
  final String value;
  const SyncMetaRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SyncMetaCompanion toCompanion(bool nullToAbsent) {
    return SyncMetaCompanion(key: Value(key), value: Value(value));
  }

  factory SyncMetaRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetaRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'key': serializer.toJson<String>(key), 'value': serializer.toJson<String>(value)};
  }

  SyncMetaRow copyWith({String? key, String? value}) => SyncMetaRow(key: key ?? this.key, value: value ?? this.value);
  SyncMetaRow copyWithCompanion(SyncMetaCompanion data) {
    return SyncMetaRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is SyncMetaRow && other.key == this.key && other.value == this.value);
}

class SyncMetaCompanion extends UpdateCompanion<SyncMetaRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SyncMetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetaCompanion.insert({required String key, required String value, this.rowid = const Value.absent()})
    : key = Value(key),
      value = Value(value);
  static Insertable<SyncMetaRow> custom({Expression<String>? key, Expression<String>? value, Expression<int>? rowid}) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetaCompanion copyWith({Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return SyncMetaCompanion(key: key ?? this.key, value: value ?? this.value, rowid: rowid ?? this.rowid);
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
    return (StringBuffer('SyncMetaCompanion(')
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
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $GroupMembersTable groupMembers = $GroupMembersTable(this);
  late final $GroupExpensesTable groupExpenses = $GroupExpensesTable(this);
  late final $SettlementsTable settlements = $SettlementsTable(this);
  late final $BillRemindersTable billReminders = $BillRemindersTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $SyncMetaTable syncMeta = $SyncMetaTable(this);
  late final Index idxTransactionsOccurredAt = Index(
    'idx_transactions_occurred_at',
    'CREATE INDEX idx_transactions_occurred_at ON transactions (occurred_at)',
  );
  late final Index idxGroupMembersGroup = Index(
    'idx_group_members_group',
    'CREATE INDEX idx_group_members_group ON group_members (group_id)',
  );
  late final Index idxGroupExpensesGroup = Index(
    'idx_group_expenses_group',
    'CREATE INDEX idx_group_expenses_group ON group_expenses (group_id)',
  );
  late final Index idxSettlementsGroup = Index(
    'idx_settlements_group',
    'CREATE INDEX idx_settlements_group ON settlements (group_id)',
  );
  late final Index idxSyncQueueRecord = Index(
    'idx_sync_queue_record',
    'CREATE UNIQUE INDEX idx_sync_queue_record ON sync_queue (entity, record_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    transactions,
    goals,
    groups,
    groupMembers,
    groupExpenses,
    settlements,
    billReminders,
    syncQueue,
    syncMeta,
    idxTransactionsOccurredAt,
    idxGroupMembersGroup,
    idxGroupExpensesGroup,
    idxSettlementsGroup,
    idxSyncQueueRecord,
  ];
}

typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion Function({
  required String id,
  required int updatedAt,
  Value<bool> deleted,
  required String type,
  required int amountMinor,
  Value<String> currency,
  required String category,
  Value<String?> merchant,
  Value<String?> note,
  required int occurredAt,
  Value<String> recurrence,
  Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion Function({
  Value<String> id,
  Value<int> updatedAt,
  Value<bool> deleted,
  Value<String> type,
  Value<int> amountMinor,
  Value<String> currency,
  Value<String> category,
  Value<String?> merchant,
  Value<String?> note,
  Value<int> occurredAt,
  Value<String> recurrence,
  Value<int> rowid,
});

class $$TransactionsTableFilterComposer extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMinor =>
      $composableBuilder(column: $table.amountMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get occurredAt =>
      $composableBuilder(column: $table.occurredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurrence =>
      $composableBuilder(column: $table.recurrence, builder: (column) => ColumnFilters(column));
}

class $$TransactionsTableOrderingComposer extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMinor =>
      $composableBuilder(column: $table.amountMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get occurredAt =>
      $composableBuilder(column: $table.occurredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrence =>
      $composableBuilder(column: $table.recurrence, builder: (column) => ColumnOrderings(column));
}

class $$TransactionsTableAnnotationComposer extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted => $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get type => $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(column: $table.amountMinor, builder: (column) => column);

  GeneratedColumn<String> get currency => $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get category => $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get merchant => $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<String> get note => $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get occurredAt => $composableBuilder(column: $table.occurredAt, builder: (column) => column);

  GeneratedColumn<String> get recurrence => $composableBuilder(column: $table.recurrence, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          TransactionRow,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (TransactionRow, BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow>),
          TransactionRow,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> merchant = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> occurredAt = const Value.absent(),
                Value<String> recurrence = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                type: type,
                amountMinor: amountMinor,
                currency: currency,
                category: category,
                merchant: merchant,
                note: note,
                occurredAt: occurredAt,
                recurrence: recurrence,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                required String type,
                required int amountMinor,
                Value<String> currency = const Value.absent(),
                required String category,
                Value<String?> merchant = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required int occurredAt,
                Value<String> recurrence = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                type: type,
                amountMinor: amountMinor,
                currency: currency,
                category: category,
                merchant: merchant,
                note: note,
                occurredAt: occurredAt,
                recurrence: recurrence,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, TransactionRow>(table),
                  BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      TransactionRow,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (TransactionRow, BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow>),
      TransactionRow,
      PrefetchHooks Function()
    >;
typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  required String id,
  required int updatedAt,
  Value<bool> deleted,
  required String name,
  required int targetMinor,
  Value<int> savedMinor,
  Value<String> currency,
  required int deadline,
  Value<int> rowid,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<String> id,
  Value<int> updatedAt,
  Value<bool> deleted,
  Value<String> name,
  Value<int> targetMinor,
  Value<int> savedMinor,
  Value<String> currency,
  Value<int> deadline,
  Value<int> rowid,
});

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetMinor =>
      $composableBuilder(column: $table.targetMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get savedMinor =>
      $composableBuilder(column: $table.savedMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => ColumnFilters(column));
}

class $$GoalsTableOrderingComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetMinor =>
      $composableBuilder(column: $table.targetMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get savedMinor =>
      $composableBuilder(column: $table.savedMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => ColumnOrderings(column));
}

class $$GoalsTableAnnotationComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted => $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetMinor => $composableBuilder(column: $table.targetMinor, builder: (column) => column);

  GeneratedColumn<int> get savedMinor => $composableBuilder(column: $table.savedMinor, builder: (column) => column);

  GeneratedColumn<String> get currency => $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get deadline => $composableBuilder(column: $table.deadline, builder: (column) => column);
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          GoalRow,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (GoalRow, BaseReferences<_$AppDatabase, $GoalsTable, GoalRow>),
          GoalRow,
          PrefetchHooks Function()
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> targetMinor = const Value.absent(),
                Value<int> savedMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> deadline = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                name: name,
                targetMinor: targetMinor,
                savedMinor: savedMinor,
                currency: currency,
                deadline: deadline,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                required String name,
                required int targetMinor,
                Value<int> savedMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                required int deadline,
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                name: name,
                targetMinor: targetMinor,
                savedMinor: savedMinor,
                currency: currency,
                deadline: deadline,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GoalsTable, GoalRow>(table),
                  BaseReferences<_$AppDatabase, $GoalsTable, GoalRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      GoalRow,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (GoalRow, BaseReferences<_$AppDatabase, $GoalsTable, GoalRow>),
      GoalRow,
      PrefetchHooks Function()
    >;
typedef $$GroupsTableCreateCompanionBuilder = GroupsCompanion Function({
  required String id,
  required int updatedAt,
  Value<bool> deleted,
  required String name,
  Value<String> currency,
  Value<int> rowid,
});
typedef $$GroupsTableUpdateCompanionBuilder = GroupsCompanion Function({
  Value<String> id,
  Value<int> updatedAt,
  Value<bool> deleted,
  Value<String> name,
  Value<String> currency,
  Value<int> rowid,
});

class $$GroupsTableFilterComposer extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnFilters(column));
}

class $$GroupsTableOrderingComposer extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => ColumnOrderings(column));
}

class $$GroupsTableAnnotationComposer extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted => $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get currency => $composableBuilder(column: $table.currency, builder: (column) => column);
}

class $$GroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupsTable,
          GroupRow,
          $$GroupsTableFilterComposer,
          $$GroupsTableOrderingComposer,
          $$GroupsTableAnnotationComposer,
          $$GroupsTableCreateCompanionBuilder,
          $$GroupsTableUpdateCompanionBuilder,
          (GroupRow, BaseReferences<_$AppDatabase, $GroupsTable, GroupRow>),
          GroupRow,
          PrefetchHooks Function()
        > {
  $$GroupsTableTableManager(_$AppDatabase db, $GroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$GroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$GroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$GroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                name: name,
                currency: currency,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                required String name,
                Value<String> currency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                name: name,
                currency: currency,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GroupsTable, GroupRow>(table),
                  BaseReferences<_$AppDatabase, $GroupsTable, GroupRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupsTable,
      GroupRow,
      $$GroupsTableFilterComposer,
      $$GroupsTableOrderingComposer,
      $$GroupsTableAnnotationComposer,
      $$GroupsTableCreateCompanionBuilder,
      $$GroupsTableUpdateCompanionBuilder,
      (GroupRow, BaseReferences<_$AppDatabase, $GroupsTable, GroupRow>),
      GroupRow,
      PrefetchHooks Function()
    >;
typedef $$GroupMembersTableCreateCompanionBuilder = GroupMembersCompanion Function({
  required String id,
  required int updatedAt,
  Value<bool> deleted,
  required String groupId,
  required String name,
  Value<int> rowid,
});
typedef $$GroupMembersTableUpdateCompanionBuilder = GroupMembersCompanion Function({
  Value<String> id,
  Value<int> updatedAt,
  Value<bool> deleted,
  Value<String> groupId,
  Value<String> name,
  Value<int> rowid,
});

class $$GroupMembersTableFilterComposer extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$GroupMembersTableOrderingComposer extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$GroupMembersTableAnnotationComposer extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted => $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get groupId => $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$GroupMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupMembersTable,
          GroupMemberRow,
          $$GroupMembersTableFilterComposer,
          $$GroupMembersTableOrderingComposer,
          $$GroupMembersTableAnnotationComposer,
          $$GroupMembersTableCreateCompanionBuilder,
          $$GroupMembersTableUpdateCompanionBuilder,
          (GroupMemberRow, BaseReferences<_$AppDatabase, $GroupMembersTable, GroupMemberRow>),
          GroupMemberRow,
          PrefetchHooks Function()
        > {
  $$GroupMembersTableTableManager(_$AppDatabase db, $GroupMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$GroupMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$GroupMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$GroupMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupMembersCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                groupId: groupId,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                required String groupId,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => GroupMembersCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                groupId: groupId,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GroupMembersTable, GroupMemberRow>(table),
                  BaseReferences<_$AppDatabase, $GroupMembersTable, GroupMemberRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GroupMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupMembersTable,
      GroupMemberRow,
      $$GroupMembersTableFilterComposer,
      $$GroupMembersTableOrderingComposer,
      $$GroupMembersTableAnnotationComposer,
      $$GroupMembersTableCreateCompanionBuilder,
      $$GroupMembersTableUpdateCompanionBuilder,
      (GroupMemberRow, BaseReferences<_$AppDatabase, $GroupMembersTable, GroupMemberRow>),
      GroupMemberRow,
      PrefetchHooks Function()
    >;
typedef $$GroupExpensesTableCreateCompanionBuilder = GroupExpensesCompanion Function({
  required String id,
  required int updatedAt,
  Value<bool> deleted,
  required String groupId,
  required String description,
  required int amountMinor,
  required String paidBy,
  required String splitType,
  required String shares,
  required int occurredAt,
  Value<int> rowid,
});
typedef $$GroupExpensesTableUpdateCompanionBuilder = GroupExpensesCompanion Function({
  Value<String> id,
  Value<int> updatedAt,
  Value<bool> deleted,
  Value<String> groupId,
  Value<String> description,
  Value<int> amountMinor,
  Value<String> paidBy,
  Value<String> splitType,
  Value<String> shares,
  Value<int> occurredAt,
  Value<int> rowid,
});

class $$GroupExpensesTableFilterComposer extends Composer<_$AppDatabase, $GroupExpensesTable> {
  $$GroupExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description =>
      $composableBuilder(column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMinor =>
      $composableBuilder(column: $table.amountMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paidBy =>
      $composableBuilder(column: $table.paidBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get splitType =>
      $composableBuilder(column: $table.splitType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shares =>
      $composableBuilder(column: $table.shares, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get occurredAt =>
      $composableBuilder(column: $table.occurredAt, builder: (column) => ColumnFilters(column));
}

class $$GroupExpensesTableOrderingComposer extends Composer<_$AppDatabase, $GroupExpensesTable> {
  $$GroupExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description =>
      $composableBuilder(column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMinor =>
      $composableBuilder(column: $table.amountMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paidBy =>
      $composableBuilder(column: $table.paidBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get splitType =>
      $composableBuilder(column: $table.splitType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shares =>
      $composableBuilder(column: $table.shares, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get occurredAt =>
      $composableBuilder(column: $table.occurredAt, builder: (column) => ColumnOrderings(column));
}

class $$GroupExpensesTableAnnotationComposer extends Composer<_$AppDatabase, $GroupExpensesTable> {
  $$GroupExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted => $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get groupId => $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get description =>
      $composableBuilder(column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(column: $table.amountMinor, builder: (column) => column);

  GeneratedColumn<String> get paidBy => $composableBuilder(column: $table.paidBy, builder: (column) => column);

  GeneratedColumn<String> get splitType => $composableBuilder(column: $table.splitType, builder: (column) => column);

  GeneratedColumn<String> get shares => $composableBuilder(column: $table.shares, builder: (column) => column);

  GeneratedColumn<int> get occurredAt => $composableBuilder(column: $table.occurredAt, builder: (column) => column);
}

class $$GroupExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupExpensesTable,
          GroupExpenseRow,
          $$GroupExpensesTableFilterComposer,
          $$GroupExpensesTableOrderingComposer,
          $$GroupExpensesTableAnnotationComposer,
          $$GroupExpensesTableCreateCompanionBuilder,
          $$GroupExpensesTableUpdateCompanionBuilder,
          (GroupExpenseRow, BaseReferences<_$AppDatabase, $GroupExpensesTable, GroupExpenseRow>),
          GroupExpenseRow,
          PrefetchHooks Function()
        > {
  $$GroupExpensesTableTableManager(_$AppDatabase db, $GroupExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$GroupExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$GroupExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$GroupExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> paidBy = const Value.absent(),
                Value<String> splitType = const Value.absent(),
                Value<String> shares = const Value.absent(),
                Value<int> occurredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupExpensesCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                groupId: groupId,
                description: description,
                amountMinor: amountMinor,
                paidBy: paidBy,
                splitType: splitType,
                shares: shares,
                occurredAt: occurredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                required String groupId,
                required String description,
                required int amountMinor,
                required String paidBy,
                required String splitType,
                required String shares,
                required int occurredAt,
                Value<int> rowid = const Value.absent(),
              }) => GroupExpensesCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                groupId: groupId,
                description: description,
                amountMinor: amountMinor,
                paidBy: paidBy,
                splitType: splitType,
                shares: shares,
                occurredAt: occurredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GroupExpensesTable, GroupExpenseRow>(table),
                  BaseReferences<_$AppDatabase, $GroupExpensesTable, GroupExpenseRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GroupExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupExpensesTable,
      GroupExpenseRow,
      $$GroupExpensesTableFilterComposer,
      $$GroupExpensesTableOrderingComposer,
      $$GroupExpensesTableAnnotationComposer,
      $$GroupExpensesTableCreateCompanionBuilder,
      $$GroupExpensesTableUpdateCompanionBuilder,
      (GroupExpenseRow, BaseReferences<_$AppDatabase, $GroupExpensesTable, GroupExpenseRow>),
      GroupExpenseRow,
      PrefetchHooks Function()
    >;
typedef $$SettlementsTableCreateCompanionBuilder = SettlementsCompanion Function({
  required String id,
  required int updatedAt,
  Value<bool> deleted,
  required String groupId,
  required String fromMember,
  required String toMember,
  required int amountMinor,
  required int occurredAt,
  Value<int> rowid,
});
typedef $$SettlementsTableUpdateCompanionBuilder = SettlementsCompanion Function({
  Value<String> id,
  Value<int> updatedAt,
  Value<bool> deleted,
  Value<String> groupId,
  Value<String> fromMember,
  Value<String> toMember,
  Value<int> amountMinor,
  Value<int> occurredAt,
  Value<int> rowid,
});

class $$SettlementsTableFilterComposer extends Composer<_$AppDatabase, $SettlementsTable> {
  $$SettlementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromMember =>
      $composableBuilder(column: $table.fromMember, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toMember =>
      $composableBuilder(column: $table.toMember, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMinor =>
      $composableBuilder(column: $table.amountMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get occurredAt =>
      $composableBuilder(column: $table.occurredAt, builder: (column) => ColumnFilters(column));
}

class $$SettlementsTableOrderingComposer extends Composer<_$AppDatabase, $SettlementsTable> {
  $$SettlementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromMember =>
      $composableBuilder(column: $table.fromMember, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toMember =>
      $composableBuilder(column: $table.toMember, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMinor =>
      $composableBuilder(column: $table.amountMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get occurredAt =>
      $composableBuilder(column: $table.occurredAt, builder: (column) => ColumnOrderings(column));
}

class $$SettlementsTableAnnotationComposer extends Composer<_$AppDatabase, $SettlementsTable> {
  $$SettlementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted => $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get groupId => $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get fromMember => $composableBuilder(column: $table.fromMember, builder: (column) => column);

  GeneratedColumn<String> get toMember => $composableBuilder(column: $table.toMember, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(column: $table.amountMinor, builder: (column) => column);

  GeneratedColumn<int> get occurredAt => $composableBuilder(column: $table.occurredAt, builder: (column) => column);
}

class $$SettlementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettlementsTable,
          SettlementRow,
          $$SettlementsTableFilterComposer,
          $$SettlementsTableOrderingComposer,
          $$SettlementsTableAnnotationComposer,
          $$SettlementsTableCreateCompanionBuilder,
          $$SettlementsTableUpdateCompanionBuilder,
          (SettlementRow, BaseReferences<_$AppDatabase, $SettlementsTable, SettlementRow>),
          SettlementRow,
          PrefetchHooks Function()
        > {
  $$SettlementsTableTableManager(_$AppDatabase db, $SettlementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SettlementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SettlementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$SettlementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> fromMember = const Value.absent(),
                Value<String> toMember = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<int> occurredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettlementsCompanion(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                groupId: groupId,
                fromMember: fromMember,
                toMember: toMember,
                amountMinor: amountMinor,
                occurredAt: occurredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                Value<bool> deleted = const Value.absent(),
                required String groupId,
                required String fromMember,
                required String toMember,
                required int amountMinor,
                required int occurredAt,
                Value<int> rowid = const Value.absent(),
              }) => SettlementsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                deleted: deleted,
                groupId: groupId,
                fromMember: fromMember,
                toMember: toMember,
                amountMinor: amountMinor,
                occurredAt: occurredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettlementsTable, SettlementRow>(table),
                  BaseReferences<_$AppDatabase, $SettlementsTable, SettlementRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettlementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettlementsTable,
      SettlementRow,
      $$SettlementsTableFilterComposer,
      $$SettlementsTableOrderingComposer,
      $$SettlementsTableAnnotationComposer,
      $$SettlementsTableCreateCompanionBuilder,
      $$SettlementsTableUpdateCompanionBuilder,
      (SettlementRow, BaseReferences<_$AppDatabase, $SettlementsTable, SettlementRow>),
      SettlementRow,
      PrefetchHooks Function()
    >;
typedef $$BillRemindersTableCreateCompanionBuilder = BillRemindersCompanion Function({
  Value<int> id,
  required String title,
  required int amountMinor,
  required int dayOfMonth,
  Value<bool> enabled,
});
typedef $$BillRemindersTableUpdateCompanionBuilder = BillRemindersCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<int> amountMinor,
  Value<int> dayOfMonth,
  Value<bool> enabled,
});

class $$BillRemindersTableFilterComposer extends Composer<_$AppDatabase, $BillRemindersTable> {
  $$BillRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMinor =>
      $composableBuilder(column: $table.amountMinor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dayOfMonth =>
      $composableBuilder(column: $table.dayOfMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => ColumnFilters(column));
}

class $$BillRemindersTableOrderingComposer extends Composer<_$AppDatabase, $BillRemindersTable> {
  $$BillRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMinor =>
      $composableBuilder(column: $table.amountMinor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dayOfMonth =>
      $composableBuilder(column: $table.dayOfMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => ColumnOrderings(column));
}

class $$BillRemindersTableAnnotationComposer extends Composer<_$AppDatabase, $BillRemindersTable> {
  $$BillRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title => $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(column: $table.amountMinor, builder: (column) => column);

  GeneratedColumn<int> get dayOfMonth => $composableBuilder(column: $table.dayOfMonth, builder: (column) => column);

  GeneratedColumn<bool> get enabled => $composableBuilder(column: $table.enabled, builder: (column) => column);
}

class $$BillRemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillRemindersTable,
          BillReminderRow,
          $$BillRemindersTableFilterComposer,
          $$BillRemindersTableOrderingComposer,
          $$BillRemindersTableAnnotationComposer,
          $$BillRemindersTableCreateCompanionBuilder,
          $$BillRemindersTableUpdateCompanionBuilder,
          (BillReminderRow, BaseReferences<_$AppDatabase, $BillRemindersTable, BillReminderRow>),
          BillReminderRow,
          PrefetchHooks Function()
        > {
  $$BillRemindersTableTableManager(_$AppDatabase db, $BillRemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$BillRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$BillRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$BillRemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<int> dayOfMonth = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
              }) => BillRemindersCompanion(
                id: id,
                title: title,
                amountMinor: amountMinor,
                dayOfMonth: dayOfMonth,
                enabled: enabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required int amountMinor,
                required int dayOfMonth,
                Value<bool> enabled = const Value.absent(),
              }) => BillRemindersCompanion.insert(
                id: id,
                title: title,
                amountMinor: amountMinor,
                dayOfMonth: dayOfMonth,
                enabled: enabled,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BillRemindersTable, BillReminderRow>(table),
                  BaseReferences<_$AppDatabase, $BillRemindersTable, BillReminderRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BillRemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillRemindersTable,
      BillReminderRow,
      $$BillRemindersTableFilterComposer,
      $$BillRemindersTableOrderingComposer,
      $$BillRemindersTableAnnotationComposer,
      $$BillRemindersTableCreateCompanionBuilder,
      $$BillRemindersTableUpdateCompanionBuilder,
      (BillReminderRow, BaseReferences<_$AppDatabase, $BillRemindersTable, BillReminderRow>),
      BillReminderRow,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  required String entity,
  required String recordId,
  required String payload,
  Value<int> revision,
  Value<int> attempts,
  Value<String?> lastError,
  required int createdAt,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  Value<String> entity,
  Value<String> recordId,
  Value<String> payload,
  Value<int> revision,
  Value<int> attempts,
  Value<String?> lastError,
  Value<int> createdAt,
});

class $$SyncQueueTableFilterComposer extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get revision =>
      $composableBuilder(column: $table.revision, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entity => $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get recordId => $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get payload => $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get revision => $composableBuilder(column: $table.revision, builder: (column) => column);

  GeneratedColumn<int> get attempts => $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError => $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<int> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          OutboxEntry,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (OutboxEntry, BaseReferences<_$AppDatabase, $SyncQueueTable, OutboxEntry>),
          OutboxEntry,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entity = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> revision = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                entity: entity,
                recordId: recordId,
                payload: payload,
                revision: revision,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entity,
                required String recordId,
                required String payload,
                Value<int> revision = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required int createdAt,
              }) => SyncQueueCompanion.insert(
                id: id,
                entity: entity,
                recordId: recordId,
                payload: payload,
                revision: revision,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncQueueTable, OutboxEntry>(table),
                  BaseReferences<_$AppDatabase, $SyncQueueTable, OutboxEntry>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      OutboxEntry,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (OutboxEntry, BaseReferences<_$AppDatabase, $SyncQueueTable, OutboxEntry>),
      OutboxEntry,
      PrefetchHooks Function()
    >;
typedef $$SyncMetaTableCreateCompanionBuilder = SyncMetaCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SyncMetaTableUpdateCompanionBuilder = SyncMetaCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SyncMetaTableFilterComposer extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$SyncMetaTableOrderingComposer extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$SyncMetaTableAnnotationComposer extends Composer<_$AppDatabase, $SyncMetaTable> {
  $$SyncMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key => $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value => $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SyncMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetaTable,
          SyncMetaRow,
          $$SyncMetaTableFilterComposer,
          $$SyncMetaTableOrderingComposer,
          $$SyncMetaTableAnnotationComposer,
          $$SyncMetaTableCreateCompanionBuilder,
          $$SyncMetaTableUpdateCompanionBuilder,
          (SyncMetaRow, BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaRow>),
          SyncMetaRow,
          PrefetchHooks Function()
        > {
  $$SyncMetaTableTableManager(_$AppDatabase db, $SyncMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SyncMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SyncMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$SyncMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SyncMetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SyncMetaCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncMetaTable, SyncMetaRow>(table),
                  BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetaTable,
      SyncMetaRow,
      $$SyncMetaTableFilterComposer,
      $$SyncMetaTableOrderingComposer,
      $$SyncMetaTableAnnotationComposer,
      $$SyncMetaTableCreateCompanionBuilder,
      $$SyncMetaTableUpdateCompanionBuilder,
      (SyncMetaRow, BaseReferences<_$AppDatabase, $SyncMetaTable, SyncMetaRow>),
      SyncMetaRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions => $$TransactionsTableTableManager(_db, _db.transactions);
  $$GoalsTableTableManager get goals => $$GoalsTableTableManager(_db, _db.goals);
  $$GroupsTableTableManager get groups => $$GroupsTableTableManager(_db, _db.groups);
  $$GroupMembersTableTableManager get groupMembers => $$GroupMembersTableTableManager(_db, _db.groupMembers);
  $$GroupExpensesTableTableManager get groupExpenses => $$GroupExpensesTableTableManager(_db, _db.groupExpenses);
  $$SettlementsTableTableManager get settlements => $$SettlementsTableTableManager(_db, _db.settlements);
  $$BillRemindersTableTableManager get billReminders => $$BillRemindersTableTableManager(_db, _db.billReminders);
  $$SyncQueueTableTableManager get syncQueue => $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$SyncMetaTableTableManager get syncMeta => $$SyncMetaTableTableManager(_db, _db.syncMeta);
}
