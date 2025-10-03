import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/formatters/money.dart';
import '../../data/db/app_database.dart';
import '../../data/repos/template_repository.dart';
import '../../data/repos/card_repository.dart';
import 'repository_providers.dart';

// Provider para obtener todas las plantillas
final templatesProvider = StreamProvider<List<DebtTemplate>>((ref) {
  final templateRepository = ref.watch(templateRepositoryProvider);
  return templateRepository.watchAllTemplates();
});

// Provider para obtener plantillas activas
final activeTemplatesProvider = StreamProvider<List<DebtTemplate>>((ref) {
  final templateRepository = ref.watch(templateRepositoryProvider);
  return templateRepository
      .watchAllTemplates()
      .map((templates) => templates.where((t) => !t.isArchived).toList());
});

// Provider para obtener una plantilla específica
final templateProvider =
    StreamProviderFamily<DebtTemplate?, String>((ref, templateId) {
  final templateRepository = ref.watch(templateRepositoryProvider);
  return templateRepository.watchTemplate(templateId);
});

// Provider para estadísticas de plantillas
final templateStatsProvider = FutureProvider<TemplateStats>((ref) async {
  final templateRepository = ref.watch(templateRepositoryProvider);
  final templates = await templateRepository.getAllTemplates();
  final activeTemplates = templates.where((t) => !t.isArchived).toList();
  final archivedTemplates = templates.where((t) => t.isArchived).toList();

  final totalAmount =
      activeTemplates.fold<double>(0.0, (sum, t) => sum + t.monto);

  // Agrupar por categoría
  final Map<String, int> byCategory = {};
  for (final template in activeTemplates) {
    final category = template.categoria ?? 'Sin categoría';
    byCategory[category] = (byCategory[category] ?? 0) + 1;
  }

  return TemplateStats(
    totalTemplates: templates.length,
    activeTemplates: activeTemplates.length,
    archivedTemplates: archivedTemplates.length,
    totalMonthlyAmount: totalAmount,
    categoryCounts: byCategory,
  );
});

// Provider para el formulario de plantillas
final templateFormProvider =
    StateNotifierProvider<TemplateFormNotifier, TemplateFormState>((ref) {
  final templateRepository = ref.watch(templateRepositoryProvider);
  final cardRepository = ref.watch(cardRepositoryProvider);
  return TemplateFormNotifier(templateRepository, cardRepository);
});

// Estado del formulario de plantilla
class TemplateFormState {
  final String? id;
  final String nombre;
  final String? categoria;
  final double monto;
  final String? cardId;
  final String? notas;
  final bool isArchived;
  final bool isLoading;
  final String? error;
  final bool isEditing;

  TemplateFormState({
    this.id,
    this.nombre = '',
    this.categoria,
    this.monto = 0.0,
    this.cardId,
    this.notas,
    this.isArchived = false,
    this.isLoading = false,
    this.error,
    this.isEditing = false,
  });

  TemplateFormState copyWith({
    String? id,
    String? nombre,
    String? categoria,
    double? monto,
    String? cardId,
    String? notas,
    bool? isArchived,
    bool? isLoading,
    String? error,
    bool? isEditing,
  }) {
    return TemplateFormState(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      monto: monto ?? this.monto,
      cardId: cardId ?? this.cardId,
      notas: notas ?? this.notas,
      isArchived: isArchived ?? this.isArchived,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  bool get isValid => nombre.isNotEmpty && monto > 0;
  bool get canSave => isValid && !isLoading;
}

// Notifier para el formulario de plantillas
class TemplateFormNotifier extends StateNotifier<TemplateFormState> {
  final TemplateRepository _templateRepository;
  final CardRepository _cardRepository;

  TemplateFormNotifier(this._templateRepository, this._cardRepository)
      : super(TemplateFormState());

  void updateNombre(String nombre) {
    state = state.copyWith(nombre: nombre, error: null);
  }

  void updateCategoria(String? categoria) {
    state = state.copyWith(categoria: categoria, error: null);
  }

  void updateMonto(double monto) {
    state = state.copyWith(monto: monto, error: null);
  }

  void updateCardId(String? cardId) {
    state = state.copyWith(cardId: cardId, error: null);
  }

  void updateNotas(String? notas) {
    state = state.copyWith(notas: notas, error: null);
  }

  void updateIsArchived(bool isArchived) {
    state = state.copyWith(isArchived: isArchived, error: null);
  }

  void loadTemplate(DebtTemplate template) {
    state = TemplateFormState(
      id: template.id,
      nombre: template.nombre,
      categoria: template.categoria,
      monto: template.monto,
      cardId: template.cardId,
      notas: template.notas,
      isArchived: template.isArchived,
      isEditing: true,
    );
  }

  void clearForm() {
    state = TemplateFormState();
  }

  Future<bool> saveTemplate() async {
    if (!state.canSave) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      if (state.isEditing && state.id != null) {
        // Actualizar plantilla existente
        final success = await _templateRepository.updateTemplate(
          id: state.id!,
          nombre: state.nombre,
          categoria: state.categoria,
          monto: state.monto,
          cardId: state.cardId,
          notas: state.notas,
          isArchived: state.isArchived,
        );

        if (success) {
          clearForm();
          return true;
        } else {
          state = state.copyWith(
              isLoading: false, error: 'Error actualizando la plantilla');
          return false;
        }
      } else {
        // Crear nueva plantilla
        final templateId = await _templateRepository.createTemplate(
          id: 'template_${DateTime.now().millisecondsSinceEpoch}',
          nombre: state.nombre,
          categoria: state.categoria,
          monto: state.monto,
          cardId: state.cardId,
          notas: state.notas,
        );

        if (templateId.isNotEmpty) {
          clearForm();
          return true;
        } else {
          state = state.copyWith(
              isLoading: false, error: 'Error creando la plantilla');
          return false;
        }
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error: $e');
      return false;
    }
  }

  Future<bool> deleteTemplate(String templateId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _templateRepository.deleteTemplate(templateId);

      if (success) {
        clearForm();
        return true;
      } else {
        state = state.copyWith(
            isLoading: false, error: 'Error eliminando la plantilla');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error: $e');
      return false;
    }
  }

  Future<bool> archiveTemplate(String templateId) async {
    try {
      return await _templateRepository.archiveTemplate(templateId);
    } catch (e) {
      state = state.copyWith(error: 'Error archivando: $e');
      return false;
    }
  }

  // Validaciones
  String? validateNombre(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es requerido';
    }
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? validateMonto(double? value) {
    if (value == null || value <= 0) {
      return 'El monto debe ser mayor a 0';
    }
    if (value > 999999) {
      return 'El monto es demasiado alto';
    }
    return null;
  }

  // Métodos de utilidad
  List<String> getCommonCategories() {
    return [
      'Servicios',
      'Transporte',
      'Alimentación',
      'Entretenimiento',
      'Seguros',
      'Préstamos',
      'Tarjetas de Crédito',
      'Hogar',
      'Salud',
      'Educación',
      'Otros',
    ];
  }

  Future<List<Card>> getAvailableCards() async {
    return await _cardRepository.getAllCards();
  }

  String formatMonto(double monto) {
    return formatMoney(monto);
  }
}

// Clase para estadísticas de plantillas
class TemplateStats {
  final int totalTemplates;
  final int activeTemplates;
  final int archivedTemplates;
  final double totalMonthlyAmount;
  final Map<String, int> categoryCounts;

  TemplateStats({
    required this.totalTemplates,
    required this.activeTemplates,
    required this.archivedTemplates,
    required this.totalMonthlyAmount,
    required this.categoryCounts,
  });

  String get mostPopularCategory {
    if (categoryCounts.isEmpty) return 'N/A';
    return categoryCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  double get averageAmount {
    return activeTemplates > 0 ? totalMonthlyAmount / activeTemplates : 0.0;
  }
}
