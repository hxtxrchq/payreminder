import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/save_debt_usecase.dart';

class SaveDebtState {
  final bool loading;
  final String? error;
  final String? templateId;
  const SaveDebtState({this.loading = false, this.error, this.templateId});
  SaveDebtState copyWith({bool? loading, String? error, String? templateId}) =>
      SaveDebtState(
        loading: loading ?? this.loading,
        error: error,
        templateId: templateId ?? this.templateId,
      );
}

class SaveDebtController extends StateNotifier<SaveDebtState> {
  final SaveDebtUseCase _useCase;
  SaveDebtController(this._useCase) : super(const SaveDebtState());

  Future<String?> save({
    required DebtBasicData basic,
    required DebtType type,
    DateTime? punctualDueDate,
    RecurrenceData? recurrence,
    required List<int> offsets,
  }) async {
    state = state.copyWith(loading: true, error: null, templateId: null);
    try {
      final result = await _useCase.save(
        basic: basic,
        type: type,
        punctualDueDate: punctualDueDate,
        recurrence: recurrence,
        offsets: offsets,
      );
      state = state.copyWith(loading: false, templateId: result.templateId);
      return result.templateId;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return null;
    }
  }
}

final saveDebtControllerProvider =
    StateNotifierProvider<SaveDebtController, SaveDebtState>((ref) {
  return SaveDebtController(SaveDebtUseCase(ref));
});
