// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PaymentMethodsTable extends PaymentMethods
    with TableInfo<$PaymentMethodsTable, PaymentMethod> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentMethodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
      'alias', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _last4Meta = const VerificationMeta('last4');
  @override
  late final GeneratedColumn<String> last4 = GeneratedColumn<String>(
      'last4', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _issuerMeta = const VerificationMeta('issuer');
  @override
  late final GeneratedColumn<String> issuer = GeneratedColumn<String>(
      'issuer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, alias, last4, issuer, isDefault, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_methods';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentMethod> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
          _aliasMeta, alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta));
    } else if (isInserting) {
      context.missing(_aliasMeta);
    }
    if (data.containsKey('last4')) {
      context.handle(
          _last4Meta, last4.isAcceptableOrUnknown(data['last4']!, _last4Meta));
    }
    if (data.containsKey('issuer')) {
      context.handle(_issuerMeta,
          issuer.isAcceptableOrUnknown(data['issuer']!, _issuerMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentMethod map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentMethod(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      alias: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alias'])!,
      last4: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last4']),
      issuer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}issuer']),
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PaymentMethodsTable createAlias(String alias) {
    return $PaymentMethodsTable(attachedDatabase, alias);
  }
}

class PaymentMethod extends DataClass implements Insertable<PaymentMethod> {
  final String id;
  final String type;
  final String alias;
  final String? last4;
  final String? issuer;
  final bool isDefault;
  final int createdAt;
  const PaymentMethod(
      {required this.id,
      required this.type,
      required this.alias,
      this.last4,
      this.issuer,
      required this.isDefault,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['alias'] = Variable<String>(alias);
    if (!nullToAbsent || last4 != null) {
      map['last4'] = Variable<String>(last4);
    }
    if (!nullToAbsent || issuer != null) {
      map['issuer'] = Variable<String>(issuer);
    }
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  PaymentMethodsCompanion toCompanion(bool nullToAbsent) {
    return PaymentMethodsCompanion(
      id: Value(id),
      type: Value(type),
      alias: Value(alias),
      last4:
          last4 == null && nullToAbsent ? const Value.absent() : Value(last4),
      issuer:
          issuer == null && nullToAbsent ? const Value.absent() : Value(issuer),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
    );
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentMethod(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      alias: serializer.fromJson<String>(json['alias']),
      last4: serializer.fromJson<String?>(json['last4']),
      issuer: serializer.fromJson<String?>(json['issuer']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'alias': serializer.toJson<String>(alias),
      'last4': serializer.toJson<String?>(last4),
      'issuer': serializer.toJson<String?>(issuer),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  PaymentMethod copyWith(
          {String? id,
          String? type,
          String? alias,
          Value<String?> last4 = const Value.absent(),
          Value<String?> issuer = const Value.absent(),
          bool? isDefault,
          int? createdAt}) =>
      PaymentMethod(
        id: id ?? this.id,
        type: type ?? this.type,
        alias: alias ?? this.alias,
        last4: last4.present ? last4.value : this.last4,
        issuer: issuer.present ? issuer.value : this.issuer,
        isDefault: isDefault ?? this.isDefault,
        createdAt: createdAt ?? this.createdAt,
      );
  PaymentMethod copyWithCompanion(PaymentMethodsCompanion data) {
    return PaymentMethod(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      alias: data.alias.present ? data.alias.value : this.alias,
      last4: data.last4.present ? data.last4.value : this.last4,
      issuer: data.issuer.present ? data.issuer.value : this.issuer,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMethod(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('alias: $alias, ')
          ..write('last4: $last4, ')
          ..write('issuer: $issuer, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, alias, last4, issuer, isDefault, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentMethod &&
          other.id == this.id &&
          other.type == this.type &&
          other.alias == this.alias &&
          other.last4 == this.last4 &&
          other.issuer == this.issuer &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt);
}

class PaymentMethodsCompanion extends UpdateCompanion<PaymentMethod> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> alias;
  final Value<String?> last4;
  final Value<String?> issuer;
  final Value<bool> isDefault;
  final Value<int> createdAt;
  final Value<int> rowid;
  const PaymentMethodsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.alias = const Value.absent(),
    this.last4 = const Value.absent(),
    this.issuer = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentMethodsCompanion.insert({
    required String id,
    required String type,
    required String alias,
    this.last4 = const Value.absent(),
    this.issuer = const Value.absent(),
    this.isDefault = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        alias = Value(alias),
        createdAt = Value(createdAt);
  static Insertable<PaymentMethod> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? alias,
    Expression<String>? last4,
    Expression<String>? issuer,
    Expression<bool>? isDefault,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (alias != null) 'alias': alias,
      if (last4 != null) 'last4': last4,
      if (issuer != null) 'issuer': issuer,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentMethodsCompanion copyWith(
      {Value<String>? id,
      Value<String>? type,
      Value<String>? alias,
      Value<String?>? last4,
      Value<String?>? issuer,
      Value<bool>? isDefault,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return PaymentMethodsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      alias: alias ?? this.alias,
      last4: last4 ?? this.last4,
      issuer: issuer ?? this.issuer,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (last4.present) {
      map['last4'] = Variable<String>(last4.value);
    }
    if (issuer.present) {
      map['issuer'] = Variable<String>(issuer.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentMethodsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('alias: $alias, ')
          ..write('last4: $last4, ')
          ..write('issuer: $issuer, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardsTable extends Cards with TableInfo<$CardsTable, Card> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ultimas4Meta =
      const VerificationMeta('ultimas4');
  @override
  late final GeneratedColumn<String> ultimas4 = GeneratedColumn<String>(
      'ultimas4', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, nombre, ultimas4, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(Insertable<Card> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('ultimas4')) {
      context.handle(_ultimas4Meta,
          ultimas4.isAcceptableOrUnknown(data['ultimas4']!, _ultimas4Meta));
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
  Card map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Card(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      ultimas4: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ultimas4']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }
}

class Card extends DataClass implements Insertable<Card> {
  final String id;
  final String nombre;
  final String? ultimas4;
  final String? color;
  const Card(
      {required this.id, required this.nombre, this.ultimas4, this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || ultimas4 != null) {
      map['ultimas4'] = Variable<String>(ultimas4);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      nombre: Value(nombre),
      ultimas4: ultimas4 == null && nullToAbsent
          ? const Value.absent()
          : Value(ultimas4),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
    );
  }

  factory Card.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Card(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      ultimas4: serializer.fromJson<String?>(json['ultimas4']),
      color: serializer.fromJson<String?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'ultimas4': serializer.toJson<String?>(ultimas4),
      'color': serializer.toJson<String?>(color),
    };
  }

  Card copyWith(
          {String? id,
          String? nombre,
          Value<String?> ultimas4 = const Value.absent(),
          Value<String?> color = const Value.absent()}) =>
      Card(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        ultimas4: ultimas4.present ? ultimas4.value : this.ultimas4,
        color: color.present ? color.value : this.color,
      );
  Card copyWithCompanion(CardsCompanion data) {
    return Card(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      ultimas4: data.ultimas4.present ? data.ultimas4.value : this.ultimas4,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Card(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('ultimas4: $ultimas4, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, ultimas4, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Card &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.ultimas4 == this.ultimas4 &&
          other.color == this.color);
}

class CardsCompanion extends UpdateCompanion<Card> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String?> ultimas4;
  final Value<String?> color;
  final Value<int> rowid;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.ultimas4 = const Value.absent(),
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardsCompanion.insert({
    required String id,
    required String nombre,
    this.ultimas4 = const Value.absent(),
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nombre = Value(nombre);
  static Insertable<Card> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? ultimas4,
    Expression<String>? color,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (ultimas4 != null) 'ultimas4': ultimas4,
      if (color != null) 'color': color,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardsCompanion copyWith(
      {Value<String>? id,
      Value<String>? nombre,
      Value<String?>? ultimas4,
      Value<String?>? color,
      Value<int>? rowid}) {
    return CardsCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      ultimas4: ultimas4 ?? this.ultimas4,
      color: color ?? this.color,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (ultimas4.present) {
      map['ultimas4'] = Variable<String>(ultimas4.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('ultimas4: $ultimas4, ')
          ..write('color: $color, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DebtTemplatesTable extends DebtTemplates
    with TableInfo<$DebtTemplatesTable, DebtTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoriaMeta =
      const VerificationMeta('categoria');
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
      'categoria', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _montoMeta = const VerificationMeta('monto');
  @override
  late final GeneratedColumn<double> monto = GeneratedColumn<double>(
      'monto', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currentBalanceMeta =
      const VerificationMeta('currentBalance');
  @override
  late final GeneratedColumn<double> currentBalance = GeneratedColumn<double>(
      'current_balance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
      'card_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cards (id) ON DELETE SET NULL'));
  static const VerificationMeta _paymentMethodIdMeta =
      const VerificationMeta('paymentMethodId');
  @override
  late final GeneratedColumn<String> paymentMethodId = GeneratedColumn<String>(
      'payment_method_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES payment_methods (id) ON DELETE SET NULL'));
  static const VerificationMeta _hasInterestMeta =
      const VerificationMeta('hasInterest');
  @override
  late final GeneratedColumn<bool> hasInterest = GeneratedColumn<bool>(
      'has_interest', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_interest" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _interestTypeMeta =
      const VerificationMeta('interestType');
  @override
  late final GeneratedColumn<String> interestType = GeneratedColumn<String>(
      'interest_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _interestRateMonthlyMeta =
      const VerificationMeta('interestRateMonthly');
  @override
  late final GeneratedColumn<double> interestRateMonthly =
      GeneratedColumn<double>('interest_rate_monthly', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _termMonthsMeta =
      const VerificationMeta('termMonths');
  @override
  late final GeneratedColumn<int> termMonths = GeneratedColumn<int>(
      'term_months', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _graceMonthsMeta =
      const VerificationMeta('graceMonths');
  @override
  late final GeneratedColumn<int> graceMonths = GeneratedColumn<int>(
      'grace_months', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
      'notas', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nombre,
        categoria,
        monto,
        currentBalance,
        cardId,
        paymentMethodId,
        hasInterest,
        interestType,
        interestRateMonthly,
        termMonths,
        graceMonths,
        categoryId,
        notas,
        isArchived,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debt_templates';
  @override
  VerificationContext validateIntegrity(Insertable<DebtTemplate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(_categoriaMeta,
          categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta));
    }
    if (data.containsKey('monto')) {
      context.handle(
          _montoMeta, monto.isAcceptableOrUnknown(data['monto']!, _montoMeta));
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('current_balance')) {
      context.handle(
          _currentBalanceMeta,
          currentBalance.isAcceptableOrUnknown(
              data['current_balance']!, _currentBalanceMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    }
    if (data.containsKey('payment_method_id')) {
      context.handle(
          _paymentMethodIdMeta,
          paymentMethodId.isAcceptableOrUnknown(
              data['payment_method_id']!, _paymentMethodIdMeta));
    }
    if (data.containsKey('has_interest')) {
      context.handle(
          _hasInterestMeta,
          hasInterest.isAcceptableOrUnknown(
              data['has_interest']!, _hasInterestMeta));
    }
    if (data.containsKey('interest_type')) {
      context.handle(
          _interestTypeMeta,
          interestType.isAcceptableOrUnknown(
              data['interest_type']!, _interestTypeMeta));
    }
    if (data.containsKey('interest_rate_monthly')) {
      context.handle(
          _interestRateMonthlyMeta,
          interestRateMonthly.isAcceptableOrUnknown(
              data['interest_rate_monthly']!, _interestRateMonthlyMeta));
    }
    if (data.containsKey('term_months')) {
      context.handle(
          _termMonthsMeta,
          termMonths.isAcceptableOrUnknown(
              data['term_months']!, _termMonthsMeta));
    }
    if (data.containsKey('grace_months')) {
      context.handle(
          _graceMonthsMeta,
          graceMonths.isAcceptableOrUnknown(
              data['grace_months']!, _graceMonthsMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('notas')) {
      context.handle(
          _notasMeta, notas.isAcceptableOrUnknown(data['notas']!, _notasMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebtTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebtTemplate(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      categoria: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}categoria']),
      monto: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monto'])!,
      currentBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_balance']),
      cardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_id']),
      paymentMethodId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}payment_method_id']),
      hasInterest: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_interest'])!,
      interestType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}interest_type']),
      interestRateMonthly: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}interest_rate_monthly']),
      termMonths: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}term_months']),
      graceMonths: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grace_months']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      notas: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notas']),
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $DebtTemplatesTable createAlias(String alias) {
    return $DebtTemplatesTable(attachedDatabase, alias);
  }
}

class DebtTemplate extends DataClass implements Insertable<DebtTemplate> {
  final String id;
  final String nombre;
  final String? categoria;
  final double monto;
  final double? currentBalance;
  final String? cardId;
  final String? paymentMethodId;
  final bool hasInterest;
  final String? interestType;
  final double? interestRateMonthly;
  final int? termMonths;
  final int? graceMonths;
  final String? categoryId;
  final String? notas;
  final bool isArchived;
  final int? createdAt;
  final int? updatedAt;
  const DebtTemplate(
      {required this.id,
      required this.nombre,
      this.categoria,
      required this.monto,
      this.currentBalance,
      this.cardId,
      this.paymentMethodId,
      required this.hasInterest,
      this.interestType,
      this.interestRateMonthly,
      this.termMonths,
      this.graceMonths,
      this.categoryId,
      this.notas,
      required this.isArchived,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || categoria != null) {
      map['categoria'] = Variable<String>(categoria);
    }
    map['monto'] = Variable<double>(monto);
    if (!nullToAbsent || currentBalance != null) {
      map['current_balance'] = Variable<double>(currentBalance);
    }
    if (!nullToAbsent || cardId != null) {
      map['card_id'] = Variable<String>(cardId);
    }
    if (!nullToAbsent || paymentMethodId != null) {
      map['payment_method_id'] = Variable<String>(paymentMethodId);
    }
    map['has_interest'] = Variable<bool>(hasInterest);
    if (!nullToAbsent || interestType != null) {
      map['interest_type'] = Variable<String>(interestType);
    }
    if (!nullToAbsent || interestRateMonthly != null) {
      map['interest_rate_monthly'] = Variable<double>(interestRateMonthly);
    }
    if (!nullToAbsent || termMonths != null) {
      map['term_months'] = Variable<int>(termMonths);
    }
    if (!nullToAbsent || graceMonths != null) {
      map['grace_months'] = Variable<int>(graceMonths);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  DebtTemplatesCompanion toCompanion(bool nullToAbsent) {
    return DebtTemplatesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      categoria: categoria == null && nullToAbsent
          ? const Value.absent()
          : Value(categoria),
      monto: Value(monto),
      currentBalance: currentBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(currentBalance),
      cardId:
          cardId == null && nullToAbsent ? const Value.absent() : Value(cardId),
      paymentMethodId: paymentMethodId == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethodId),
      hasInterest: Value(hasInterest),
      interestType: interestType == null && nullToAbsent
          ? const Value.absent()
          : Value(interestType),
      interestRateMonthly: interestRateMonthly == null && nullToAbsent
          ? const Value.absent()
          : Value(interestRateMonthly),
      termMonths: termMonths == null && nullToAbsent
          ? const Value.absent()
          : Value(termMonths),
      graceMonths: graceMonths == null && nullToAbsent
          ? const Value.absent()
          : Value(graceMonths),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      notas:
          notas == null && nullToAbsent ? const Value.absent() : Value(notas),
      isArchived: Value(isArchived),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory DebtTemplate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebtTemplate(
      id: serializer.fromJson<String>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      categoria: serializer.fromJson<String?>(json['categoria']),
      monto: serializer.fromJson<double>(json['monto']),
      currentBalance: serializer.fromJson<double?>(json['currentBalance']),
      cardId: serializer.fromJson<String?>(json['cardId']),
      paymentMethodId: serializer.fromJson<String?>(json['paymentMethodId']),
      hasInterest: serializer.fromJson<bool>(json['hasInterest']),
      interestType: serializer.fromJson<String?>(json['interestType']),
      interestRateMonthly:
          serializer.fromJson<double?>(json['interestRateMonthly']),
      termMonths: serializer.fromJson<int?>(json['termMonths']),
      graceMonths: serializer.fromJson<int?>(json['graceMonths']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      notas: serializer.fromJson<String?>(json['notas']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nombre': serializer.toJson<String>(nombre),
      'categoria': serializer.toJson<String?>(categoria),
      'monto': serializer.toJson<double>(monto),
      'currentBalance': serializer.toJson<double?>(currentBalance),
      'cardId': serializer.toJson<String?>(cardId),
      'paymentMethodId': serializer.toJson<String?>(paymentMethodId),
      'hasInterest': serializer.toJson<bool>(hasInterest),
      'interestType': serializer.toJson<String?>(interestType),
      'interestRateMonthly': serializer.toJson<double?>(interestRateMonthly),
      'termMonths': serializer.toJson<int?>(termMonths),
      'graceMonths': serializer.toJson<int?>(graceMonths),
      'categoryId': serializer.toJson<String?>(categoryId),
      'notas': serializer.toJson<String?>(notas),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  DebtTemplate copyWith(
          {String? id,
          String? nombre,
          Value<String?> categoria = const Value.absent(),
          double? monto,
          Value<double?> currentBalance = const Value.absent(),
          Value<String?> cardId = const Value.absent(),
          Value<String?> paymentMethodId = const Value.absent(),
          bool? hasInterest,
          Value<String?> interestType = const Value.absent(),
          Value<double?> interestRateMonthly = const Value.absent(),
          Value<int?> termMonths = const Value.absent(),
          Value<int?> graceMonths = const Value.absent(),
          Value<String?> categoryId = const Value.absent(),
          Value<String?> notas = const Value.absent(),
          bool? isArchived,
          Value<int?> createdAt = const Value.absent(),
          Value<int?> updatedAt = const Value.absent()}) =>
      DebtTemplate(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        categoria: categoria.present ? categoria.value : this.categoria,
        monto: monto ?? this.monto,
        currentBalance:
            currentBalance.present ? currentBalance.value : this.currentBalance,
        cardId: cardId.present ? cardId.value : this.cardId,
        paymentMethodId: paymentMethodId.present
            ? paymentMethodId.value
            : this.paymentMethodId,
        hasInterest: hasInterest ?? this.hasInterest,
        interestType:
            interestType.present ? interestType.value : this.interestType,
        interestRateMonthly: interestRateMonthly.present
            ? interestRateMonthly.value
            : this.interestRateMonthly,
        termMonths: termMonths.present ? termMonths.value : this.termMonths,
        graceMonths: graceMonths.present ? graceMonths.value : this.graceMonths,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        notas: notas.present ? notas.value : this.notas,
        isArchived: isArchived ?? this.isArchived,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  DebtTemplate copyWithCompanion(DebtTemplatesCompanion data) {
    return DebtTemplate(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      monto: data.monto.present ? data.monto.value : this.monto,
      currentBalance: data.currentBalance.present
          ? data.currentBalance.value
          : this.currentBalance,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      paymentMethodId: data.paymentMethodId.present
          ? data.paymentMethodId.value
          : this.paymentMethodId,
      hasInterest:
          data.hasInterest.present ? data.hasInterest.value : this.hasInterest,
      interestType: data.interestType.present
          ? data.interestType.value
          : this.interestType,
      interestRateMonthly: data.interestRateMonthly.present
          ? data.interestRateMonthly.value
          : this.interestRateMonthly,
      termMonths:
          data.termMonths.present ? data.termMonths.value : this.termMonths,
      graceMonths:
          data.graceMonths.present ? data.graceMonths.value : this.graceMonths,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      notas: data.notas.present ? data.notas.value : this.notas,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebtTemplate(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('categoria: $categoria, ')
          ..write('monto: $monto, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('cardId: $cardId, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('hasInterest: $hasInterest, ')
          ..write('interestType: $interestType, ')
          ..write('interestRateMonthly: $interestRateMonthly, ')
          ..write('termMonths: $termMonths, ')
          ..write('graceMonths: $graceMonths, ')
          ..write('categoryId: $categoryId, ')
          ..write('notas: $notas, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      nombre,
      categoria,
      monto,
      currentBalance,
      cardId,
      paymentMethodId,
      hasInterest,
      interestType,
      interestRateMonthly,
      termMonths,
      graceMonths,
      categoryId,
      notas,
      isArchived,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebtTemplate &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.categoria == this.categoria &&
          other.monto == this.monto &&
          other.currentBalance == this.currentBalance &&
          other.cardId == this.cardId &&
          other.paymentMethodId == this.paymentMethodId &&
          other.hasInterest == this.hasInterest &&
          other.interestType == this.interestType &&
          other.interestRateMonthly == this.interestRateMonthly &&
          other.termMonths == this.termMonths &&
          other.graceMonths == this.graceMonths &&
          other.categoryId == this.categoryId &&
          other.notas == this.notas &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DebtTemplatesCompanion extends UpdateCompanion<DebtTemplate> {
  final Value<String> id;
  final Value<String> nombre;
  final Value<String?> categoria;
  final Value<double> monto;
  final Value<double?> currentBalance;
  final Value<String?> cardId;
  final Value<String?> paymentMethodId;
  final Value<bool> hasInterest;
  final Value<String?> interestType;
  final Value<double?> interestRateMonthly;
  final Value<int?> termMonths;
  final Value<int?> graceMonths;
  final Value<String?> categoryId;
  final Value<String?> notas;
  final Value<bool> isArchived;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  final Value<int> rowid;
  const DebtTemplatesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.categoria = const Value.absent(),
    this.monto = const Value.absent(),
    this.currentBalance = const Value.absent(),
    this.cardId = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.hasInterest = const Value.absent(),
    this.interestType = const Value.absent(),
    this.interestRateMonthly = const Value.absent(),
    this.termMonths = const Value.absent(),
    this.graceMonths = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.notas = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DebtTemplatesCompanion.insert({
    required String id,
    required String nombre,
    this.categoria = const Value.absent(),
    required double monto,
    this.currentBalance = const Value.absent(),
    this.cardId = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.hasInterest = const Value.absent(),
    this.interestType = const Value.absent(),
    this.interestRateMonthly = const Value.absent(),
    this.termMonths = const Value.absent(),
    this.graceMonths = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.notas = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nombre = Value(nombre),
        monto = Value(monto);
  static Insertable<DebtTemplate> custom({
    Expression<String>? id,
    Expression<String>? nombre,
    Expression<String>? categoria,
    Expression<double>? monto,
    Expression<double>? currentBalance,
    Expression<String>? cardId,
    Expression<String>? paymentMethodId,
    Expression<bool>? hasInterest,
    Expression<String>? interestType,
    Expression<double>? interestRateMonthly,
    Expression<int>? termMonths,
    Expression<int>? graceMonths,
    Expression<String>? categoryId,
    Expression<String>? notas,
    Expression<bool>? isArchived,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (categoria != null) 'categoria': categoria,
      if (monto != null) 'monto': monto,
      if (currentBalance != null) 'current_balance': currentBalance,
      if (cardId != null) 'card_id': cardId,
      if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      if (hasInterest != null) 'has_interest': hasInterest,
      if (interestType != null) 'interest_type': interestType,
      if (interestRateMonthly != null)
        'interest_rate_monthly': interestRateMonthly,
      if (termMonths != null) 'term_months': termMonths,
      if (graceMonths != null) 'grace_months': graceMonths,
      if (categoryId != null) 'category_id': categoryId,
      if (notas != null) 'notas': notas,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DebtTemplatesCompanion copyWith(
      {Value<String>? id,
      Value<String>? nombre,
      Value<String?>? categoria,
      Value<double>? monto,
      Value<double?>? currentBalance,
      Value<String?>? cardId,
      Value<String?>? paymentMethodId,
      Value<bool>? hasInterest,
      Value<String?>? interestType,
      Value<double?>? interestRateMonthly,
      Value<int?>? termMonths,
      Value<int?>? graceMonths,
      Value<String?>? categoryId,
      Value<String?>? notas,
      Value<bool>? isArchived,
      Value<int?>? createdAt,
      Value<int?>? updatedAt,
      Value<int>? rowid}) {
    return DebtTemplatesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      monto: monto ?? this.monto,
      currentBalance: currentBalance ?? this.currentBalance,
      cardId: cardId ?? this.cardId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      hasInterest: hasInterest ?? this.hasInterest,
      interestType: interestType ?? this.interestType,
      interestRateMonthly: interestRateMonthly ?? this.interestRateMonthly,
      termMonths: termMonths ?? this.termMonths,
      graceMonths: graceMonths ?? this.graceMonths,
      categoryId: categoryId ?? this.categoryId,
      notas: notas ?? this.notas,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (currentBalance.present) {
      map['current_balance'] = Variable<double>(currentBalance.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (paymentMethodId.present) {
      map['payment_method_id'] = Variable<String>(paymentMethodId.value);
    }
    if (hasInterest.present) {
      map['has_interest'] = Variable<bool>(hasInterest.value);
    }
    if (interestType.present) {
      map['interest_type'] = Variable<String>(interestType.value);
    }
    if (interestRateMonthly.present) {
      map['interest_rate_monthly'] =
          Variable<double>(interestRateMonthly.value);
    }
    if (termMonths.present) {
      map['term_months'] = Variable<int>(termMonths.value);
    }
    if (graceMonths.present) {
      map['grace_months'] = Variable<int>(graceMonths.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('categoria: $categoria, ')
          ..write('monto: $monto, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('cardId: $cardId, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('hasInterest: $hasInterest, ')
          ..write('interestType: $interestType, ')
          ..write('interestRateMonthly: $interestRateMonthly, ')
          ..write('termMonths: $termMonths, ')
          ..write('graceMonths: $graceMonths, ')
          ..write('categoryId: $categoryId, ')
          ..write('notas: $notas, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurrencesTable extends Recurrences
    with TableInfo<$RecurrencesTable, Recurrence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurrencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _templateIdMeta =
      const VerificationMeta('templateId');
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
      'template_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES debt_templates (id) ON DELETE CASCADE'));
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
      'tipo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _diaMesMeta = const VerificationMeta('diaMes');
  @override
  late final GeneratedColumn<int> diaMes = GeneratedColumn<int>(
      'dia_mes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dowMeta = const VerificationMeta('dow');
  @override
  late final GeneratedColumn<int> dow = GeneratedColumn<int>(
      'dow', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _everyNDaysMeta =
      const VerificationMeta('everyNDays');
  @override
  late final GeneratedColumn<int> everyNDays = GeneratedColumn<int>(
      'every_n_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _fechaInicioMeta =
      const VerificationMeta('fechaInicio');
  @override
  late final GeneratedColumn<int> fechaInicio = GeneratedColumn<int>(
      'fecha_inicio', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaFinMeta =
      const VerificationMeta('fechaFin');
  @override
  late final GeneratedColumn<int> fechaFin = GeneratedColumn<int>(
      'fecha_fin', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalCiclosMeta =
      const VerificationMeta('totalCiclos');
  @override
  late final GeneratedColumn<int> totalCiclos = GeneratedColumn<int>(
      'total_ciclos', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _ciclosRestantesMeta =
      const VerificationMeta('ciclosRestantes');
  @override
  late final GeneratedColumn<int> ciclosRestantes = GeneratedColumn<int>(
      'ciclos_restantes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        templateId,
        tipo,
        diaMes,
        dow,
        everyNDays,
        fechaInicio,
        fechaFin,
        totalCiclos,
        ciclosRestantes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurrences';
  @override
  VerificationContext validateIntegrity(Insertable<Recurrence> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
          _templateIdMeta,
          templateId.isAcceptableOrUnknown(
              data['template_id']!, _templateIdMeta));
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
          _tipoMeta, tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta));
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('dia_mes')) {
      context.handle(_diaMesMeta,
          diaMes.isAcceptableOrUnknown(data['dia_mes']!, _diaMesMeta));
    }
    if (data.containsKey('dow')) {
      context.handle(
          _dowMeta, dow.isAcceptableOrUnknown(data['dow']!, _dowMeta));
    }
    if (data.containsKey('every_n_days')) {
      context.handle(
          _everyNDaysMeta,
          everyNDays.isAcceptableOrUnknown(
              data['every_n_days']!, _everyNDaysMeta));
    }
    if (data.containsKey('fecha_inicio')) {
      context.handle(
          _fechaInicioMeta,
          fechaInicio.isAcceptableOrUnknown(
              data['fecha_inicio']!, _fechaInicioMeta));
    } else if (isInserting) {
      context.missing(_fechaInicioMeta);
    }
    if (data.containsKey('fecha_fin')) {
      context.handle(_fechaFinMeta,
          fechaFin.isAcceptableOrUnknown(data['fecha_fin']!, _fechaFinMeta));
    }
    if (data.containsKey('total_ciclos')) {
      context.handle(
          _totalCiclosMeta,
          totalCiclos.isAcceptableOrUnknown(
              data['total_ciclos']!, _totalCiclosMeta));
    }
    if (data.containsKey('ciclos_restantes')) {
      context.handle(
          _ciclosRestantesMeta,
          ciclosRestantes.isAcceptableOrUnknown(
              data['ciclos_restantes']!, _ciclosRestantesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recurrence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recurrence(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      templateId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}template_id'])!,
      tipo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo'])!,
      diaMes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dia_mes']),
      dow: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dow']),
      everyNDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}every_n_days']),
      fechaInicio: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha_inicio'])!,
      fechaFin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha_fin']),
      totalCiclos: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_ciclos']),
      ciclosRestantes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ciclos_restantes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $RecurrencesTable createAlias(String alias) {
    return $RecurrencesTable(attachedDatabase, alias);
  }
}

class Recurrence extends DataClass implements Insertable<Recurrence> {
  final String id;
  final String templateId;
  final String tipo;
  final int? diaMes;
  final int? dow;
  final int? everyNDays;
  final int fechaInicio;
  final int? fechaFin;
  final int? totalCiclos;
  final int? ciclosRestantes;
  final int? createdAt;
  final int? updatedAt;
  const Recurrence(
      {required this.id,
      required this.templateId,
      required this.tipo,
      this.diaMes,
      this.dow,
      this.everyNDays,
      required this.fechaInicio,
      this.fechaFin,
      this.totalCiclos,
      this.ciclosRestantes,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['template_id'] = Variable<String>(templateId);
    map['tipo'] = Variable<String>(tipo);
    if (!nullToAbsent || diaMes != null) {
      map['dia_mes'] = Variable<int>(diaMes);
    }
    if (!nullToAbsent || dow != null) {
      map['dow'] = Variable<int>(dow);
    }
    if (!nullToAbsent || everyNDays != null) {
      map['every_n_days'] = Variable<int>(everyNDays);
    }
    map['fecha_inicio'] = Variable<int>(fechaInicio);
    if (!nullToAbsent || fechaFin != null) {
      map['fecha_fin'] = Variable<int>(fechaFin);
    }
    if (!nullToAbsent || totalCiclos != null) {
      map['total_ciclos'] = Variable<int>(totalCiclos);
    }
    if (!nullToAbsent || ciclosRestantes != null) {
      map['ciclos_restantes'] = Variable<int>(ciclosRestantes);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  RecurrencesCompanion toCompanion(bool nullToAbsent) {
    return RecurrencesCompanion(
      id: Value(id),
      templateId: Value(templateId),
      tipo: Value(tipo),
      diaMes:
          diaMes == null && nullToAbsent ? const Value.absent() : Value(diaMes),
      dow: dow == null && nullToAbsent ? const Value.absent() : Value(dow),
      everyNDays: everyNDays == null && nullToAbsent
          ? const Value.absent()
          : Value(everyNDays),
      fechaInicio: Value(fechaInicio),
      fechaFin: fechaFin == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaFin),
      totalCiclos: totalCiclos == null && nullToAbsent
          ? const Value.absent()
          : Value(totalCiclos),
      ciclosRestantes: ciclosRestantes == null && nullToAbsent
          ? const Value.absent()
          : Value(ciclosRestantes),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Recurrence.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recurrence(
      id: serializer.fromJson<String>(json['id']),
      templateId: serializer.fromJson<String>(json['templateId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      diaMes: serializer.fromJson<int?>(json['diaMes']),
      dow: serializer.fromJson<int?>(json['dow']),
      everyNDays: serializer.fromJson<int?>(json['everyNDays']),
      fechaInicio: serializer.fromJson<int>(json['fechaInicio']),
      fechaFin: serializer.fromJson<int?>(json['fechaFin']),
      totalCiclos: serializer.fromJson<int?>(json['totalCiclos']),
      ciclosRestantes: serializer.fromJson<int?>(json['ciclosRestantes']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'templateId': serializer.toJson<String>(templateId),
      'tipo': serializer.toJson<String>(tipo),
      'diaMes': serializer.toJson<int?>(diaMes),
      'dow': serializer.toJson<int?>(dow),
      'everyNDays': serializer.toJson<int?>(everyNDays),
      'fechaInicio': serializer.toJson<int>(fechaInicio),
      'fechaFin': serializer.toJson<int?>(fechaFin),
      'totalCiclos': serializer.toJson<int?>(totalCiclos),
      'ciclosRestantes': serializer.toJson<int?>(ciclosRestantes),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  Recurrence copyWith(
          {String? id,
          String? templateId,
          String? tipo,
          Value<int?> diaMes = const Value.absent(),
          Value<int?> dow = const Value.absent(),
          Value<int?> everyNDays = const Value.absent(),
          int? fechaInicio,
          Value<int?> fechaFin = const Value.absent(),
          Value<int?> totalCiclos = const Value.absent(),
          Value<int?> ciclosRestantes = const Value.absent(),
          Value<int?> createdAt = const Value.absent(),
          Value<int?> updatedAt = const Value.absent()}) =>
      Recurrence(
        id: id ?? this.id,
        templateId: templateId ?? this.templateId,
        tipo: tipo ?? this.tipo,
        diaMes: diaMes.present ? diaMes.value : this.diaMes,
        dow: dow.present ? dow.value : this.dow,
        everyNDays: everyNDays.present ? everyNDays.value : this.everyNDays,
        fechaInicio: fechaInicio ?? this.fechaInicio,
        fechaFin: fechaFin.present ? fechaFin.value : this.fechaFin,
        totalCiclos: totalCiclos.present ? totalCiclos.value : this.totalCiclos,
        ciclosRestantes: ciclosRestantes.present
            ? ciclosRestantes.value
            : this.ciclosRestantes,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Recurrence copyWithCompanion(RecurrencesCompanion data) {
    return Recurrence(
      id: data.id.present ? data.id.value : this.id,
      templateId:
          data.templateId.present ? data.templateId.value : this.templateId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      diaMes: data.diaMes.present ? data.diaMes.value : this.diaMes,
      dow: data.dow.present ? data.dow.value : this.dow,
      everyNDays:
          data.everyNDays.present ? data.everyNDays.value : this.everyNDays,
      fechaInicio:
          data.fechaInicio.present ? data.fechaInicio.value : this.fechaInicio,
      fechaFin: data.fechaFin.present ? data.fechaFin.value : this.fechaFin,
      totalCiclos:
          data.totalCiclos.present ? data.totalCiclos.value : this.totalCiclos,
      ciclosRestantes: data.ciclosRestantes.present
          ? data.ciclosRestantes.value
          : this.ciclosRestantes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recurrence(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('tipo: $tipo, ')
          ..write('diaMes: $diaMes, ')
          ..write('dow: $dow, ')
          ..write('everyNDays: $everyNDays, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('totalCiclos: $totalCiclos, ')
          ..write('ciclosRestantes: $ciclosRestantes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      templateId,
      tipo,
      diaMes,
      dow,
      everyNDays,
      fechaInicio,
      fechaFin,
      totalCiclos,
      ciclosRestantes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recurrence &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.tipo == this.tipo &&
          other.diaMes == this.diaMes &&
          other.dow == this.dow &&
          other.everyNDays == this.everyNDays &&
          other.fechaInicio == this.fechaInicio &&
          other.fechaFin == this.fechaFin &&
          other.totalCiclos == this.totalCiclos &&
          other.ciclosRestantes == this.ciclosRestantes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecurrencesCompanion extends UpdateCompanion<Recurrence> {
  final Value<String> id;
  final Value<String> templateId;
  final Value<String> tipo;
  final Value<int?> diaMes;
  final Value<int?> dow;
  final Value<int?> everyNDays;
  final Value<int> fechaInicio;
  final Value<int?> fechaFin;
  final Value<int?> totalCiclos;
  final Value<int?> ciclosRestantes;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  final Value<int> rowid;
  const RecurrencesCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.diaMes = const Value.absent(),
    this.dow = const Value.absent(),
    this.everyNDays = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaFin = const Value.absent(),
    this.totalCiclos = const Value.absent(),
    this.ciclosRestantes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurrencesCompanion.insert({
    required String id,
    required String templateId,
    required String tipo,
    this.diaMes = const Value.absent(),
    this.dow = const Value.absent(),
    this.everyNDays = const Value.absent(),
    required int fechaInicio,
    this.fechaFin = const Value.absent(),
    this.totalCiclos = const Value.absent(),
    this.ciclosRestantes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        templateId = Value(templateId),
        tipo = Value(tipo),
        fechaInicio = Value(fechaInicio);
  static Insertable<Recurrence> custom({
    Expression<String>? id,
    Expression<String>? templateId,
    Expression<String>? tipo,
    Expression<int>? diaMes,
    Expression<int>? dow,
    Expression<int>? everyNDays,
    Expression<int>? fechaInicio,
    Expression<int>? fechaFin,
    Expression<int>? totalCiclos,
    Expression<int>? ciclosRestantes,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (tipo != null) 'tipo': tipo,
      if (diaMes != null) 'dia_mes': diaMes,
      if (dow != null) 'dow': dow,
      if (everyNDays != null) 'every_n_days': everyNDays,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (fechaFin != null) 'fecha_fin': fechaFin,
      if (totalCiclos != null) 'total_ciclos': totalCiclos,
      if (ciclosRestantes != null) 'ciclos_restantes': ciclosRestantes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurrencesCompanion copyWith(
      {Value<String>? id,
      Value<String>? templateId,
      Value<String>? tipo,
      Value<int?>? diaMes,
      Value<int?>? dow,
      Value<int?>? everyNDays,
      Value<int>? fechaInicio,
      Value<int?>? fechaFin,
      Value<int?>? totalCiclos,
      Value<int?>? ciclosRestantes,
      Value<int?>? createdAt,
      Value<int?>? updatedAt,
      Value<int>? rowid}) {
    return RecurrencesCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      tipo: tipo ?? this.tipo,
      diaMes: diaMes ?? this.diaMes,
      dow: dow ?? this.dow,
      everyNDays: everyNDays ?? this.everyNDays,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      totalCiclos: totalCiclos ?? this.totalCiclos,
      ciclosRestantes: ciclosRestantes ?? this.ciclosRestantes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (diaMes.present) {
      map['dia_mes'] = Variable<int>(diaMes.value);
    }
    if (dow.present) {
      map['dow'] = Variable<int>(dow.value);
    }
    if (everyNDays.present) {
      map['every_n_days'] = Variable<int>(everyNDays.value);
    }
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<int>(fechaInicio.value);
    }
    if (fechaFin.present) {
      map['fecha_fin'] = Variable<int>(fechaFin.value);
    }
    if (totalCiclos.present) {
      map['total_ciclos'] = Variable<int>(totalCiclos.value);
    }
    if (ciclosRestantes.present) {
      map['ciclos_restantes'] = Variable<int>(ciclosRestantes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurrencesCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('tipo: $tipo, ')
          ..write('diaMes: $diaMes, ')
          ..write('dow: $dow, ')
          ..write('everyNDays: $everyNDays, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('totalCiclos: $totalCiclos, ')
          ..write('ciclosRestantes: $ciclosRestantes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OccurrencesTable extends Occurrences
    with TableInfo<$OccurrencesTable, Occurrence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OccurrencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _templateIdMeta =
      const VerificationMeta('templateId');
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
      'template_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES debt_templates (id) ON DELETE CASCADE'));
  static const VerificationMeta _fechaDueMeta =
      const VerificationMeta('fechaDue');
  @override
  late final GeneratedColumn<int> fechaDue = GeneratedColumn<int>(
      'fecha_due', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _montoMeta = const VerificationMeta('monto');
  @override
  late final GeneratedColumn<double> monto = GeneratedColumn<double>(
      'monto', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PENDING'));
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
      'card_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cards (id) ON DELETE SET NULL'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, templateId, fechaDue, monto, estado, cardId, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'occurrences';
  @override
  VerificationContext validateIntegrity(Insertable<Occurrence> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
          _templateIdMeta,
          templateId.isAcceptableOrUnknown(
              data['template_id']!, _templateIdMeta));
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('fecha_due')) {
      context.handle(_fechaDueMeta,
          fechaDue.isAcceptableOrUnknown(data['fecha_due']!, _fechaDueMeta));
    } else if (isInserting) {
      context.missing(_fechaDueMeta);
    }
    if (data.containsKey('monto')) {
      context.handle(
          _montoMeta, monto.isAcceptableOrUnknown(data['monto']!, _montoMeta));
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(_cardIdMeta,
          cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Occurrence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Occurrence(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      templateId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}template_id'])!,
      fechaDue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha_due'])!,
      monto: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monto'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado'])!,
      cardId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $OccurrencesTable createAlias(String alias) {
    return $OccurrencesTable(attachedDatabase, alias);
  }
}

class Occurrence extends DataClass implements Insertable<Occurrence> {
  final String id;
  final String templateId;
  final int fechaDue;
  final double monto;
  final String estado;
  final String? cardId;
  final int? createdAt;
  final int? updatedAt;
  const Occurrence(
      {required this.id,
      required this.templateId,
      required this.fechaDue,
      required this.monto,
      required this.estado,
      this.cardId,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['template_id'] = Variable<String>(templateId);
    map['fecha_due'] = Variable<int>(fechaDue);
    map['monto'] = Variable<double>(monto);
    map['estado'] = Variable<String>(estado);
    if (!nullToAbsent || cardId != null) {
      map['card_id'] = Variable<String>(cardId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  OccurrencesCompanion toCompanion(bool nullToAbsent) {
    return OccurrencesCompanion(
      id: Value(id),
      templateId: Value(templateId),
      fechaDue: Value(fechaDue),
      monto: Value(monto),
      estado: Value(estado),
      cardId:
          cardId == null && nullToAbsent ? const Value.absent() : Value(cardId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Occurrence.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Occurrence(
      id: serializer.fromJson<String>(json['id']),
      templateId: serializer.fromJson<String>(json['templateId']),
      fechaDue: serializer.fromJson<int>(json['fechaDue']),
      monto: serializer.fromJson<double>(json['monto']),
      estado: serializer.fromJson<String>(json['estado']),
      cardId: serializer.fromJson<String?>(json['cardId']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'templateId': serializer.toJson<String>(templateId),
      'fechaDue': serializer.toJson<int>(fechaDue),
      'monto': serializer.toJson<double>(monto),
      'estado': serializer.toJson<String>(estado),
      'cardId': serializer.toJson<String?>(cardId),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  Occurrence copyWith(
          {String? id,
          String? templateId,
          int? fechaDue,
          double? monto,
          String? estado,
          Value<String?> cardId = const Value.absent(),
          Value<int?> createdAt = const Value.absent(),
          Value<int?> updatedAt = const Value.absent()}) =>
      Occurrence(
        id: id ?? this.id,
        templateId: templateId ?? this.templateId,
        fechaDue: fechaDue ?? this.fechaDue,
        monto: monto ?? this.monto,
        estado: estado ?? this.estado,
        cardId: cardId.present ? cardId.value : this.cardId,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Occurrence copyWithCompanion(OccurrencesCompanion data) {
    return Occurrence(
      id: data.id.present ? data.id.value : this.id,
      templateId:
          data.templateId.present ? data.templateId.value : this.templateId,
      fechaDue: data.fechaDue.present ? data.fechaDue.value : this.fechaDue,
      monto: data.monto.present ? data.monto.value : this.monto,
      estado: data.estado.present ? data.estado.value : this.estado,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Occurrence(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('fechaDue: $fechaDue, ')
          ..write('monto: $monto, ')
          ..write('estado: $estado, ')
          ..write('cardId: $cardId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, templateId, fechaDue, monto, estado, cardId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Occurrence &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.fechaDue == this.fechaDue &&
          other.monto == this.monto &&
          other.estado == this.estado &&
          other.cardId == this.cardId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OccurrencesCompanion extends UpdateCompanion<Occurrence> {
  final Value<String> id;
  final Value<String> templateId;
  final Value<int> fechaDue;
  final Value<double> monto;
  final Value<String> estado;
  final Value<String?> cardId;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  final Value<int> rowid;
  const OccurrencesCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.fechaDue = const Value.absent(),
    this.monto = const Value.absent(),
    this.estado = const Value.absent(),
    this.cardId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OccurrencesCompanion.insert({
    required String id,
    required String templateId,
    required int fechaDue,
    required double monto,
    this.estado = const Value.absent(),
    this.cardId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        templateId = Value(templateId),
        fechaDue = Value(fechaDue),
        monto = Value(monto);
  static Insertable<Occurrence> custom({
    Expression<String>? id,
    Expression<String>? templateId,
    Expression<int>? fechaDue,
    Expression<double>? monto,
    Expression<String>? estado,
    Expression<String>? cardId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (fechaDue != null) 'fecha_due': fechaDue,
      if (monto != null) 'monto': monto,
      if (estado != null) 'estado': estado,
      if (cardId != null) 'card_id': cardId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OccurrencesCompanion copyWith(
      {Value<String>? id,
      Value<String>? templateId,
      Value<int>? fechaDue,
      Value<double>? monto,
      Value<String>? estado,
      Value<String?>? cardId,
      Value<int?>? createdAt,
      Value<int?>? updatedAt,
      Value<int>? rowid}) {
    return OccurrencesCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      fechaDue: fechaDue ?? this.fechaDue,
      monto: monto ?? this.monto,
      estado: estado ?? this.estado,
      cardId: cardId ?? this.cardId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (fechaDue.present) {
      map['fecha_due'] = Variable<int>(fechaDue.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OccurrencesCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('fechaDue: $fechaDue, ')
          ..write('monto: $monto, ')
          ..write('estado: $estado, ')
          ..write('cardId: $cardId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderRulesTable extends ReminderRules
    with TableInfo<$ReminderRulesTable, ReminderRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _templateIdMeta =
      const VerificationMeta('templateId');
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
      'template_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES debt_templates (id) ON DELETE CASCADE'));
  static const VerificationMeta _offsetDaysMeta =
      const VerificationMeta('offsetDays');
  @override
  late final GeneratedColumn<int> offsetDays = GeneratedColumn<int>(
      'offset_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, templateId, offsetDays];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_rules';
  @override
  VerificationContext validateIntegrity(Insertable<ReminderRule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
          _templateIdMeta,
          templateId.isAcceptableOrUnknown(
              data['template_id']!, _templateIdMeta));
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('offset_days')) {
      context.handle(
          _offsetDaysMeta,
          offsetDays.isAcceptableOrUnknown(
              data['offset_days']!, _offsetDaysMeta));
    } else if (isInserting) {
      context.missing(_offsetDaysMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderRule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      templateId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}template_id'])!,
      offsetDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}offset_days'])!,
    );
  }

  @override
  $ReminderRulesTable createAlias(String alias) {
    return $ReminderRulesTable(attachedDatabase, alias);
  }
}

class ReminderRule extends DataClass implements Insertable<ReminderRule> {
  final String id;
  final String templateId;
  final int offsetDays;
  const ReminderRule(
      {required this.id, required this.templateId, required this.offsetDays});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['template_id'] = Variable<String>(templateId);
    map['offset_days'] = Variable<int>(offsetDays);
    return map;
  }

  ReminderRulesCompanion toCompanion(bool nullToAbsent) {
    return ReminderRulesCompanion(
      id: Value(id),
      templateId: Value(templateId),
      offsetDays: Value(offsetDays),
    );
  }

  factory ReminderRule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderRule(
      id: serializer.fromJson<String>(json['id']),
      templateId: serializer.fromJson<String>(json['templateId']),
      offsetDays: serializer.fromJson<int>(json['offsetDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'templateId': serializer.toJson<String>(templateId),
      'offsetDays': serializer.toJson<int>(offsetDays),
    };
  }

  ReminderRule copyWith({String? id, String? templateId, int? offsetDays}) =>
      ReminderRule(
        id: id ?? this.id,
        templateId: templateId ?? this.templateId,
        offsetDays: offsetDays ?? this.offsetDays,
      );
  ReminderRule copyWithCompanion(ReminderRulesCompanion data) {
    return ReminderRule(
      id: data.id.present ? data.id.value : this.id,
      templateId:
          data.templateId.present ? data.templateId.value : this.templateId,
      offsetDays:
          data.offsetDays.present ? data.offsetDays.value : this.offsetDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRule(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('offsetDays: $offsetDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, templateId, offsetDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderRule &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.offsetDays == this.offsetDays);
}

class ReminderRulesCompanion extends UpdateCompanion<ReminderRule> {
  final Value<String> id;
  final Value<String> templateId;
  final Value<int> offsetDays;
  final Value<int> rowid;
  const ReminderRulesCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.offsetDays = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderRulesCompanion.insert({
    required String id,
    required String templateId,
    required int offsetDays,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        templateId = Value(templateId),
        offsetDays = Value(offsetDays);
  static Insertable<ReminderRule> custom({
    Expression<String>? id,
    Expression<String>? templateId,
    Expression<int>? offsetDays,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (offsetDays != null) 'offset_days': offsetDays,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderRulesCompanion copyWith(
      {Value<String>? id,
      Value<String>? templateId,
      Value<int>? offsetDays,
      Value<int>? rowid}) {
    return ReminderRulesCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      offsetDays: offsetDays ?? this.offsetDays,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (offsetDays.present) {
      map['offset_days'] = Variable<int>(offsetDays.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderRulesCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('offsetDays: $offsetDays, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _occurrenceIdMeta =
      const VerificationMeta('occurrenceId');
  @override
  late final GeneratedColumn<String> occurrenceId = GeneratedColumn<String>(
      'occurrence_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'UNIQUE REFERENCES occurrences (id) ON DELETE CASCADE'));
  static const VerificationMeta _fechaPagoMeta =
      const VerificationMeta('fechaPago');
  @override
  late final GeneratedColumn<int> fechaPago = GeneratedColumn<int>(
      'fecha_pago', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _montoPagadoMeta =
      const VerificationMeta('montoPagado');
  @override
  late final GeneratedColumn<double> montoPagado = GeneratedColumn<double>(
      'monto_pagado', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _metodoPagoMeta =
      const VerificationMeta('metodoPago');
  @override
  late final GeneratedColumn<String> metodoPago = GeneratedColumn<String>(
      'metodo_pago', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paymentMethodIdMeta =
      const VerificationMeta('paymentMethodId');
  @override
  late final GeneratedColumn<String> paymentMethodId = GeneratedColumn<String>(
      'payment_method_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES payment_methods (id) ON DELETE SET NULL'));
  static const VerificationMeta _interestPortionMeta =
      const VerificationMeta('interestPortion');
  @override
  late final GeneratedColumn<double> interestPortion = GeneratedColumn<double>(
      'interest_portion', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _principalPortionMeta =
      const VerificationMeta('principalPortion');
  @override
  late final GeneratedColumn<double> principalPortion = GeneratedColumn<double>(
      'principal_portion', aliasedName, true,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
      'notas', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        occurrenceId,
        fechaPago,
        montoPagado,
        metodoPago,
        paymentMethodId,
        interestPortion,
        principalPortion,
        notas,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(Insertable<Payment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('occurrence_id')) {
      context.handle(
          _occurrenceIdMeta,
          occurrenceId.isAcceptableOrUnknown(
              data['occurrence_id']!, _occurrenceIdMeta));
    } else if (isInserting) {
      context.missing(_occurrenceIdMeta);
    }
    if (data.containsKey('fecha_pago')) {
      context.handle(_fechaPagoMeta,
          fechaPago.isAcceptableOrUnknown(data['fecha_pago']!, _fechaPagoMeta));
    } else if (isInserting) {
      context.missing(_fechaPagoMeta);
    }
    if (data.containsKey('monto_pagado')) {
      context.handle(
          _montoPagadoMeta,
          montoPagado.isAcceptableOrUnknown(
              data['monto_pagado']!, _montoPagadoMeta));
    } else if (isInserting) {
      context.missing(_montoPagadoMeta);
    }
    if (data.containsKey('metodo_pago')) {
      context.handle(
          _metodoPagoMeta,
          metodoPago.isAcceptableOrUnknown(
              data['metodo_pago']!, _metodoPagoMeta));
    }
    if (data.containsKey('payment_method_id')) {
      context.handle(
          _paymentMethodIdMeta,
          paymentMethodId.isAcceptableOrUnknown(
              data['payment_method_id']!, _paymentMethodIdMeta));
    }
    if (data.containsKey('interest_portion')) {
      context.handle(
          _interestPortionMeta,
          interestPortion.isAcceptableOrUnknown(
              data['interest_portion']!, _interestPortionMeta));
    }
    if (data.containsKey('principal_portion')) {
      context.handle(
          _principalPortionMeta,
          principalPortion.isAcceptableOrUnknown(
              data['principal_portion']!, _principalPortionMeta));
    }
    if (data.containsKey('notas')) {
      context.handle(
          _notasMeta, notas.isAcceptableOrUnknown(data['notas']!, _notasMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      occurrenceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}occurrence_id'])!,
      fechaPago: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fecha_pago'])!,
      montoPagado: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monto_pagado'])!,
      metodoPago: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metodo_pago']),
      paymentMethodId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}payment_method_id']),
      interestPortion: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}interest_portion']),
      principalPortion: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}principal_portion']),
      notas: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notas']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final String id;
  final String occurrenceId;
  final int fechaPago;
  final double montoPagado;
  final String? metodoPago;
  final String? paymentMethodId;
  final double? interestPortion;
  final double? principalPortion;
  final String? notas;
  final int? createdAt;
  final int? updatedAt;
  const Payment(
      {required this.id,
      required this.occurrenceId,
      required this.fechaPago,
      required this.montoPagado,
      this.metodoPago,
      this.paymentMethodId,
      this.interestPortion,
      this.principalPortion,
      this.notas,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['occurrence_id'] = Variable<String>(occurrenceId);
    map['fecha_pago'] = Variable<int>(fechaPago);
    map['monto_pagado'] = Variable<double>(montoPagado);
    if (!nullToAbsent || metodoPago != null) {
      map['metodo_pago'] = Variable<String>(metodoPago);
    }
    if (!nullToAbsent || paymentMethodId != null) {
      map['payment_method_id'] = Variable<String>(paymentMethodId);
    }
    if (!nullToAbsent || interestPortion != null) {
      map['interest_portion'] = Variable<double>(interestPortion);
    }
    if (!nullToAbsent || principalPortion != null) {
      map['principal_portion'] = Variable<double>(principalPortion);
    }
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      occurrenceId: Value(occurrenceId),
      fechaPago: Value(fechaPago),
      montoPagado: Value(montoPagado),
      metodoPago: metodoPago == null && nullToAbsent
          ? const Value.absent()
          : Value(metodoPago),
      paymentMethodId: paymentMethodId == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethodId),
      interestPortion: interestPortion == null && nullToAbsent
          ? const Value.absent()
          : Value(interestPortion),
      principalPortion: principalPortion == null && nullToAbsent
          ? const Value.absent()
          : Value(principalPortion),
      notas:
          notas == null && nullToAbsent ? const Value.absent() : Value(notas),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Payment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<String>(json['id']),
      occurrenceId: serializer.fromJson<String>(json['occurrenceId']),
      fechaPago: serializer.fromJson<int>(json['fechaPago']),
      montoPagado: serializer.fromJson<double>(json['montoPagado']),
      metodoPago: serializer.fromJson<String?>(json['metodoPago']),
      paymentMethodId: serializer.fromJson<String?>(json['paymentMethodId']),
      interestPortion: serializer.fromJson<double?>(json['interestPortion']),
      principalPortion: serializer.fromJson<double?>(json['principalPortion']),
      notas: serializer.fromJson<String?>(json['notas']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'occurrenceId': serializer.toJson<String>(occurrenceId),
      'fechaPago': serializer.toJson<int>(fechaPago),
      'montoPagado': serializer.toJson<double>(montoPagado),
      'metodoPago': serializer.toJson<String?>(metodoPago),
      'paymentMethodId': serializer.toJson<String?>(paymentMethodId),
      'interestPortion': serializer.toJson<double?>(interestPortion),
      'principalPortion': serializer.toJson<double?>(principalPortion),
      'notas': serializer.toJson<String?>(notas),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  Payment copyWith(
          {String? id,
          String? occurrenceId,
          int? fechaPago,
          double? montoPagado,
          Value<String?> metodoPago = const Value.absent(),
          Value<String?> paymentMethodId = const Value.absent(),
          Value<double?> interestPortion = const Value.absent(),
          Value<double?> principalPortion = const Value.absent(),
          Value<String?> notas = const Value.absent(),
          Value<int?> createdAt = const Value.absent(),
          Value<int?> updatedAt = const Value.absent()}) =>
      Payment(
        id: id ?? this.id,
        occurrenceId: occurrenceId ?? this.occurrenceId,
        fechaPago: fechaPago ?? this.fechaPago,
        montoPagado: montoPagado ?? this.montoPagado,
        metodoPago: metodoPago.present ? metodoPago.value : this.metodoPago,
        paymentMethodId: paymentMethodId.present
            ? paymentMethodId.value
            : this.paymentMethodId,
        interestPortion: interestPortion.present
            ? interestPortion.value
            : this.interestPortion,
        principalPortion: principalPortion.present
            ? principalPortion.value
            : this.principalPortion,
        notas: notas.present ? notas.value : this.notas,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      occurrenceId: data.occurrenceId.present
          ? data.occurrenceId.value
          : this.occurrenceId,
      fechaPago: data.fechaPago.present ? data.fechaPago.value : this.fechaPago,
      montoPagado:
          data.montoPagado.present ? data.montoPagado.value : this.montoPagado,
      metodoPago:
          data.metodoPago.present ? data.metodoPago.value : this.metodoPago,
      paymentMethodId: data.paymentMethodId.present
          ? data.paymentMethodId.value
          : this.paymentMethodId,
      interestPortion: data.interestPortion.present
          ? data.interestPortion.value
          : this.interestPortion,
      principalPortion: data.principalPortion.present
          ? data.principalPortion.value
          : this.principalPortion,
      notas: data.notas.present ? data.notas.value : this.notas,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('occurrenceId: $occurrenceId, ')
          ..write('fechaPago: $fechaPago, ')
          ..write('montoPagado: $montoPagado, ')
          ..write('metodoPago: $metodoPago, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('interestPortion: $interestPortion, ')
          ..write('principalPortion: $principalPortion, ')
          ..write('notas: $notas, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      occurrenceId,
      fechaPago,
      montoPagado,
      metodoPago,
      paymentMethodId,
      interestPortion,
      principalPortion,
      notas,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.occurrenceId == this.occurrenceId &&
          other.fechaPago == this.fechaPago &&
          other.montoPagado == this.montoPagado &&
          other.metodoPago == this.metodoPago &&
          other.paymentMethodId == this.paymentMethodId &&
          other.interestPortion == this.interestPortion &&
          other.principalPortion == this.principalPortion &&
          other.notas == this.notas &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<String> id;
  final Value<String> occurrenceId;
  final Value<int> fechaPago;
  final Value<double> montoPagado;
  final Value<String?> metodoPago;
  final Value<String?> paymentMethodId;
  final Value<double?> interestPortion;
  final Value<double?> principalPortion;
  final Value<String?> notas;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.occurrenceId = const Value.absent(),
    this.fechaPago = const Value.absent(),
    this.montoPagado = const Value.absent(),
    this.metodoPago = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.interestPortion = const Value.absent(),
    this.principalPortion = const Value.absent(),
    this.notas = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    required String id,
    required String occurrenceId,
    required int fechaPago,
    required double montoPagado,
    this.metodoPago = const Value.absent(),
    this.paymentMethodId = const Value.absent(),
    this.interestPortion = const Value.absent(),
    this.principalPortion = const Value.absent(),
    this.notas = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        occurrenceId = Value(occurrenceId),
        fechaPago = Value(fechaPago),
        montoPagado = Value(montoPagado);
  static Insertable<Payment> custom({
    Expression<String>? id,
    Expression<String>? occurrenceId,
    Expression<int>? fechaPago,
    Expression<double>? montoPagado,
    Expression<String>? metodoPago,
    Expression<String>? paymentMethodId,
    Expression<double>? interestPortion,
    Expression<double>? principalPortion,
    Expression<String>? notas,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (occurrenceId != null) 'occurrence_id': occurrenceId,
      if (fechaPago != null) 'fecha_pago': fechaPago,
      if (montoPagado != null) 'monto_pagado': montoPagado,
      if (metodoPago != null) 'metodo_pago': metodoPago,
      if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      if (interestPortion != null) 'interest_portion': interestPortion,
      if (principalPortion != null) 'principal_portion': principalPortion,
      if (notas != null) 'notas': notas,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? occurrenceId,
      Value<int>? fechaPago,
      Value<double>? montoPagado,
      Value<String?>? metodoPago,
      Value<String?>? paymentMethodId,
      Value<double?>? interestPortion,
      Value<double?>? principalPortion,
      Value<String?>? notas,
      Value<int?>? createdAt,
      Value<int?>? updatedAt,
      Value<int>? rowid}) {
    return PaymentsCompanion(
      id: id ?? this.id,
      occurrenceId: occurrenceId ?? this.occurrenceId,
      fechaPago: fechaPago ?? this.fechaPago,
      montoPagado: montoPagado ?? this.montoPagado,
      metodoPago: metodoPago ?? this.metodoPago,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      interestPortion: interestPortion ?? this.interestPortion,
      principalPortion: principalPortion ?? this.principalPortion,
      notas: notas ?? this.notas,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (occurrenceId.present) {
      map['occurrence_id'] = Variable<String>(occurrenceId.value);
    }
    if (fechaPago.present) {
      map['fecha_pago'] = Variable<int>(fechaPago.value);
    }
    if (montoPagado.present) {
      map['monto_pagado'] = Variable<double>(montoPagado.value);
    }
    if (metodoPago.present) {
      map['metodo_pago'] = Variable<String>(metodoPago.value);
    }
    if (paymentMethodId.present) {
      map['payment_method_id'] = Variable<String>(paymentMethodId.value);
    }
    if (interestPortion.present) {
      map['interest_portion'] = Variable<double>(interestPortion.value);
    }
    if (principalPortion.present) {
      map['principal_portion'] = Variable<double>(principalPortion.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('occurrenceId: $occurrenceId, ')
          ..write('fechaPago: $fechaPago, ')
          ..write('montoPagado: $montoPagado, ')
          ..write('metodoPago: $metodoPago, ')
          ..write('paymentMethodId: $paymentMethodId, ')
          ..write('interestPortion: $interestPortion, ')
          ..write('principalPortion: $principalPortion, ')
          ..write('notas: $notas, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String name;
  final int createdAt;
  const Category(
      {required this.id, required this.name, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  Category copyWith({String? id, String? name, int? createdAt}) => Category(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> createdAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PaymentMethodsTable paymentMethods = $PaymentMethodsTable(this);
  late final $CardsTable cards = $CardsTable(this);
  late final $DebtTemplatesTable debtTemplates = $DebtTemplatesTable(this);
  late final $RecurrencesTable recurrences = $RecurrencesTable(this);
  late final $OccurrencesTable occurrences = $OccurrencesTable(this);
  late final $ReminderRulesTable reminderRules = $ReminderRulesTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        paymentMethods,
        cards,
        debtTemplates,
        recurrences,
        occurrences,
        reminderRules,
        payments,
        categories
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('cards',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('debt_templates', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('payment_methods',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('debt_templates', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('debt_templates',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('recurrences', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('debt_templates',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('occurrences', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('cards',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('occurrences', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('debt_templates',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('reminder_rules', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('occurrences',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('payments', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('payment_methods',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('payments', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}

typedef $$PaymentMethodsTableCreateCompanionBuilder = PaymentMethodsCompanion
    Function({
  required String id,
  required String type,
  required String alias,
  Value<String?> last4,
  Value<String?> issuer,
  Value<bool> isDefault,
  required int createdAt,
  Value<int> rowid,
});
typedef $$PaymentMethodsTableUpdateCompanionBuilder = PaymentMethodsCompanion
    Function({
  Value<String> id,
  Value<String> type,
  Value<String> alias,
  Value<String?> last4,
  Value<String?> issuer,
  Value<bool> isDefault,
  Value<int> createdAt,
  Value<int> rowid,
});

final class $$PaymentMethodsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentMethodsTable, PaymentMethod> {
  $$PaymentMethodsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DebtTemplatesTable, List<DebtTemplate>>
      _debtTemplatesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.debtTemplates,
              aliasName: $_aliasNameGenerator(
                  db.paymentMethods.id, db.debtTemplates.paymentMethodId));

  $$DebtTemplatesTableProcessedTableManager get debtTemplatesRefs {
    final manager = $$DebtTemplatesTableTableManager($_db, $_db.debtTemplates)
        .filter((f) => f.paymentMethodId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_debtTemplatesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.payments,
          aliasName: $_aliasNameGenerator(
              db.paymentMethods.id, db.payments.paymentMethodId));

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager($_db, $_db.payments)
        .filter((f) => f.paymentMethodId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PaymentMethodsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get last4 => $composableBuilder(
      column: $table.last4, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get issuer => $composableBuilder(
      column: $table.issuer, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> debtTemplatesRefs(
      Expression<bool> Function($$DebtTemplatesTableFilterComposer f) f) {
    final $$DebtTemplatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.debtTemplates,
        getReferencedColumn: (t) => t.paymentMethodId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtTemplatesTableFilterComposer(
              $db: $db,
              $table: $db.debtTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> paymentsRefs(
      Expression<bool> Function($$PaymentsTableFilterComposer f) f) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.paymentMethodId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableFilterComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PaymentMethodsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get last4 => $composableBuilder(
      column: $table.last4, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get issuer => $composableBuilder(
      column: $table.issuer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PaymentMethodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentMethodsTable> {
  $$PaymentMethodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<String> get last4 =>
      $composableBuilder(column: $table.last4, builder: (column) => column);

  GeneratedColumn<String> get issuer =>
      $composableBuilder(column: $table.issuer, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> debtTemplatesRefs<T extends Object>(
      Expression<T> Function($$DebtTemplatesTableAnnotationComposer a) f) {
    final $$DebtTemplatesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.debtTemplates,
        getReferencedColumn: (t) => t.paymentMethodId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtTemplatesTableAnnotationComposer(
              $db: $db,
              $table: $db.debtTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
      Expression<T> Function($$PaymentsTableAnnotationComposer a) f) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.paymentMethodId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PaymentMethodsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentMethodsTable,
    PaymentMethod,
    $$PaymentMethodsTableFilterComposer,
    $$PaymentMethodsTableOrderingComposer,
    $$PaymentMethodsTableAnnotationComposer,
    $$PaymentMethodsTableCreateCompanionBuilder,
    $$PaymentMethodsTableUpdateCompanionBuilder,
    (PaymentMethod, $$PaymentMethodsTableReferences),
    PaymentMethod,
    PrefetchHooks Function({bool debtTemplatesRefs, bool paymentsRefs})> {
  $$PaymentMethodsTableTableManager(
      _$AppDatabase db, $PaymentMethodsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentMethodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentMethodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentMethodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> alias = const Value.absent(),
            Value<String?> last4 = const Value.absent(),
            Value<String?> issuer = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentMethodsCompanion(
            id: id,
            type: type,
            alias: alias,
            last4: last4,
            issuer: issuer,
            isDefault: isDefault,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String type,
            required String alias,
            Value<String?> last4 = const Value.absent(),
            Value<String?> issuer = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentMethodsCompanion.insert(
            id: id,
            type: type,
            alias: alias,
            last4: last4,
            issuer: issuer,
            isDefault: isDefault,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PaymentMethodsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {debtTemplatesRefs = false, paymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (debtTemplatesRefs) db.debtTemplates,
                if (paymentsRefs) db.payments
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (debtTemplatesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PaymentMethodsTableReferences
                            ._debtTemplatesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PaymentMethodsTableReferences(db, table, p0)
                                .debtTemplatesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.paymentMethodId == item.id),
                        typedResults: items),
                  if (paymentsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PaymentMethodsTableReferences
                            ._paymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PaymentMethodsTableReferences(db, table, p0)
                                .paymentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.paymentMethodId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PaymentMethodsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentMethodsTable,
    PaymentMethod,
    $$PaymentMethodsTableFilterComposer,
    $$PaymentMethodsTableOrderingComposer,
    $$PaymentMethodsTableAnnotationComposer,
    $$PaymentMethodsTableCreateCompanionBuilder,
    $$PaymentMethodsTableUpdateCompanionBuilder,
    (PaymentMethod, $$PaymentMethodsTableReferences),
    PaymentMethod,
    PrefetchHooks Function({bool debtTemplatesRefs, bool paymentsRefs})>;
typedef $$CardsTableCreateCompanionBuilder = CardsCompanion Function({
  required String id,
  required String nombre,
  Value<String?> ultimas4,
  Value<String?> color,
  Value<int> rowid,
});
typedef $$CardsTableUpdateCompanionBuilder = CardsCompanion Function({
  Value<String> id,
  Value<String> nombre,
  Value<String?> ultimas4,
  Value<String?> color,
  Value<int> rowid,
});

final class $$CardsTableReferences
    extends BaseReferences<_$AppDatabase, $CardsTable, Card> {
  $$CardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DebtTemplatesTable, List<DebtTemplate>>
      _debtTemplatesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.debtTemplates,
              aliasName:
                  $_aliasNameGenerator(db.cards.id, db.debtTemplates.cardId));

  $$DebtTemplatesTableProcessedTableManager get debtTemplatesRefs {
    final manager = $$DebtTemplatesTableTableManager($_db, $_db.debtTemplates)
        .filter((f) => f.cardId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_debtTemplatesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OccurrencesTable, List<Occurrence>>
      _occurrencesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.occurrences,
          aliasName: $_aliasNameGenerator(db.cards.id, db.occurrences.cardId));

  $$OccurrencesTableProcessedTableManager get occurrencesRefs {
    final manager = $$OccurrencesTableTableManager($_db, $_db.occurrences)
        .filter((f) => f.cardId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_occurrencesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CardsTableFilterComposer extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ultimas4 => $composableBuilder(
      column: $table.ultimas4, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  Expression<bool> debtTemplatesRefs(
      Expression<bool> Function($$DebtTemplatesTableFilterComposer f) f) {
    final $$DebtTemplatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.debtTemplates,
        getReferencedColumn: (t) => t.cardId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtTemplatesTableFilterComposer(
              $db: $db,
              $table: $db.debtTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> occurrencesRefs(
      Expression<bool> Function($$OccurrencesTableFilterComposer f) f) {
    final $$OccurrencesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.occurrences,
        getReferencedColumn: (t) => t.cardId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OccurrencesTableFilterComposer(
              $db: $db,
              $table: $db.occurrences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CardsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ultimas4 => $composableBuilder(
      column: $table.ultimas4, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));
}

class $$CardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get ultimas4 =>
      $composableBuilder(column: $table.ultimas4, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  Expression<T> debtTemplatesRefs<T extends Object>(
      Expression<T> Function($$DebtTemplatesTableAnnotationComposer a) f) {
    final $$DebtTemplatesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.debtTemplates,
        getReferencedColumn: (t) => t.cardId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtTemplatesTableAnnotationComposer(
              $db: $db,
              $table: $db.debtTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> occurrencesRefs<T extends Object>(
      Expression<T> Function($$OccurrencesTableAnnotationComposer a) f) {
    final $$OccurrencesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.occurrences,
        getReferencedColumn: (t) => t.cardId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OccurrencesTableAnnotationComposer(
              $db: $db,
              $table: $db.occurrences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CardsTable,
    Card,
    $$CardsTableFilterComposer,
    $$CardsTableOrderingComposer,
    $$CardsTableAnnotationComposer,
    $$CardsTableCreateCompanionBuilder,
    $$CardsTableUpdateCompanionBuilder,
    (Card, $$CardsTableReferences),
    Card,
    PrefetchHooks Function({bool debtTemplatesRefs, bool occurrencesRefs})> {
  $$CardsTableTableManager(_$AppDatabase db, $CardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String?> ultimas4 = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CardsCompanion(
            id: id,
            nombre: nombre,
            ultimas4: ultimas4,
            color: color,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nombre,
            Value<String?> ultimas4 = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CardsCompanion.insert(
            id: id,
            nombre: nombre,
            ultimas4: ultimas4,
            color: color,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$CardsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {debtTemplatesRefs = false, occurrencesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (debtTemplatesRefs) db.debtTemplates,
                if (occurrencesRefs) db.occurrences
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (debtTemplatesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$CardsTableReferences._debtTemplatesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CardsTableReferences(db, table, p0)
                                .debtTemplatesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.cardId == item.id),
                        typedResults: items),
                  if (occurrencesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$CardsTableReferences._occurrencesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CardsTableReferences(db, table, p0)
                                .occurrencesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.cardId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CardsTable,
    Card,
    $$CardsTableFilterComposer,
    $$CardsTableOrderingComposer,
    $$CardsTableAnnotationComposer,
    $$CardsTableCreateCompanionBuilder,
    $$CardsTableUpdateCompanionBuilder,
    (Card, $$CardsTableReferences),
    Card,
    PrefetchHooks Function({bool debtTemplatesRefs, bool occurrencesRefs})>;
typedef $$DebtTemplatesTableCreateCompanionBuilder = DebtTemplatesCompanion
    Function({
  required String id,
  required String nombre,
  Value<String?> categoria,
  required double monto,
  Value<double?> currentBalance,
  Value<String?> cardId,
  Value<String?> paymentMethodId,
  Value<bool> hasInterest,
  Value<String?> interestType,
  Value<double?> interestRateMonthly,
  Value<int?> termMonths,
  Value<int?> graceMonths,
  Value<String?> categoryId,
  Value<String?> notas,
  Value<bool> isArchived,
  Value<int?> createdAt,
  Value<int?> updatedAt,
  Value<int> rowid,
});
typedef $$DebtTemplatesTableUpdateCompanionBuilder = DebtTemplatesCompanion
    Function({
  Value<String> id,
  Value<String> nombre,
  Value<String?> categoria,
  Value<double> monto,
  Value<double?> currentBalance,
  Value<String?> cardId,
  Value<String?> paymentMethodId,
  Value<bool> hasInterest,
  Value<String?> interestType,
  Value<double?> interestRateMonthly,
  Value<int?> termMonths,
  Value<int?> graceMonths,
  Value<String?> categoryId,
  Value<String?> notas,
  Value<bool> isArchived,
  Value<int?> createdAt,
  Value<int?> updatedAt,
  Value<int> rowid,
});

final class $$DebtTemplatesTableReferences
    extends BaseReferences<_$AppDatabase, $DebtTemplatesTable, DebtTemplate> {
  $$DebtTemplatesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CardsTable _cardIdTable(_$AppDatabase db) => db.cards
      .createAlias($_aliasNameGenerator(db.debtTemplates.cardId, db.cards.id));

  $$CardsTableProcessedTableManager? get cardId {
    if ($_item.cardId == null) return null;
    final manager = $$CardsTableTableManager($_db, $_db.cards)
        .filter((f) => f.id($_item.cardId!));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PaymentMethodsTable _paymentMethodIdTable(_$AppDatabase db) =>
      db.paymentMethods.createAlias($_aliasNameGenerator(
          db.debtTemplates.paymentMethodId, db.paymentMethods.id));

  $$PaymentMethodsTableProcessedTableManager? get paymentMethodId {
    if ($_item.paymentMethodId == null) return null;
    final manager = $$PaymentMethodsTableTableManager($_db, $_db.paymentMethods)
        .filter((f) => f.id($_item.paymentMethodId!));
    final item = $_typedResult.readTableOrNull(_paymentMethodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$RecurrencesTable, List<Recurrence>>
      _recurrencesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.recurrences,
              aliasName: $_aliasNameGenerator(
                  db.debtTemplates.id, db.recurrences.templateId));

  $$RecurrencesTableProcessedTableManager get recurrencesRefs {
    final manager = $$RecurrencesTableTableManager($_db, $_db.recurrences)
        .filter((f) => f.templateId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_recurrencesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OccurrencesTable, List<Occurrence>>
      _occurrencesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.occurrences,
              aliasName: $_aliasNameGenerator(
                  db.debtTemplates.id, db.occurrences.templateId));

  $$OccurrencesTableProcessedTableManager get occurrencesRefs {
    final manager = $$OccurrencesTableTableManager($_db, $_db.occurrences)
        .filter((f) => f.templateId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_occurrencesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReminderRulesTable, List<ReminderRule>>
      _reminderRulesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.reminderRules,
              aliasName: $_aliasNameGenerator(
                  db.debtTemplates.id, db.reminderRules.templateId));

  $$ReminderRulesTableProcessedTableManager get reminderRulesRefs {
    final manager = $$ReminderRulesTableTableManager($_db, $_db.reminderRules)
        .filter((f) => f.templateId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_reminderRulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DebtTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $DebtTemplatesTable> {
  $$DebtTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoria => $composableBuilder(
      column: $table.categoria, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get monto => $composableBuilder(
      column: $table.monto, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentBalance => $composableBuilder(
      column: $table.currentBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasInterest => $composableBuilder(
      column: $table.hasInterest, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get interestType => $composableBuilder(
      column: $table.interestType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get interestRateMonthly => $composableBuilder(
      column: $table.interestRateMonthly,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get termMonths => $composableBuilder(
      column: $table.termMonths, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get graceMonths => $composableBuilder(
      column: $table.graceMonths, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notas => $composableBuilder(
      column: $table.notas, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$CardsTableFilterComposer get cardId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cardId,
        referencedTable: $db.cards,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CardsTableFilterComposer(
              $db: $db,
              $table: $db.cards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PaymentMethodsTableFilterComposer get paymentMethodId {
    final $$PaymentMethodsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paymentMethodId,
        referencedTable: $db.paymentMethods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentMethodsTableFilterComposer(
              $db: $db,
              $table: $db.paymentMethods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> recurrencesRefs(
      Expression<bool> Function($$RecurrencesTableFilterComposer f) f) {
    final $$RecurrencesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recurrences,
        getReferencedColumn: (t) => t.templateId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecurrencesTableFilterComposer(
              $db: $db,
              $table: $db.recurrences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> occurrencesRefs(
      Expression<bool> Function($$OccurrencesTableFilterComposer f) f) {
    final $$OccurrencesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.occurrences,
        getReferencedColumn: (t) => t.templateId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OccurrencesTableFilterComposer(
              $db: $db,
              $table: $db.occurrences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> reminderRulesRefs(
      Expression<bool> Function($$ReminderRulesTableFilterComposer f) f) {
    final $$ReminderRulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminderRules,
        getReferencedColumn: (t) => t.templateId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReminderRulesTableFilterComposer(
              $db: $db,
              $table: $db.reminderRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DebtTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtTemplatesTable> {
  $$DebtTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoria => $composableBuilder(
      column: $table.categoria, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get monto => $composableBuilder(
      column: $table.monto, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentBalance => $composableBuilder(
      column: $table.currentBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasInterest => $composableBuilder(
      column: $table.hasInterest, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get interestType => $composableBuilder(
      column: $table.interestType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get interestRateMonthly => $composableBuilder(
      column: $table.interestRateMonthly,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get termMonths => $composableBuilder(
      column: $table.termMonths, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get graceMonths => $composableBuilder(
      column: $table.graceMonths, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notas => $composableBuilder(
      column: $table.notas, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CardsTableOrderingComposer get cardId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cardId,
        referencedTable: $db.cards,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CardsTableOrderingComposer(
              $db: $db,
              $table: $db.cards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PaymentMethodsTableOrderingComposer get paymentMethodId {
    final $$PaymentMethodsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paymentMethodId,
        referencedTable: $db.paymentMethods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentMethodsTableOrderingComposer(
              $db: $db,
              $table: $db.paymentMethods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DebtTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtTemplatesTable> {
  $$DebtTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<double> get monto =>
      $composableBuilder(column: $table.monto, builder: (column) => column);

  GeneratedColumn<double> get currentBalance => $composableBuilder(
      column: $table.currentBalance, builder: (column) => column);

  GeneratedColumn<bool> get hasInterest => $composableBuilder(
      column: $table.hasInterest, builder: (column) => column);

  GeneratedColumn<String> get interestType => $composableBuilder(
      column: $table.interestType, builder: (column) => column);

  GeneratedColumn<double> get interestRateMonthly => $composableBuilder(
      column: $table.interestRateMonthly, builder: (column) => column);

  GeneratedColumn<int> get termMonths => $composableBuilder(
      column: $table.termMonths, builder: (column) => column);

  GeneratedColumn<int> get graceMonths => $composableBuilder(
      column: $table.graceMonths, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CardsTableAnnotationComposer get cardId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cardId,
        referencedTable: $db.cards,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CardsTableAnnotationComposer(
              $db: $db,
              $table: $db.cards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PaymentMethodsTableAnnotationComposer get paymentMethodId {
    final $$PaymentMethodsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paymentMethodId,
        referencedTable: $db.paymentMethods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentMethodsTableAnnotationComposer(
              $db: $db,
              $table: $db.paymentMethods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> recurrencesRefs<T extends Object>(
      Expression<T> Function($$RecurrencesTableAnnotationComposer a) f) {
    final $$RecurrencesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recurrences,
        getReferencedColumn: (t) => t.templateId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecurrencesTableAnnotationComposer(
              $db: $db,
              $table: $db.recurrences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> occurrencesRefs<T extends Object>(
      Expression<T> Function($$OccurrencesTableAnnotationComposer a) f) {
    final $$OccurrencesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.occurrences,
        getReferencedColumn: (t) => t.templateId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OccurrencesTableAnnotationComposer(
              $db: $db,
              $table: $db.occurrences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> reminderRulesRefs<T extends Object>(
      Expression<T> Function($$ReminderRulesTableAnnotationComposer a) f) {
    final $$ReminderRulesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminderRules,
        getReferencedColumn: (t) => t.templateId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReminderRulesTableAnnotationComposer(
              $db: $db,
              $table: $db.reminderRules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DebtTemplatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DebtTemplatesTable,
    DebtTemplate,
    $$DebtTemplatesTableFilterComposer,
    $$DebtTemplatesTableOrderingComposer,
    $$DebtTemplatesTableAnnotationComposer,
    $$DebtTemplatesTableCreateCompanionBuilder,
    $$DebtTemplatesTableUpdateCompanionBuilder,
    (DebtTemplate, $$DebtTemplatesTableReferences),
    DebtTemplate,
    PrefetchHooks Function(
        {bool cardId,
        bool paymentMethodId,
        bool recurrencesRefs,
        bool occurrencesRefs,
        bool reminderRulesRefs})> {
  $$DebtTemplatesTableTableManager(_$AppDatabase db, $DebtTemplatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String?> categoria = const Value.absent(),
            Value<double> monto = const Value.absent(),
            Value<double?> currentBalance = const Value.absent(),
            Value<String?> cardId = const Value.absent(),
            Value<String?> paymentMethodId = const Value.absent(),
            Value<bool> hasInterest = const Value.absent(),
            Value<String?> interestType = const Value.absent(),
            Value<double?> interestRateMonthly = const Value.absent(),
            Value<int?> termMonths = const Value.absent(),
            Value<int?> graceMonths = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<int?> createdAt = const Value.absent(),
            Value<int?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DebtTemplatesCompanion(
            id: id,
            nombre: nombre,
            categoria: categoria,
            monto: monto,
            currentBalance: currentBalance,
            cardId: cardId,
            paymentMethodId: paymentMethodId,
            hasInterest: hasInterest,
            interestType: interestType,
            interestRateMonthly: interestRateMonthly,
            termMonths: termMonths,
            graceMonths: graceMonths,
            categoryId: categoryId,
            notas: notas,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nombre,
            Value<String?> categoria = const Value.absent(),
            required double monto,
            Value<double?> currentBalance = const Value.absent(),
            Value<String?> cardId = const Value.absent(),
            Value<String?> paymentMethodId = const Value.absent(),
            Value<bool> hasInterest = const Value.absent(),
            Value<String?> interestType = const Value.absent(),
            Value<double?> interestRateMonthly = const Value.absent(),
            Value<int?> termMonths = const Value.absent(),
            Value<int?> graceMonths = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<int?> createdAt = const Value.absent(),
            Value<int?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DebtTemplatesCompanion.insert(
            id: id,
            nombre: nombre,
            categoria: categoria,
            monto: monto,
            currentBalance: currentBalance,
            cardId: cardId,
            paymentMethodId: paymentMethodId,
            hasInterest: hasInterest,
            interestType: interestType,
            interestRateMonthly: interestRateMonthly,
            termMonths: termMonths,
            graceMonths: graceMonths,
            categoryId: categoryId,
            notas: notas,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DebtTemplatesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {cardId = false,
              paymentMethodId = false,
              recurrencesRefs = false,
              occurrencesRefs = false,
              reminderRulesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recurrencesRefs) db.recurrences,
                if (occurrencesRefs) db.occurrences,
                if (reminderRulesRefs) db.reminderRules
              ],
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
                if (cardId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cardId,
                    referencedTable:
                        $$DebtTemplatesTableReferences._cardIdTable(db),
                    referencedColumn:
                        $$DebtTemplatesTableReferences._cardIdTable(db).id,
                  ) as T;
                }
                if (paymentMethodId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.paymentMethodId,
                    referencedTable: $$DebtTemplatesTableReferences
                        ._paymentMethodIdTable(db),
                    referencedColumn: $$DebtTemplatesTableReferences
                        ._paymentMethodIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recurrencesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$DebtTemplatesTableReferences
                            ._recurrencesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DebtTemplatesTableReferences(db, table, p0)
                                .recurrencesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.templateId == item.id),
                        typedResults: items),
                  if (occurrencesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$DebtTemplatesTableReferences
                            ._occurrencesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DebtTemplatesTableReferences(db, table, p0)
                                .occurrencesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.templateId == item.id),
                        typedResults: items),
                  if (reminderRulesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$DebtTemplatesTableReferences
                            ._reminderRulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DebtTemplatesTableReferences(db, table, p0)
                                .reminderRulesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.templateId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DebtTemplatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DebtTemplatesTable,
    DebtTemplate,
    $$DebtTemplatesTableFilterComposer,
    $$DebtTemplatesTableOrderingComposer,
    $$DebtTemplatesTableAnnotationComposer,
    $$DebtTemplatesTableCreateCompanionBuilder,
    $$DebtTemplatesTableUpdateCompanionBuilder,
    (DebtTemplate, $$DebtTemplatesTableReferences),
    DebtTemplate,
    PrefetchHooks Function(
        {bool cardId,
        bool paymentMethodId,
        bool recurrencesRefs,
        bool occurrencesRefs,
        bool reminderRulesRefs})>;
typedef $$RecurrencesTableCreateCompanionBuilder = RecurrencesCompanion
    Function({
  required String id,
  required String templateId,
  required String tipo,
  Value<int?> diaMes,
  Value<int?> dow,
  Value<int?> everyNDays,
  required int fechaInicio,
  Value<int?> fechaFin,
  Value<int?> totalCiclos,
  Value<int?> ciclosRestantes,
  Value<int?> createdAt,
  Value<int?> updatedAt,
  Value<int> rowid,
});
typedef $$RecurrencesTableUpdateCompanionBuilder = RecurrencesCompanion
    Function({
  Value<String> id,
  Value<String> templateId,
  Value<String> tipo,
  Value<int?> diaMes,
  Value<int?> dow,
  Value<int?> everyNDays,
  Value<int> fechaInicio,
  Value<int?> fechaFin,
  Value<int?> totalCiclos,
  Value<int?> ciclosRestantes,
  Value<int?> createdAt,
  Value<int?> updatedAt,
  Value<int> rowid,
});

final class $$RecurrencesTableReferences
    extends BaseReferences<_$AppDatabase, $RecurrencesTable, Recurrence> {
  $$RecurrencesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DebtTemplatesTable _templateIdTable(_$AppDatabase db) =>
      db.debtTemplates.createAlias(
          $_aliasNameGenerator(db.recurrences.templateId, db.debtTemplates.id));

  $$DebtTemplatesTableProcessedTableManager? get templateId {
    if ($_item.templateId == null) return null;
    final manager = $$DebtTemplatesTableTableManager($_db, $_db.debtTemplates)
        .filter((f) => f.id($_item.templateId!));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RecurrencesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurrencesTable> {
  $$RecurrencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get diaMes => $composableBuilder(
      column: $table.diaMes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dow => $composableBuilder(
      column: $table.dow, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get everyNDays => $composableBuilder(
      column: $table.everyNDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaInicio => $composableBuilder(
      column: $table.fechaInicio, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaFin => $composableBuilder(
      column: $table.fechaFin, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalCiclos => $composableBuilder(
      column: $table.totalCiclos, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ciclosRestantes => $composableBuilder(
      column: $table.ciclosRestantes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$DebtTemplatesTableFilterComposer get templateId {
    final $$DebtTemplatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.debtTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtTemplatesTableFilterComposer(
              $db: $db,
              $table: $db.debtTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecurrencesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurrencesTable> {
  $$RecurrencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipo => $composableBuilder(
      column: $table.tipo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get diaMes => $composableBuilder(
      column: $table.diaMes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dow => $composableBuilder(
      column: $table.dow, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get everyNDays => $composableBuilder(
      column: $table.everyNDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaInicio => $composableBuilder(
      column: $table.fechaInicio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaFin => $composableBuilder(
      column: $table.fechaFin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalCiclos => $composableBuilder(
      column: $table.totalCiclos, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ciclosRestantes => $composableBuilder(
      column: $table.ciclosRestantes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$DebtTemplatesTableOrderingComposer get templateId {
    final $$DebtTemplatesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.debtTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtTemplatesTableOrderingComposer(
              $db: $db,
              $table: $db.debtTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecurrencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurrencesTable> {
  $$RecurrencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get diaMes =>
      $composableBuilder(column: $table.diaMes, builder: (column) => column);

  GeneratedColumn<int> get dow =>
      $composableBuilder(column: $table.dow, builder: (column) => column);

  GeneratedColumn<int> get everyNDays => $composableBuilder(
      column: $table.everyNDays, builder: (column) => column);

  GeneratedColumn<int> get fechaInicio => $composableBuilder(
      column: $table.fechaInicio, builder: (column) => column);

  GeneratedColumn<int> get fechaFin =>
      $composableBuilder(column: $table.fechaFin, builder: (column) => column);

  GeneratedColumn<int> get totalCiclos => $composableBuilder(
      column: $table.totalCiclos, builder: (column) => column);

  GeneratedColumn<int> get ciclosRestantes => $composableBuilder(
      column: $table.ciclosRestantes, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DebtTemplatesTableAnnotationComposer get templateId {
    final $$DebtTemplatesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.debtTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtTemplatesTableAnnotationComposer(
              $db: $db,
              $table: $db.debtTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecurrencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecurrencesTable,
    Recurrence,
    $$RecurrencesTableFilterComposer,
    $$RecurrencesTableOrderingComposer,
    $$RecurrencesTableAnnotationComposer,
    $$RecurrencesTableCreateCompanionBuilder,
    $$RecurrencesTableUpdateCompanionBuilder,
    (Recurrence, $$RecurrencesTableReferences),
    Recurrence,
    PrefetchHooks Function({bool templateId})> {
  $$RecurrencesTableTableManager(_$AppDatabase db, $RecurrencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurrencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurrencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurrencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> templateId = const Value.absent(),
            Value<String> tipo = const Value.absent(),
            Value<int?> diaMes = const Value.absent(),
            Value<int?> dow = const Value.absent(),
            Value<int?> everyNDays = const Value.absent(),
            Value<int> fechaInicio = const Value.absent(),
            Value<int?> fechaFin = const Value.absent(),
            Value<int?> totalCiclos = const Value.absent(),
            Value<int?> ciclosRestantes = const Value.absent(),
            Value<int?> createdAt = const Value.absent(),
            Value<int?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurrencesCompanion(
            id: id,
            templateId: templateId,
            tipo: tipo,
            diaMes: diaMes,
            dow: dow,
            everyNDays: everyNDays,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            totalCiclos: totalCiclos,
            ciclosRestantes: ciclosRestantes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String templateId,
            required String tipo,
            Value<int?> diaMes = const Value.absent(),
            Value<int?> dow = const Value.absent(),
            Value<int?> everyNDays = const Value.absent(),
            required int fechaInicio,
            Value<int?> fechaFin = const Value.absent(),
            Value<int?> totalCiclos = const Value.absent(),
            Value<int?> ciclosRestantes = const Value.absent(),
            Value<int?> createdAt = const Value.absent(),
            Value<int?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurrencesCompanion.insert(
            id: id,
            templateId: templateId,
            tipo: tipo,
            diaMes: diaMes,
            dow: dow,
            everyNDays: everyNDays,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            totalCiclos: totalCiclos,
            ciclosRestantes: ciclosRestantes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RecurrencesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({templateId = false}) {
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
                if (templateId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.templateId,
                    referencedTable:
                        $$RecurrencesTableReferences._templateIdTable(db),
                    referencedColumn:
                        $$RecurrencesTableReferences._templateIdTable(db).id,
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

typedef $$RecurrencesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecurrencesTable,
    Recurrence,
    $$RecurrencesTableFilterComposer,
    $$RecurrencesTableOrderingComposer,
    $$RecurrencesTableAnnotationComposer,
    $$RecurrencesTableCreateCompanionBuilder,
    $$RecurrencesTableUpdateCompanionBuilder,
    (Recurrence, $$RecurrencesTableReferences),
    Recurrence,
    PrefetchHooks Function({bool templateId})>;
typedef $$OccurrencesTableCreateCompanionBuilder = OccurrencesCompanion
    Function({
  required String id,
  required String templateId,
  required int fechaDue,
  required double monto,
  Value<String> estado,
  Value<String?> cardId,
  Value<int?> createdAt,
  Value<int?> updatedAt,
  Value<int> rowid,
});
typedef $$OccurrencesTableUpdateCompanionBuilder = OccurrencesCompanion
    Function({
  Value<String> id,
  Value<String> templateId,
  Value<int> fechaDue,
  Value<double> monto,
  Value<String> estado,
  Value<String?> cardId,
  Value<int?> createdAt,
  Value<int?> updatedAt,
  Value<int> rowid,
});

final class $$OccurrencesTableReferences
    extends BaseReferences<_$AppDatabase, $OccurrencesTable, Occurrence> {
  $$OccurrencesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DebtTemplatesTable _templateIdTable(_$AppDatabase db) =>
      db.debtTemplates.createAlias(
          $_aliasNameGenerator(db.occurrences.templateId, db.debtTemplates.id));

  $$DebtTemplatesTableProcessedTableManager? get templateId {
    if ($_item.templateId == null) return null;
    final manager = $$DebtTemplatesTableTableManager($_db, $_db.debtTemplates)
        .filter((f) => f.id($_item.templateId!));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CardsTable _cardIdTable(_$AppDatabase db) => db.cards
      .createAlias($_aliasNameGenerator(db.occurrences.cardId, db.cards.id));

  $$CardsTableProcessedTableManager? get cardId {
    if ($_item.cardId == null) return null;
    final manager = $$CardsTableTableManager($_db, $_db.cards)
        .filter((f) => f.id($_item.cardId!));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.payments,
          aliasName: $_aliasNameGenerator(
              db.occurrences.id, db.payments.occurrenceId));

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager($_db, $_db.payments)
        .filter((f) => f.occurrenceId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$OccurrencesTableFilterComposer
    extends Composer<_$AppDatabase, $OccurrencesTable> {
  $$OccurrencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaDue => $composableBuilder(
      column: $table.fechaDue, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get monto => $composableBuilder(
      column: $table.monto, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$DebtTemplatesTableFilterComposer get templateId {
    final $$DebtTemplatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.debtTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtTemplatesTableFilterComposer(
              $db: $db,
              $table: $db.debtTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CardsTableFilterComposer get cardId {
    final $$CardsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cardId,
        referencedTable: $db.cards,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CardsTableFilterComposer(
              $db: $db,
              $table: $db.cards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> paymentsRefs(
      Expression<bool> Function($$PaymentsTableFilterComposer f) f) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.occurrenceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableFilterComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OccurrencesTableOrderingComposer
    extends Composer<_$AppDatabase, $OccurrencesTable> {
  $$OccurrencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaDue => $composableBuilder(
      column: $table.fechaDue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get monto => $composableBuilder(
      column: $table.monto, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$DebtTemplatesTableOrderingComposer get templateId {
    final $$DebtTemplatesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.debtTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtTemplatesTableOrderingComposer(
              $db: $db,
              $table: $db.debtTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CardsTableOrderingComposer get cardId {
    final $$CardsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cardId,
        referencedTable: $db.cards,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CardsTableOrderingComposer(
              $db: $db,
              $table: $db.cards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OccurrencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OccurrencesTable> {
  $$OccurrencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get fechaDue =>
      $composableBuilder(column: $table.fechaDue, builder: (column) => column);

  GeneratedColumn<double> get monto =>
      $composableBuilder(column: $table.monto, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DebtTemplatesTableAnnotationComposer get templateId {
    final $$DebtTemplatesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.debtTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtTemplatesTableAnnotationComposer(
              $db: $db,
              $table: $db.debtTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CardsTableAnnotationComposer get cardId {
    final $$CardsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.cardId,
        referencedTable: $db.cards,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CardsTableAnnotationComposer(
              $db: $db,
              $table: $db.cards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> paymentsRefs<T extends Object>(
      Expression<T> Function($$PaymentsTableAnnotationComposer a) f) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.occurrenceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OccurrencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OccurrencesTable,
    Occurrence,
    $$OccurrencesTableFilterComposer,
    $$OccurrencesTableOrderingComposer,
    $$OccurrencesTableAnnotationComposer,
    $$OccurrencesTableCreateCompanionBuilder,
    $$OccurrencesTableUpdateCompanionBuilder,
    (Occurrence, $$OccurrencesTableReferences),
    Occurrence,
    PrefetchHooks Function({bool templateId, bool cardId, bool paymentsRefs})> {
  $$OccurrencesTableTableManager(_$AppDatabase db, $OccurrencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OccurrencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OccurrencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OccurrencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> templateId = const Value.absent(),
            Value<int> fechaDue = const Value.absent(),
            Value<double> monto = const Value.absent(),
            Value<String> estado = const Value.absent(),
            Value<String?> cardId = const Value.absent(),
            Value<int?> createdAt = const Value.absent(),
            Value<int?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OccurrencesCompanion(
            id: id,
            templateId: templateId,
            fechaDue: fechaDue,
            monto: monto,
            estado: estado,
            cardId: cardId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String templateId,
            required int fechaDue,
            required double monto,
            Value<String> estado = const Value.absent(),
            Value<String?> cardId = const Value.absent(),
            Value<int?> createdAt = const Value.absent(),
            Value<int?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OccurrencesCompanion.insert(
            id: id,
            templateId: templateId,
            fechaDue: fechaDue,
            monto: monto,
            estado: estado,
            cardId: cardId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OccurrencesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {templateId = false, cardId = false, paymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (paymentsRefs) db.payments],
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
                if (templateId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.templateId,
                    referencedTable:
                        $$OccurrencesTableReferences._templateIdTable(db),
                    referencedColumn:
                        $$OccurrencesTableReferences._templateIdTable(db).id,
                  ) as T;
                }
                if (cardId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.cardId,
                    referencedTable:
                        $$OccurrencesTableReferences._cardIdTable(db),
                    referencedColumn:
                        $$OccurrencesTableReferences._cardIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (paymentsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$OccurrencesTableReferences._paymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OccurrencesTableReferences(db, table, p0)
                                .paymentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.occurrenceId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$OccurrencesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OccurrencesTable,
    Occurrence,
    $$OccurrencesTableFilterComposer,
    $$OccurrencesTableOrderingComposer,
    $$OccurrencesTableAnnotationComposer,
    $$OccurrencesTableCreateCompanionBuilder,
    $$OccurrencesTableUpdateCompanionBuilder,
    (Occurrence, $$OccurrencesTableReferences),
    Occurrence,
    PrefetchHooks Function({bool templateId, bool cardId, bool paymentsRefs})>;
typedef $$ReminderRulesTableCreateCompanionBuilder = ReminderRulesCompanion
    Function({
  required String id,
  required String templateId,
  required int offsetDays,
  Value<int> rowid,
});
typedef $$ReminderRulesTableUpdateCompanionBuilder = ReminderRulesCompanion
    Function({
  Value<String> id,
  Value<String> templateId,
  Value<int> offsetDays,
  Value<int> rowid,
});

final class $$ReminderRulesTableReferences
    extends BaseReferences<_$AppDatabase, $ReminderRulesTable, ReminderRule> {
  $$ReminderRulesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DebtTemplatesTable _templateIdTable(_$AppDatabase db) =>
      db.debtTemplates.createAlias($_aliasNameGenerator(
          db.reminderRules.templateId, db.debtTemplates.id));

  $$DebtTemplatesTableProcessedTableManager? get templateId {
    if ($_item.templateId == null) return null;
    final manager = $$DebtTemplatesTableTableManager($_db, $_db.debtTemplates)
        .filter((f) => f.id($_item.templateId!));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ReminderRulesTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderRulesTable> {
  $$ReminderRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get offsetDays => $composableBuilder(
      column: $table.offsetDays, builder: (column) => ColumnFilters(column));

  $$DebtTemplatesTableFilterComposer get templateId {
    final $$DebtTemplatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.debtTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtTemplatesTableFilterComposer(
              $db: $db,
              $table: $db.debtTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReminderRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderRulesTable> {
  $$ReminderRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get offsetDays => $composableBuilder(
      column: $table.offsetDays, builder: (column) => ColumnOrderings(column));

  $$DebtTemplatesTableOrderingComposer get templateId {
    final $$DebtTemplatesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.debtTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtTemplatesTableOrderingComposer(
              $db: $db,
              $table: $db.debtTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReminderRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderRulesTable> {
  $$ReminderRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get offsetDays => $composableBuilder(
      column: $table.offsetDays, builder: (column) => column);

  $$DebtTemplatesTableAnnotationComposer get templateId {
    final $$DebtTemplatesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.templateId,
        referencedTable: $db.debtTemplates,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DebtTemplatesTableAnnotationComposer(
              $db: $db,
              $table: $db.debtTemplates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReminderRulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReminderRulesTable,
    ReminderRule,
    $$ReminderRulesTableFilterComposer,
    $$ReminderRulesTableOrderingComposer,
    $$ReminderRulesTableAnnotationComposer,
    $$ReminderRulesTableCreateCompanionBuilder,
    $$ReminderRulesTableUpdateCompanionBuilder,
    (ReminderRule, $$ReminderRulesTableReferences),
    ReminderRule,
    PrefetchHooks Function({bool templateId})> {
  $$ReminderRulesTableTableManager(_$AppDatabase db, $ReminderRulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> templateId = const Value.absent(),
            Value<int> offsetDays = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReminderRulesCompanion(
            id: id,
            templateId: templateId,
            offsetDays: offsetDays,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String templateId,
            required int offsetDays,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReminderRulesCompanion.insert(
            id: id,
            templateId: templateId,
            offsetDays: offsetDays,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ReminderRulesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({templateId = false}) {
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
                if (templateId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.templateId,
                    referencedTable:
                        $$ReminderRulesTableReferences._templateIdTable(db),
                    referencedColumn:
                        $$ReminderRulesTableReferences._templateIdTable(db).id,
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

typedef $$ReminderRulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReminderRulesTable,
    ReminderRule,
    $$ReminderRulesTableFilterComposer,
    $$ReminderRulesTableOrderingComposer,
    $$ReminderRulesTableAnnotationComposer,
    $$ReminderRulesTableCreateCompanionBuilder,
    $$ReminderRulesTableUpdateCompanionBuilder,
    (ReminderRule, $$ReminderRulesTableReferences),
    ReminderRule,
    PrefetchHooks Function({bool templateId})>;
typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  required String id,
  required String occurrenceId,
  required int fechaPago,
  required double montoPagado,
  Value<String?> metodoPago,
  Value<String?> paymentMethodId,
  Value<double?> interestPortion,
  Value<double?> principalPortion,
  Value<String?> notas,
  Value<int?> createdAt,
  Value<int?> updatedAt,
  Value<int> rowid,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<String> id,
  Value<String> occurrenceId,
  Value<int> fechaPago,
  Value<double> montoPagado,
  Value<String?> metodoPago,
  Value<String?> paymentMethodId,
  Value<double?> interestPortion,
  Value<double?> principalPortion,
  Value<String?> notas,
  Value<int?> createdAt,
  Value<int?> updatedAt,
  Value<int> rowid,
});

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OccurrencesTable _occurrenceIdTable(_$AppDatabase db) =>
      db.occurrences.createAlias(
          $_aliasNameGenerator(db.payments.occurrenceId, db.occurrences.id));

  $$OccurrencesTableProcessedTableManager? get occurrenceId {
    if ($_item.occurrenceId == null) return null;
    final manager = $$OccurrencesTableTableManager($_db, $_db.occurrences)
        .filter((f) => f.id($_item.occurrenceId!));
    final item = $_typedResult.readTableOrNull(_occurrenceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PaymentMethodsTable _paymentMethodIdTable(_$AppDatabase db) =>
      db.paymentMethods.createAlias($_aliasNameGenerator(
          db.payments.paymentMethodId, db.paymentMethods.id));

  $$PaymentMethodsTableProcessedTableManager? get paymentMethodId {
    if ($_item.paymentMethodId == null) return null;
    final manager = $$PaymentMethodsTableTableManager($_db, $_db.paymentMethods)
        .filter((f) => f.id($_item.paymentMethodId!));
    final item = $_typedResult.readTableOrNull(_paymentMethodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fechaPago => $composableBuilder(
      column: $table.fechaPago, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get montoPagado => $composableBuilder(
      column: $table.montoPagado, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metodoPago => $composableBuilder(
      column: $table.metodoPago, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get interestPortion => $composableBuilder(
      column: $table.interestPortion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get principalPortion => $composableBuilder(
      column: $table.principalPortion,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notas => $composableBuilder(
      column: $table.notas, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$OccurrencesTableFilterComposer get occurrenceId {
    final $$OccurrencesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.occurrenceId,
        referencedTable: $db.occurrences,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OccurrencesTableFilterComposer(
              $db: $db,
              $table: $db.occurrences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PaymentMethodsTableFilterComposer get paymentMethodId {
    final $$PaymentMethodsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paymentMethodId,
        referencedTable: $db.paymentMethods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentMethodsTableFilterComposer(
              $db: $db,
              $table: $db.paymentMethods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fechaPago => $composableBuilder(
      column: $table.fechaPago, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get montoPagado => $composableBuilder(
      column: $table.montoPagado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metodoPago => $composableBuilder(
      column: $table.metodoPago, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get interestPortion => $composableBuilder(
      column: $table.interestPortion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get principalPortion => $composableBuilder(
      column: $table.principalPortion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notas => $composableBuilder(
      column: $table.notas, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$OccurrencesTableOrderingComposer get occurrenceId {
    final $$OccurrencesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.occurrenceId,
        referencedTable: $db.occurrences,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OccurrencesTableOrderingComposer(
              $db: $db,
              $table: $db.occurrences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PaymentMethodsTableOrderingComposer get paymentMethodId {
    final $$PaymentMethodsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paymentMethodId,
        referencedTable: $db.paymentMethods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentMethodsTableOrderingComposer(
              $db: $db,
              $table: $db.paymentMethods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get fechaPago =>
      $composableBuilder(column: $table.fechaPago, builder: (column) => column);

  GeneratedColumn<double> get montoPagado => $composableBuilder(
      column: $table.montoPagado, builder: (column) => column);

  GeneratedColumn<String> get metodoPago => $composableBuilder(
      column: $table.metodoPago, builder: (column) => column);

  GeneratedColumn<double> get interestPortion => $composableBuilder(
      column: $table.interestPortion, builder: (column) => column);

  GeneratedColumn<double> get principalPortion => $composableBuilder(
      column: $table.principalPortion, builder: (column) => column);

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$OccurrencesTableAnnotationComposer get occurrenceId {
    final $$OccurrencesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.occurrenceId,
        referencedTable: $db.occurrences,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OccurrencesTableAnnotationComposer(
              $db: $db,
              $table: $db.occurrences,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PaymentMethodsTableAnnotationComposer get paymentMethodId {
    final $$PaymentMethodsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paymentMethodId,
        referencedTable: $db.paymentMethods,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentMethodsTableAnnotationComposer(
              $db: $db,
              $table: $db.paymentMethods,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, $$PaymentsTableReferences),
    Payment,
    PrefetchHooks Function({bool occurrenceId, bool paymentMethodId})> {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> occurrenceId = const Value.absent(),
            Value<int> fechaPago = const Value.absent(),
            Value<double> montoPagado = const Value.absent(),
            Value<String?> metodoPago = const Value.absent(),
            Value<String?> paymentMethodId = const Value.absent(),
            Value<double?> interestPortion = const Value.absent(),
            Value<double?> principalPortion = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            Value<int?> createdAt = const Value.absent(),
            Value<int?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsCompanion(
            id: id,
            occurrenceId: occurrenceId,
            fechaPago: fechaPago,
            montoPagado: montoPagado,
            metodoPago: metodoPago,
            paymentMethodId: paymentMethodId,
            interestPortion: interestPortion,
            principalPortion: principalPortion,
            notas: notas,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String occurrenceId,
            required int fechaPago,
            required double montoPagado,
            Value<String?> metodoPago = const Value.absent(),
            Value<String?> paymentMethodId = const Value.absent(),
            Value<double?> interestPortion = const Value.absent(),
            Value<double?> principalPortion = const Value.absent(),
            Value<String?> notas = const Value.absent(),
            Value<int?> createdAt = const Value.absent(),
            Value<int?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsCompanion.insert(
            id: id,
            occurrenceId: occurrenceId,
            fechaPago: fechaPago,
            montoPagado: montoPagado,
            metodoPago: metodoPago,
            paymentMethodId: paymentMethodId,
            interestPortion: interestPortion,
            principalPortion: principalPortion,
            notas: notas,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PaymentsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {occurrenceId = false, paymentMethodId = false}) {
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
                if (occurrenceId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.occurrenceId,
                    referencedTable:
                        $$PaymentsTableReferences._occurrenceIdTable(db),
                    referencedColumn:
                        $$PaymentsTableReferences._occurrenceIdTable(db).id,
                  ) as T;
                }
                if (paymentMethodId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.paymentMethodId,
                    referencedTable:
                        $$PaymentsTableReferences._paymentMethodIdTable(db),
                    referencedColumn:
                        $$PaymentsTableReferences._paymentMethodIdTable(db).id,
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

typedef $$PaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, $$PaymentsTableReferences),
    Payment,
    PrefetchHooks Function({bool occurrenceId, bool paymentMethodId})>;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required String name,
  required int createdAt,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
    Category,
    PrefetchHooks Function()> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
    Category,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PaymentMethodsTableTableManager get paymentMethods =>
      $$PaymentMethodsTableTableManager(_db, _db.paymentMethods);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
  $$DebtTemplatesTableTableManager get debtTemplates =>
      $$DebtTemplatesTableTableManager(_db, _db.debtTemplates);
  $$RecurrencesTableTableManager get recurrences =>
      $$RecurrencesTableTableManager(_db, _db.recurrences);
  $$OccurrencesTableTableManager get occurrences =>
      $$OccurrencesTableTableManager(_db, _db.occurrences);
  $$ReminderRulesTableTableManager get reminderRules =>
      $$ReminderRulesTableTableManager(_db, _db.reminderRules);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
}
