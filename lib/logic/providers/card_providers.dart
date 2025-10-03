import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/db/app_database.dart';
import '../../data/repos/card_repository.dart';
import 'repository_providers.dart';

// Provider para obtener todas las tarjetas
final cardsProvider = StreamProvider<List<Card>>((ref) {
  final cardRepository = ref.watch(cardRepositoryProvider);
  return cardRepository.watchAllCards();
});

// Provider para obtener una tarjeta específica
final cardProvider = StreamProviderFamily<Card?, String>((ref, cardId) {
  final cardRepository = ref.watch(cardRepositoryProvider);
  return cardRepository.watchCard(cardId);
});

// Provider para crear/editar tarjetas - Estado del formulario
final cardFormProvider = StateNotifierProvider<CardFormNotifier, CardFormState>((ref) {
  final cardRepository = ref.watch(cardRepositoryProvider);
  return CardFormNotifier(cardRepository);
});

// Estado del formulario de tarjeta (ajustado al esquema real)
class CardFormState {
  final String? id;
  final String nombre;
  final String? ultimas4;
  final String? color;
  final bool isLoading;
  final String? error;
  final bool isEditing;

  CardFormState({
    this.id,
    this.nombre = '',
    this.ultimas4,
    this.color,
    this.isLoading = false,
    this.error,
    this.isEditing = false,
  });

  CardFormState copyWith({
    String? id,
    String? nombre,
    String? ultimas4,
    String? color,
    bool? isLoading,
    String? error,
    bool? isEditing,
  }) {
    return CardFormState(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      ultimas4: ultimas4 ?? this.ultimas4,
      color: color ?? this.color,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  bool get isValid => nombre.isNotEmpty;
  bool get canSave => isValid && !isLoading;
}

// Notifier para manejar el estado del formulario de tarjetas
class CardFormNotifier extends StateNotifier<CardFormState> {
  final CardRepository _cardRepository;

  CardFormNotifier(this._cardRepository) : super(CardFormState());

  void updateNombre(String nombre) {
    state = state.copyWith(nombre: nombre, error: null);
  }

  void updateUltimas4(String? ultimas4) {
    state = state.copyWith(ultimas4: ultimas4, error: null);
  }

  void updateColor(String? color) {
    state = state.copyWith(color: color, error: null);
  }

  void loadCard(Card card) {
    state = CardFormState(
      id: card.id,
      nombre: card.nombre,
      ultimas4: card.ultimas4,
      color: card.color,
      isEditing: true,
    );
  }

  void clearForm() {
    state = CardFormState();
  }

  Future<bool> saveCard() async {
    if (!state.canSave) return false;

    state = state.copyWith(isLoading: true, error: null);

    try {
      if (state.isEditing && state.id != null) {
        // Actualizar tarjeta existente
        final success = await _cardRepository.updateCard(
          id: state.id!,
          nombre: state.nombre,
          ultimas4: state.ultimas4,
          color: state.color,
        );

        if (success) {
          clearForm();
          return true;
        } else {
          state = state.copyWith(isLoading: false, error: 'Error actualizando la tarjeta');
          return false;
        }
      } else {
        // Crear nueva tarjeta
        final cardId = await _cardRepository.createCard(
          id: 'card_${DateTime.now().millisecondsSinceEpoch}',
          nombre: state.nombre,
          ultimas4: state.ultimas4,
          color: state.color,
        );

        if (cardId.isNotEmpty) {
          clearForm();
          return true;
        } else {
          state = state.copyWith(isLoading: false, error: 'Error creando la tarjeta');
          return false;
        }
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error: $e');
      return false;
    }
  }

  Future<bool> deleteCard(String cardId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _cardRepository.deleteCard(cardId);
      
      if (success) {
        clearForm();
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Error eliminando la tarjeta');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error: $e');
      return false;
    }
  }

  String? validateNombre(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es requerido';
    }
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    return null;
  }

  String? validateUltimas4(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length != 4 || !RegExp(r'^\d{4}$').hasMatch(value)) {
        return 'Deben ser exactamente 4 dígitos';
      }
    }
    return null;
  }

  String? validateColor(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(value)) {
        return 'El color debe estar en formato #RRGGBB';
      }
    }
    return null;
  }

  List<String> getPredefinedColors() {
    return [
      '#2196F3', // Blue
      '#F44336', // Red  
      '#4CAF50', // Green
      '#FF9800', // Orange
      '#9C27B0', // Purple
      '#607D8B', // Blue Grey
      '#795548', // Brown
      '#E91E63', // Pink
    ];
  }

  String getCardDisplayName(Card card) {
    if (card.ultimas4 != null && card.ultimas4!.isNotEmpty) {
      return '${card.nombre} (****${card.ultimas4})';
    }
    return card.nombre;
  }
}