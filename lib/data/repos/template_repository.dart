import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../db/template_dao.dart';

class TemplateRepository {
  final TemplateDao _templateDao;

  TemplateRepository(this._templateDao);

  // Basic CRUD operations
  Future<String> createTemplate({
    required String id,
    required String nombre,
    String? categoria,
    required double monto,
    double? currentBalance,
    String? cardId,
    String? paymentMethodId,
    bool hasInterest = false,
    String? interestType,
    double? interestRateMonthly,
    int? termMonths,
    int? graceMonths,
    String? categoryId,
    String? notas,
    bool isArchived = false,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final template = DebtTemplatesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      categoria: Value(categoria),
      monto: Value(monto),
      currentBalance: Value(currentBalance),
      cardId: Value(cardId),
      paymentMethodId: Value(paymentMethodId),
      hasInterest: Value(hasInterest),
      interestType: Value(interestType),
      interestRateMonthly: Value(interestRateMonthly),
      termMonths: Value(termMonths),
      graceMonths: Value(graceMonths),
      categoryId: Value(categoryId),
      notas: Value(notas),
      isArchived: Value(isArchived),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    return await _templateDao.insertTemplate(template);
  }

  Future<DebtTemplate?> getTemplate(String id) async {
    return await _templateDao.getTemplateById(id);
  }

  Future<TemplateWithCard?> getTemplateWithCard(String id) async {
    return await _templateDao.getTemplateWithCardById(id);
  }

  Future<List<DebtTemplate>> getAllTemplates() async {
    return await _templateDao.getAllTemplates();
  }

  Future<List<DebtTemplate>> getArchivedTemplates() async {
    return await _templateDao.getArchivedTemplates();
  }

  Future<List<TemplateWithCard>> getTemplatesWithCards() async {
    return await _templateDao.getTemplatesWithCards();
  }

  Future<bool> updateTemplate({
    required String id,
    String? nombre,
    String? categoria,
    double? monto,
    double? currentBalance,
    String? cardId,
    String? paymentMethodId,
    bool? hasInterest,
    String? interestType,
    double? interestRateMonthly,
    int? termMonths,
    int? graceMonths,
    String? categoryId,
    String? notas,
    bool? isArchived,
  }) async {
    final updates = DebtTemplatesCompanion(
      id: Value(id),
      nombre: nombre != null ? Value(nombre) : Value.absent(),
      categoria: categoria != null ? Value(categoria) : Value.absent(),
      monto: monto != null ? Value(monto) : Value.absent(),
      currentBalance:
          currentBalance != null ? Value(currentBalance) : Value.absent(),
      cardId: cardId != null ? Value(cardId) : Value.absent(),
      paymentMethodId:
          paymentMethodId != null ? Value(paymentMethodId) : Value.absent(),
      hasInterest: hasInterest != null ? Value(hasInterest) : Value.absent(),
      interestType: interestType != null ? Value(interestType) : Value.absent(),
      interestRateMonthly: interestRateMonthly != null
          ? Value(interestRateMonthly)
          : Value.absent(),
      termMonths: termMonths != null ? Value(termMonths) : Value.absent(),
      graceMonths: graceMonths != null ? Value(graceMonths) : Value.absent(),
      categoryId: categoryId != null ? Value(categoryId) : Value.absent(),
      notas: notas != null ? Value(notas) : Value.absent(),
      isArchived: isArchived != null ? Value(isArchived) : Value.absent(),
      updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
    );
    return await _templateDao.updateTemplate(updates);
  }

  Future<bool> deleteTemplate(String id) async {
    return await _templateDao.deleteTemplate(id);
  }

  Future<bool> archiveTemplate(String id) async {
    return await _templateDao.archiveTemplate(id);
  }

  Future<bool> unarchiveTemplate(String id) async {
    return await _templateDao.unarchiveTemplate(id);
  }

  // Search and filter operations
  Future<List<DebtTemplate>> searchTemplates(String query) async {
    if (query.isEmpty) return await getAllTemplates();
    return await _templateDao.searchTemplatesByName(query);
  }

  Future<List<DebtTemplate>> getTemplatesByCategory(String category) async {
    return await _templateDao.getTemplatesByCategory(category);
  }

  Future<List<DebtTemplate>> getTemplatesByCard(String cardId) async {
    return await _templateDao.getTemplatesByCard(cardId);
  }

  Future<List<DebtTemplate>> getTemplatesByAmountRange(
      double minAmount, double maxAmount) async {
    return await _templateDao.getTemplatesByAmountRange(minAmount, maxAmount);
  }

  // Categories management
  Future<List<String>> getUniqueCategories() async {
    return await _templateDao.getUniqueCategories();
  }

  List<String> getDefaultCategories() {
    return [
      'Servicios Básicos',
      'Tarjetas de Crédito',
      'Préstamos',
      'Seguros',
      'Suscripciones',
      'Alquiler',
      'Telecomunicaciones',
      'Educación',
      'Salud',
      'Transporte',
      'Otros',
    ];
  }

  // Statistics
  Future<int> getTemplateCount() async {
    return await _templateDao.getTemplateCount();
  }

  Future<double> getTotalAmount() async {
    return await _templateDao.getTotalAmount();
  }

  Future<Map<String, int>> getTemplateCountByCategory() async {
    final templates = await getAllTemplates();
    final Map<String, int> categoryCounts = {};

    for (final template in templates) {
      final category = template.categoria ?? 'Sin Categoría';
      categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
    }

    return categoryCounts;
  }

  Future<Map<String, double>> getTotalAmountByCategory() async {
    final templates = await getAllTemplates();
    final Map<String, double> categoryAmounts = {};

    for (final template in templates) {
      final category = template.categoria ?? 'Sin Categoría';
      categoryAmounts[category] =
          (categoryAmounts[category] ?? 0.0) + template.monto;
    }

    return categoryAmounts;
  }

  // Stream operations for real-time updates
  Stream<List<DebtTemplate>> watchAllTemplates() {
    return _templateDao.watchAllTemplates();
  }

  Stream<DebtTemplate?> watchTemplate(String id) {
    return _templateDao.watchTemplate(id);
  }

  Stream<List<TemplateWithCard>> watchTemplatesWithCards() {
    return _templateDao.watchTemplatesWithCards();
  }

  // Validation methods
  String? validateTemplateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'El nombre de la plantilla es requerido';
    }
    if (name.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    if (name.trim().length > 100) {
      return 'El nombre no puede exceder 100 caracteres';
    }
    return null;
  }

  String? validateAmount(String? amountText) {
    if (amountText == null || amountText.trim().isEmpty) {
      return 'El monto es requerido';
    }

    final amount = double.tryParse(amountText.trim());
    if (amount == null) {
      return 'Ingrese un monto válido';
    }

    if (amount <= 0) {
      return 'El monto debe ser mayor a 0';
    }

    if (amount > 999999.99) {
      return 'El monto no puede exceder 999,999.99';
    }

    return null;
  }

  String? validateCategory(String? category) {
    if (category != null && category.trim().length > 50) {
      return 'La categoría no puede exceder 50 caracteres';
    }
    return null;
  }

  String? validateNotas(String? notas) {
    if (notas != null && notas.trim().length > 500) {
      return 'Las notas no pueden exceder 500 caracteres';
    }
    return null;
  }

  // Utility methods
  Future<bool> templateExists(String id) async {
    final template = await getTemplate(id);
    return template != null;
  }

  Future<bool> isTemplateNameDuplicate(String name, {String? excludeId}) async {
    final templates = await getAllTemplates();
    return templates.any((template) =>
        template.nombre.toLowerCase() == name.toLowerCase() &&
        template.id != excludeId);
  }
}
