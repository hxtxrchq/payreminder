import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// Tabla de métodos de pago
class PaymentMethods extends Table {
  TextColumn get id => text()();
  // CASH, YAPE, CARD, PAYPAL, BANK_TRANSFER, OTHER
  TextColumn get type => text()();
  // Alias visible: "Tarjeta 1", "Yape Alonso", etc.
  TextColumn get alias => text()();
  // Sólo para CARD
  TextColumn get last4 => text().nullable()();
  // Banco o marca (BBVA, Visa)
  TextColumn get issuer => text().nullable()();
  // 0/1
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  // epoch ms
  IntColumn get createdAt => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class Cards extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get ultimas4 => text().nullable()();
  TextColumn get color => text().nullable()(); // #RRGGBB
  @override
  Set<Column> get primaryKey => {id};
}

class DebtTemplates extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get categoria => text().nullable()();
  RealColumn get monto => real()();
  // Saldo actual (para deudas con interés)
  RealColumn get currentBalance => real().nullable()();
  TextColumn get cardId =>
      text().nullable().references(Cards, #id, onDelete: KeyAction.setNull)();
  // Nuevo: referencia a método de pago (opcional)
  TextColumn get paymentMethodId => text()
      .nullable()
      .references(PaymentMethods, #id, onDelete: KeyAction.setNull)();
  // Intereses
  BoolColumn get hasInterest => boolean().withDefault(const Constant(false))();
  TextColumn get interestType =>
      text().nullable()(); // FIXED_INSTALLMENTS | FLEXIBLE
  RealColumn get interestRateMonthly =>
      real().nullable()(); // % mensual (ej 3.0)
  IntColumn get termMonths => integer().nullable()();
  IntColumn get graceMonths => integer().nullable()();
  // Categorías (nueva tabla categories)
  TextColumn get categoryId => text().nullable()();
  TextColumn get notas => text().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer().nullable()(); // epoch millis
  IntColumn get updatedAt => integer().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class Recurrences extends Table {
  TextColumn get id => text()();
  TextColumn get templateId =>
      text().references(DebtTemplates, #id, onDelete: KeyAction.cascade)();
  TextColumn get tipo =>
      text()(); // MONTHLY_BY_DOM, WEEKLY_BY_DOW, YEARLY_BY_DOM, EVERY_N_DAYS
  IntColumn get diaMes => integer().nullable()();
  IntColumn get dow => integer().nullable()(); // 1-7 (Mon-Sun)
  IntColumn get everyNDays => integer().nullable()();
  IntColumn get fechaInicio => integer()();
  IntColumn get fechaFin => integer().nullable()();
  IntColumn get totalCiclos => integer().nullable()();
  IntColumn get ciclosRestantes => integer().nullable()();
  IntColumn get createdAt => integer().nullable()();
  IntColumn get updatedAt => integer().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class Occurrences extends Table {
  TextColumn get id => text()();
  TextColumn get templateId =>
      text().references(DebtTemplates, #id, onDelete: KeyAction.cascade)();
  IntColumn get fechaDue => integer()(); // epoch millis (0h local)
  RealColumn get monto => real()();
  // PENDING, NEAR, DUE_TODAY, OVERDUE, PAID
  TextColumn get estado => text().withDefault(const Constant('PENDING'))();
  TextColumn get cardId =>
      text().nullable().references(Cards, #id, onDelete: KeyAction.setNull)();
  IntColumn get createdAt => integer().nullable()();
  IntColumn get updatedAt => integer().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class ReminderRules extends Table {
  TextColumn get id => text()();
  TextColumn get templateId =>
      text().references(DebtTemplates, #id, onDelete: KeyAction.cascade)();
  IntColumn get offsetDays => integer()(); // -5, -1, 0, ...
  @override
  Set<Column> get primaryKey => {id};
}

class Payments extends Table {
  TextColumn get id => text()();
  TextColumn get occurrenceId => text()
      .unique()
      .references(Occurrences, #id, onDelete: KeyAction.cascade)();
  IntColumn get fechaPago => integer()(); // epoch millis
  RealColumn get montoPagado => real()();
  TextColumn get metodoPago => text().nullable()(); // Compatibilidad legacy
  // Nuevo: referencia al método de pago elegido
  TextColumn get paymentMethodId => text()
      .nullable()
      .references(PaymentMethods, #id, onDelete: KeyAction.setNull)();
  // Descomposición de pago (si aplica intereses)
  RealColumn get interestPortion =>
      real().withDefault(const Constant(0)).nullable()();
  RealColumn get principalPortion =>
      real().withDefault(const Constant(0)).nullable()();
  TextColumn get notas => text().nullable()();
  IntColumn get createdAt => integer().nullable()();
  IntColumn get updatedAt => integer().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

// Nueva tabla de categorías
class Categories extends Table {
  TextColumn get id => text()();
  // Nota: unicidad case-insensitive se asegura con índice único en lower(name)
  TextColumn get name => text()();
  IntColumn get createdAt => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  PaymentMethods,
  Cards,
  DebtTemplates,
  Recurrences,
  Occurrences,
  ReminderRules,
  Payments,
  Categories,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase._internal(QueryExecutor e) : super(e);
  factory AppDatabase.memory() =>
      AppDatabase._internal(NativeDatabase.memory());
  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // Semillas de métodos de pago comunes
          final now = DateTime.now().millisecondsSinceEpoch;
          await customStatement(
              "INSERT INTO payment_methods (id,type,alias,last4,issuer,is_default,created_at) VALUES ('pm_cash','CASH','Efectivo',NULL,NULL,1,$now)");
          await customStatement(
              "INSERT INTO payment_methods (id,type,alias,last4,issuer,is_default,created_at) VALUES ('pm_yape','YAPE','Yape',NULL,NULL,0,$now)");
          await customStatement(
              "INSERT INTO payment_methods (id,type,alias,last4,issuer,is_default,created_at) VALUES ('pm_transfer','BANK_TRANSFER','Transferencia',NULL,NULL,0,$now)");
          await customStatement(
              "INSERT INTO payment_methods (id,type,alias,last4,issuer,is_default,created_at) VALUES ('pm_paypal','PAYPAL','PayPal',NULL,NULL,0,$now)");
          await customStatement(
              "INSERT INTO payment_methods (id,type,alias,last4,issuer,is_default,created_at) VALUES ('pm_other','OTHER','Otros',NULL,NULL,0,$now)");
          // Índice único case-insensitive para nombres de categorías
          await customStatement(
              "CREATE UNIQUE INDEX IF NOT EXISTS idx_categories_name_ci ON categories (lower(name));");
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Crear nueva tabla de métodos de pago (SQL directo para compatibilidad)
            await customStatement('''
              CREATE TABLE IF NOT EXISTS payment_methods (
                id TEXT NOT NULL PRIMARY KEY,
                type TEXT NOT NULL,
                alias TEXT NOT NULL,
                last4 TEXT,
                issuer TEXT,
                is_default INTEGER NOT NULL DEFAULT 0,
                created_at INTEGER NOT NULL
              );
            ''');
            // Agregar columnas a plantillas y pagos si no existen
            await customStatement(
                "ALTER TABLE debt_templates ADD COLUMN payment_method_id TEXT");
            await customStatement(
                "ALTER TABLE payments ADD COLUMN payment_method_id TEXT");
            // Asegurar estado por defecto y backfill nulos
            await customStatement(
                "UPDATE occurrences SET estado = 'PENDING' WHERE estado IS NULL OR estado = ''");
          }
          if (from < 3) {
            // Intereses y categorías
            await customStatement(
                "ALTER TABLE debt_templates ADD COLUMN has_interest INTEGER NOT NULL DEFAULT 0");
            await customStatement(
                "ALTER TABLE debt_templates ADD COLUMN interest_type TEXT");
            await customStatement(
                "ALTER TABLE debt_templates ADD COLUMN interest_rate_monthly REAL");
            await customStatement(
                "ALTER TABLE debt_templates ADD COLUMN term_months INTEGER");
            await customStatement(
                "ALTER TABLE debt_templates ADD COLUMN grace_months INTEGER");
            await customStatement(
                "ALTER TABLE debt_templates ADD COLUMN category_id TEXT");

            await customStatement(
                "ALTER TABLE payments ADD COLUMN interest_portion REAL DEFAULT 0");
            await customStatement(
                "ALTER TABLE payments ADD COLUMN principal_portion REAL DEFAULT 0");

            await customStatement('''
              CREATE TABLE IF NOT EXISTS categories (
                id TEXT NOT NULL PRIMARY KEY,
                name TEXT NOT NULL,
                color_hex TEXT NOT NULL,
                icon_name TEXT,
                created_at INTEGER NOT NULL
              );
            ''');
          }
          if (from < 4) {
            await customStatement(
                "ALTER TABLE debt_templates ADD COLUMN current_balance REAL");
          }
          if (from < 5) {
            // Migración para eliminar color/icon de categories y asegurar unicidad CI
            await customStatement('''
              CREATE TABLE IF NOT EXISTS categories_new (
                id TEXT NOT NULL PRIMARY KEY,
                name TEXT NOT NULL,
                created_at INTEGER NOT NULL
              );
            ''');
            // Copiar datos existentes
            await customStatement('''
              INSERT OR IGNORE INTO categories_new (id, name, created_at)
              SELECT id, name, created_at FROM categories
              WHERE id IS NOT NULL AND name IS NOT NULL;
            ''');
            // Reemplazar tabla antigua
            await customStatement('DROP TABLE IF EXISTS categories;');
            await customStatement(
                'ALTER TABLE categories_new RENAME TO categories;');
            await customStatement(
                "CREATE UNIQUE INDEX IF NOT EXISTS idx_categories_name_ci ON categories (lower(name));");
          }
          // Quick guard: ensure no NULL estados remain after any schema drift
          await customStatement(
              "UPDATE occurrences SET estado='PENDING' WHERE estado IS NULL;");
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'payreminder.db'));
    return NativeDatabase.createInBackground(file);
  });
}
