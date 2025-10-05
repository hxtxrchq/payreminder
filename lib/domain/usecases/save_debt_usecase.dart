import 'package:uuid/uuid.dart';
import '../../data/repos/template_repository.dart';
import '../../data/repos/recurrence_repository.dart';
import '../../data/repos/reminder_rule_repository.dart';
import '../../logic/providers/repository_providers.dart';
import '../../logic/providers/settings_providers.dart';
import '../../logic/providers/usecase_providers.dart';
import '../../data/repos/occurrence_repository.dart';
import '../../logic/providers/database_providers.dart';
import '../../data/db/app_database.dart';

enum DebtType { punctual, recurrent }

class DebtBasicData {
  final String? id; // null when creating new
  final String nombre;
  final double monto;
  final String? categoria;
  final String? categoryId; // nueva tabla categories
  final String? cardId;
  final String? paymentMethodId;
  final String? notas;
  final bool isArchived;
  // Intereses
  final bool hasInterest;
  final String? interestType; // FIXED_INSTALLMENTS | FLEXIBLE
  final double? interestRateMonthly; // % mensual
  final int? termMonths; // para cuota fija
  final int? graceMonths;
  final double? currentBalance; // saldo actual (si aplica)
  DebtBasicData({
    this.id,
    required this.nombre,
    required this.monto,
    this.categoria,
    this.categoryId,
    this.cardId,
    this.paymentMethodId,
    this.notas,
    this.isArchived = false,
    this.hasInterest = false,
    this.interestType,
    this.interestRateMonthly,
    this.termMonths,
    this.graceMonths,
    this.currentBalance,
  });
}

class RecurrenceData {
  final String
      tipo; // MONTHLY_BY_DOM, WEEKLY_BY_DOW, YEARLY_BY_DOM, EVERY_N_DAYS
  final int? diaMes;
  final int? dow;
  final int? everyNDays;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final int? totalCiclos;
  RecurrenceData({
    required this.tipo,
    this.diaMes,
    this.dow,
    this.everyNDays,
    required this.fechaInicio,
    this.fechaFin,
    this.totalCiclos,
  });
}

class SaveDebtResult {
  final String templateId;
  SaveDebtResult(this.templateId);
}

class SaveDebtUseCase {
  final TemplateRepository _templateRepo;
  final RecurrenceRepository _recurrenceRepo;
  final OccurrenceRepository _occurrenceRepo;
  final ReminderRuleRepository _reminderRepo;
  final dynamic _ref; // Ref o ProviderContainer para tests

  SaveDebtUseCase(this._ref)
      : _templateRepo = _ref.read(templateRepositoryProvider),
        _recurrenceRepo = _ref.read(recurrenceRepositoryProvider),
        _occurrenceRepo = _ref.read(occurrenceRepositoryProvider),
        _reminderRepo = _ref.read(reminderRuleRepositoryProvider);

  Future<SaveDebtResult> save({
    required DebtBasicData basic,
    required DebtType type,
    DateTime? punctualDueDate,
    RecurrenceData? recurrence,
    required List<int> offsets,
  }) async {
    final uuid = const Uuid();
    final db = _ref.read(databaseProvider);

    // Prepare common values
    final templateId =
        basic.id ?? 'template_${DateTime.now().millisecondsSinceEpoch}';
    final uniqueOffsets = offsets.toSet().toList();
    final nearThreshold = _ref.read(settingsProvider).nearThreshold;
    final isEdit = basic.id != null;

    // Preload previous data for edit: rules and occurrences. We'll use them after commit for notifications.
    List<int> prevOffsets = const [];
    final List<String> willCancelOccNotificationIds = [];
    Occurrence?
        punctualOccToUpdate; // if we decide to update instead of recreate
    // Holders to pass data from inside transaction to post-commit notification phase
    String? newPunctualOccId;
    DateTime? newPunctualOccDue;
    List<OccurrenceData> newRecurrentOccs = [];

    if (isEdit) {
      final prevRules =
          await _reminderRepo.getReminderRulesByTemplate(templateId);
      prevOffsets = prevRules.map((r) => r.offsetDays).toList();

      final allOccs =
          await _occurrenceRepo.getOccurrencesByTemplate(templateId);
      // Determine future-or-today and not-paid occurrences to be canceled/removed
      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);
      final futureOrTodayNotPaid = allOccs.where((occ) {
        final due = DateTime.fromMillisecondsSinceEpoch(occ.fechaDue);
        final isFutureOrToday = !due.isBefore(todayOnly);
        final isPaid = occ.estado == 'PAID';
        return isFutureOrToday && !isPaid;
      }).toList();

      // For punctual debt edit: if there's a not-paid occurrence, prefer updating it instead of recreating
      if (type == DebtType.punctual) {
        if (futureOrTodayNotPaid.isNotEmpty) {
          // Choose the nearest due occurrence to update
          futureOrTodayNotPaid.sort((a, b) => a.fechaDue.compareTo(b.fechaDue));
          punctualOccToUpdate = futureOrTodayNotPaid.first;
          // Mark all others (if any) to cancel notifications and delete
          for (final occ in futureOrTodayNotPaid.skip(1)) {
            willCancelOccNotificationIds.add(occ.id);
          }
        }
        // If none to update (all paid or only past), we'll create a new one later.
      } else {
        // recurrent: all future-or-today not-paid will be deleted/recreated
        for (final occ in futureOrTodayNotPaid) {
          willCancelOccNotificationIds.add(occ.id);
        }
      }
    }

    // Execute DB changes inside a single transaction
    await db.transaction(() async {
      // Upsert template
      if (!isEdit) {
        await _templateRepo.createTemplate(
          id: templateId,
          nombre: basic.nombre,
          categoria: basic.categoria,
          monto: basic.monto,
          cardId: basic.cardId,
          paymentMethodId: basic.paymentMethodId,
          hasInterest: basic.hasInterest,
          interestType: basic.interestType,
          interestRateMonthly: basic.interestRateMonthly,
          termMonths: basic.termMonths,
          graceMonths: basic.graceMonths,
          categoryId: basic.categoryId,
          currentBalance:
              basic.hasInterest ? (basic.currentBalance ?? basic.monto) : null,
          notas: basic.notas,
          isArchived: basic.isArchived,
        );
      } else {
        await _templateRepo.updateTemplate(
          id: templateId,
          nombre: basic.nombre,
          categoria: basic.categoria,
          monto: basic.monto,
          cardId: basic.cardId,
          paymentMethodId: basic.paymentMethodId,
          hasInterest: basic.hasInterest,
          interestType: basic.interestType,
          interestRateMonthly: basic.interestRateMonthly,
          termMonths: basic.termMonths,
          graceMonths: basic.graceMonths,
          categoryId: basic.categoryId,
          currentBalance:
              basic.hasInterest ? (basic.currentBalance ?? basic.monto) : null,
          notas: basic.notas,
          isArchived: basic.isArchived,
        );
        // Remove previous recurrences (they will be recreated for recurrent)
        await _recurrenceRepo.deleteRecurrencesByTemplate(templateId);
      }

      // Replace reminder rules with new offsets
      await _reminderRepo.replaceReminderRulesForTemplate(
          templateId, uniqueOffsets);

      // Occurrences create/update by type
      if (type == DebtType.punctual) {
        final due = punctualDueDate!;
        final status =
            _occurrenceRepo.calculateStatus(due, nearThreshold: nearThreshold);
        final normalizedDue = DateTime(due.year, due.month, due.day);

        if (isEdit && punctualOccToUpdate != null) {
          // Update existing non-paid occurrence, avoid duplication
          await _occurrenceRepo.updateOccurrence(
            id: punctualOccToUpdate.id,
            fechaDue: normalizedDue,
            monto: basic.monto,
            estado: status,
            cardId: basic.cardId,
          );

          // Delete any extra future non-paid occurrences (rare inconsistent state)
          // Note: Those IDs are already in willCancelOccNotificationIds
          for (final occId in willCancelOccNotificationIds) {
            await _occurrenceRepo.deleteOccurrence(occId);
          }
        } else {
          // Create new occurrence (either new template or previous punctual was already paid)
          final occId = uuid.v4();
          await _occurrenceRepo.createOccurrence(
            id: occId,
            templateId: templateId,
            fechaDue: normalizedDue,
            monto: basic.monto,
            estado: status,
            cardId: basic.cardId,
          );
          // Track for scheduling after commit
          // Use a temp list holder by reusing willCancelOccNotificationIds as container would be confusing; we'll schedule later using local var outside.
          // We'll return occId via closure capture
          // Not supported: returning from transaction. We'll instead set a mutable holder
          newPunctualOccId = occId;
          newPunctualOccDue = normalizedDue;
        }
      } else {
        // Recurrente: delete future non-paid occurrences and recreate from recurrence rules
        if (isEdit) {
          for (final occId in willCancelOccNotificationIds) {
            await _occurrenceRepo.deleteOccurrence(occId);
          }
        }

        final r = recurrence!;
        final recId = 'rec_${DateTime.now().millisecondsSinceEpoch}';
        await _recurrenceRepo.createRecurrence(
          id: recId,
          templateId: templateId,
          tipo: r.tipo,
          diaMes: r.diaMes,
          dow: r.dow,
          everyNDays: r.everyNDays,
          fechaInicio: DateTime(
              r.fechaInicio.year, r.fechaInicio.month, r.fechaInicio.day),
          fechaFin: r.fechaFin != null
              ? DateTime(r.fechaFin!.year, r.fechaFin!.month, r.fechaFin!.day)
              : null,
          totalCiclos: r.totalCiclos,
        );

        final endDate =
            r.fechaFin ?? DateTime.now().add(const Duration(days: 180));
        final dates = _generateRecurrenceDates(r,
            endDate: endDate, maxOccurrences: r.totalCiclos ?? 100);
        final toCreate = <OccurrenceData>[];
        for (final d in dates) {
          final status =
              _occurrenceRepo.calculateStatus(d, nearThreshold: nearThreshold);
          toCreate.add(OccurrenceData(
            id: uuid.v4(),
            templateId: templateId,
            fechaDue: DateTime(d.year, d.month, d.day),
            monto: basic.monto,
            estado: status,
            cardId: basic.cardId,
          ));
        }
        await _occurrenceRepo.createOccurrences(toCreate);
        newRecurrentOccs = toCreate; // for scheduling after commit
      }
    });

    // After successful commit: handle notifications and statuses
    // Cancel previous notifications (edit only)
    if (isEdit && prevOffsets.isNotEmpty) {
      // If we updated punctual occurrence, also cancel its previous reminders
      if (punctualOccToUpdate != null) {
        await _ref
            .read(notificationServiceProvider)
            .cancelOccurrenceReminders(punctualOccToUpdate.id, prevOffsets);
      }
      for (final occId in willCancelOccNotificationIds) {
        await _ref
            .read(notificationServiceProvider)
            .cancelOccurrenceReminders(occId, prevOffsets);
      }
    }

    // Schedule new notifications based on new state
    if (type == DebtType.punctual) {
      final due = punctualOccToUpdate != null
          ? DateTime(
              newPunctualOccDue?.year ?? punctualDueDate!.year,
              newPunctualOccDue?.month ?? punctualDueDate!.month,
              newPunctualOccDue?.day ?? punctualDueDate!.day)
          : punctualDueDate!;
      final idToUse = punctualOccToUpdate?.id ?? newPunctualOccId!;
      for (final o in uniqueOffsets) {
        await _ref.read(notificationServiceProvider).scheduleOccurrenceReminder(
              occurrenceId: idToUse,
              title: 'Recordatorio de pago: ${basic.nombre}',
              body: 'Vence el ${_formatDate(due)}',
              dueDateLocal: due,
              offsetDays: o,
              hour: 9,
              minute: 0,
            );
      }
    } else {
      for (final od in newRecurrentOccs) {
        for (final o in uniqueOffsets) {
          await _ref
              .read(notificationServiceProvider)
              .scheduleOccurrenceReminder(
                occurrenceId: od.id,
                title: 'Recordatorio de pago: ${basic.nombre}',
                body: 'Vence el ${_formatDate(od.fechaDue)}',
                dueDateLocal: od.fechaDue,
                offsetDays: o,
                hour: 9,
                minute: 0,
              );
        }
      }
    }

    try {
      await _occurrenceRepo.updateAllStatuses(nearThreshold: nearThreshold);
    } catch (_) {}

    return SaveDebtResult(templateId);
  }

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  List<DateTime> _generateRecurrenceDates(
    RecurrenceData rec, {
    required DateTime endDate,
    int maxOccurrences = 100,
  }) {
    final List<DateTime> dates = [];
    DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
    var current = dateOnly(rec.fechaInicio);
    var generated = 0;
    final endOnly = dateOnly(endDate);
    while (!current.isAfter(endOnly) && generated < maxOccurrences) {
      dates.add(current); // incluye fecha de inicio si cae en rango (ej. hoy)
      generated++;

      switch (rec.tipo) {
        case 'MONTHLY_BY_DOM':
          final dom = rec.diaMes ?? current.day;
          var next = DateTime(current.year, current.month + 1, dom);
          if (next.month != (current.month % 12) + 1) {
            // Use last day of month
            next = DateTime(current.year, current.month + 2, 0);
          }
          current = next;
          break;
        case 'WEEKLY_BY_DOW':
          final targetDow = rec.dow ?? current.weekday;
          final diff = (targetDow - current.weekday + 7) % 7;
          current = current.add(Duration(days: diff == 0 ? 7 : diff));
          break;
        case 'YEARLY_BY_DOM':
          final dom = rec.diaMes ?? current.day;
          current = DateTime(current.year + 1, current.month, dom);
          break;
        case 'EVERY_N_DAYS':
          final n = rec.everyNDays ?? 1;
          current = current.add(Duration(days: n));
          break;
        default:
          return dates;
      }
    }
    return dates.map(dateOnly).toList();
  }
}
