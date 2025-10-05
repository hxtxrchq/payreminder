import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../db/card_dao.dart';

class CardRepository {
  final CardDao _cardDao;

  CardRepository(this._cardDao);

  // Basic CRUD operations
  Future<String> createCard({
    required String id,
    required String nombre,
    String? ultimas4,
    String? color,
  }) async {
    final card = CardsCompanion(
      id: Value(id),
      nombre: Value(nombre),
      ultimas4: Value(ultimas4),
      color: Value(color),
    );
    return await _cardDao.insertCard(card);
  }

  Future<Card?> getCard(String id) async {
    return await _cardDao.getCardById(id);
  }

  Future<List<Card>> getAllCards() async {
    return await _cardDao.getAllCards();
  }

  Future<List<Card>> getActiveCards() async {
    return await _cardDao.getActiveCards();
  }

  Future<bool> updateCard({
    required String id,
    String? nombre,
    String? ultimas4,
    String? color,
  }) async {
    final updates = CardsCompanion(
      id: Value(id),
      nombre: nombre != null ? Value(nombre) : const Value.absent(),
      ultimas4: ultimas4 != null ? Value(ultimas4) : const Value.absent(),
      color: color != null ? Value(color) : const Value.absent(),
    );
    return await _cardDao.updateCard(updates);
  }

  Future<bool> deleteCard(String id) async {
    return await _cardDao.deleteCard(id);
  }

  // Search operations
  Future<List<Card>> searchCards(String query) async {
    if (query.isEmpty) return await getAllCards();
    return await _cardDao.searchCardsByName(query);
  }

  Future<List<Card>> getCardsByColor(String color) async {
    return await _cardDao.getCardsByColor(color);
  }

  // Validation operations
  Future<bool> cardExists(String id) async {
    return await _cardDao.cardExists(id);
  }

  Future<bool> isCardInUse(String id) async {
    final cardsInUse = await _cardDao.getCardsInUse();
    return cardsInUse.any((card) => card.id == id);
  }

  // Statistics
  Future<int> getCardCount() async {
    return await _cardDao.getCardCount();
  }

  Future<List<Card>> getCardsInUse() async {
    return await _cardDao.getCardsInUse();
  }

  // Stream operations for real-time updates
  Stream<List<Card>> watchAllCards() {
    return _cardDao.watchAllCards();
  }

  Stream<Card?> watchCard(String id) {
    return _cardDao.watchCard(id);
  }

  // Utility methods
  List<String> getAvailableColors() {
    return [
      '#FF5722', // Deep Orange
      '#2196F3', // Blue
      '#4CAF50', // Green
      '#FF9800', // Orange
      '#9C27B0', // Purple
      '#F44336', // Red
      '#00BCD4', // Cyan
      '#FFEB3B', // Yellow
      '#795548', // Brown
      '#607D8B', // Blue Grey
    ];
  }

  String? validateCardName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'El nombre de la tarjeta es requerido';
    }
    if (name.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    if (name.trim().length > 50) {
      return 'El nombre no puede exceder 50 caracteres';
    }
    return null;
  }

  String? validateUltimas4(String? ultimas4) {
    if (ultimas4 == null || ultimas4.isEmpty) {
      return null; // Optional field
    }
    if (ultimas4.length != 4) {
      return 'Deben ser exactamente 4 dígitos';
    }
    if (!RegExp(r'^\d{4}$').hasMatch(ultimas4)) {
      return 'Solo se permiten números';
    }
    return null;
  }
}