import 'package:drift/drift.dart';
import '../db/app_database.dart';

part 'card_dao.g.dart';

@DriftAccessor(tables: [Cards])
class CardDao extends DatabaseAccessor<AppDatabase> with _$CardDaoMixin {
  CardDao(AppDatabase db) : super(db);

  // CRUD Operations
  Future<String> insertCard(CardsCompanion card) async {
    await into(cards).insert(card);
    return card.id.value;
  }

  Future<Card?> getCardById(String id) async {
    return await (select(cards)..where((card) => card.id.equals(id))).getSingleOrNull();
  }

  Future<List<Card>> getAllCards() async {
    return await (select(cards)..orderBy([(card) => OrderingTerm.asc(card.nombre)])).get();
  }

  Future<List<Card>> getActiveCards() async {
    // Assuming cards don't have an isActive field, return all cards
    // If you need to filter, add the logic here
    return getAllCards();
  }

  Future<bool> updateCard(CardsCompanion card) async {
    final result = await (update(cards)..where((c) => c.id.equals(card.id.value))).write(card);
    return result > 0;
  }

  Future<bool> deleteCard(String id) async {
    final result = await (delete(cards)..where((card) => card.id.equals(id))).go();
    return result > 0;
  }

  // Search cards by name
  Future<List<Card>> searchCardsByName(String query) async {
    return await (select(cards)
      ..where((card) => card.nombre.contains(query))
      ..orderBy([(card) => OrderingTerm.asc(card.nombre)])).get();
  }

  // Get cards with specific color
  Future<List<Card>> getCardsByColor(String color) async {
    return await (select(cards)
      ..where((card) => card.color.equals(color))
      ..orderBy([(card) => OrderingTerm.asc(card.nombre)])).get();
  }

  // Count total cards
  Future<int> getCardCount() async {
    final countExp = cards.id.count();
    final query = selectOnly(cards)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  // Check if card exists
  Future<bool> cardExists(String id) async {
    final card = await getCardById(id);
    return card != null;
  }

  // Get cards used in templates (with references)
  Future<List<Card>> getCardsInUse() async {
    final query = select(cards).join([
      innerJoin(db.debtTemplates, db.debtTemplates.cardId.equalsExp(cards.id))
    ]);
    
    final result = await query.get();
    return result.map((row) => row.readTable(cards)).toSet().toList();
  }

  // Watch for real-time updates
  Stream<List<Card>> watchAllCards() {
    return (select(cards)..orderBy([(card) => OrderingTerm.asc(card.nombre)])).watch();
  }

  Stream<Card?> watchCard(String id) {
    return (select(cards)..where((card) => card.id.equals(id))).watchSingleOrNull();
  }
}