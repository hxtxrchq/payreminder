import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'repository_providers.dart';

class SettingsState {
  final int nearThreshold;
  final bool loading;
  final String? error;

  const SettingsState(
      {required this.nearThreshold, this.loading = false, this.error});

  SettingsState copyWith({int? nearThreshold, bool? loading, String? error}) =>
      SettingsState(
        nearThreshold: nearThreshold ?? this.nearThreshold,
        loading: loading ?? this.loading,
        error: error,
      );
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  static const _kNearKey = 'near_threshold_days';
  final Ref _ref;

  SettingsNotifier(this._ref) : super(const SettingsState(nearThreshold: 5)) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final prefs = await SharedPreferences.getInstance();
      final v = prefs.getInt(_kNearKey) ?? 5;
      state = state.copyWith(nearThreshold: v, loading: false);
      // Apply on load (optional): recalc statuses
      await _recalculateStatuses(v);
    } catch (e) {
      state = state.copyWith(
          loading: false, error: 'No se pudo cargar ajustes: $e');
    }
  }

  Future<void> setNearThreshold(int value) async {
    state = state.copyWith(nearThreshold: value, loading: true, error: null);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kNearKey, value);
      await _recalculateStatuses(value);
      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: 'No se pudo guardar: $e');
    }
  }

  Future<void> _recalculateStatuses(int near) async {
    final repo = _ref.read(occurrenceRepositoryProvider);
    // Trigger recalculation in DB using repository capability if available
    try {
      await repo.updateAllStatuses(nearThreshold: near);
    } catch (_) {
      // Ignore silently if method not implemented, UI will still refresh based on logic
    }
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(ref);
});
