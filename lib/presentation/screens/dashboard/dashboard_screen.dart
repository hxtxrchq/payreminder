import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// Use alias to access month-focused providers
import '../../../logic/providers/occurrence_providers.dart' as op;
import '../../../app/formatters/money.dart';
import '../../../logic/providers/template_providers.dart';
import '../../../logic/providers/summary_providers.dart';
import '../../../domain/models/month_kpis.dart';
import '../../../data/db/occurrence_dao.dart' as od;
import '../../../logic/providers/month_counts_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardStats = ref.watch(op.dashboardStatsProvider);
    final templateStats = ref.watch(templateStatsProvider);
    final monthStart = ref.watch(op.focusedMonthProvider);
    final monthKpis = ref.watch(op.monthKpisProvider(monthStart));

    return Scaffold(
      appBar: AppBar(
        title: const Text('PayReminder — Dashboard'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(op.dashboardStatsProvider);
          ref.invalidate(templateStatsProvider);
          ref.invalidate(monthSummaryProvider);
          ref.invalidate(monthCountsProvider);
          ref.invalidate(op.monthKpisProvider(monthStart));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(context),
              const SizedBox(height: 24),

              // Estadísticas principales
              dashboardStats.when(
                data: (stats) => _buildMainStats(context, stats, monthKpis),
                loading: () => const _LoadingCard(height: 200),
                error: (error, stack) => _ErrorCard(error: error.toString()),
              ),
              const SizedBox(height: 16),

              // Acciones rápidas (grid 2x2)
              _buildQuickActionsGrid(context),
              const SizedBox(height: 16),

              // Bloque Deudas (antes Plantillas)
              templateStats.when(
                data: (stats) => _buildDebtsBlock(context, stats),
                loading: () => const _LoadingCard(height: 150),
                error: (error, stack) => _ErrorCard(error: error.toString()),
              ),
              const SizedBox(height: 16),

              // Lista de próximos pagos (Top 3)
              _buildUpcomingPayments(context, ref),
              const SizedBox(height: 16),
              _buildManageBlocks(context),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/template/new'),
        label: const Text('Nuevo recordatorio de pago'),
        icon: const Icon(Icons.add_alert),
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _QuickAction(
                icon: Icons.calendar_month,
                label: 'Calendario',
                onTap: () => context.go('/calendar')),
            _QuickAction(
                icon: Icons.add_alert,
                label: 'Nuevo recordatorio de pago',
                onTap: () => context.go('/template/new')),
            _QuickAction(
                icon: Icons.history,
                label: 'Historial',
                onTap: () => context.go('/history')),
            _QuickAction(
                icon: Icons.settings,
                label: 'Ajustes',
                onTap: () => context.go('/settings')),
          ],
        ),
      ),
    );
  }

  Widget _buildDebtsBlock(BuildContext context, TemplateStats stats) {
    return InkWell(
      onTap: () => context.go('/debts'),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.account_balance_wallet,
                      size: 20, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    'Deudas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Activas: ${stats.activeTemplates}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Monto mensual estimado: ${formatMoney(stats.totalMonthlyAmount)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingPayments(BuildContext context, WidgetRef ref) {
    final upcoming = ref.watch(op.upcomingOccurrencesWithDetailsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.schedule,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Próximos Pagos',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            upcoming.when(
              data: (occurrences) {
                if (occurrences.isEmpty) {
                  return const _EmptyState(
                    message: 'No tienes pagos pendientes',
                    icon: Icons.check_circle_outline,
                  );
                }

                return Column(
                  children: [
                    ...occurrences.map((occ) => _UpcomingPaymentTile(occ: occ)),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => context.go('/calendar'),
                        child: const Text('Ver calendario'),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const _LoadingList(itemCount: 3),
              error: (error, stack) => _ErrorCard(error: error.toString()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManageBlocks(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _QuickAction(
              icon: Icons.category_outlined,
              label: 'Gestionar categorías',
              onTap: () => context.push('/categories'),
            ),
            _QuickAction(
              icon: Icons.credit_card,
              label: 'Gestionar métodos de pago',
              onTap: () => context.push('/payment-methods'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData greetingIcon;

    if (hour < 12) {
      greeting = 'Buenos días';
      greetingIcon = Icons.wb_sunny;
    } else if (hour < 18) {
      greeting = 'Buenas tardes';
      greetingIcon = Icons.wb_cloudy;
    } else {
      greeting = 'Buenas noches';
      greetingIcon = Icons.nightlight_round;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(greetingIcon,
                    size: 32, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  greeting,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Gestiona tus pagos de manera inteligente',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainStats(BuildContext context, op.DashboardStats stats,
      AsyncValue<MonthKpis> kpis) {
    final mk = kpis.asData?.value;
    final pendingAmount = mk?.pendingAmount ?? stats.totalPendingAmount;
    final paidAmount = mk?.paidAmount ?? stats.totalPaidAmount;
    final overdueAmount = mk?.overdueAmount ?? stats.totalOverdueAmount;
    final pendingCount = mk?.pendingCount ?? stats.pendingCount;
    final paidCount = mk?.paidCount ?? stats.paidCount;
    final overdueCount = mk?.overdueCount ?? stats.overdueCount;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Resumen del Mes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    title: 'Pendientes',
                    value: pendingCount.toString(),
                    subtitle: formatMoney(pendingAmount),
                    color: Colors.orange,
                    icon: Icons.pending_actions,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    title: 'Pagados',
                    value: paidCount.toString(),
                    subtitle: formatMoney(paidAmount),
                    color: Colors.green,
                    icon: Icons.check_circle,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    title: 'Vencidos',
                    value: overdueCount.toString(),
                    subtitle: formatMoney(overdueAmount),
                    color: Colors.red,
                    icon: Icons.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (stats.hasPaymentsDueToday || stats.hasOverduePayments) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: stats.hasOverduePayments
                      ? Colors.red.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: stats.hasOverduePayments
                        ? Colors.red.withOpacity(0.3)
                        : Colors.orange.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      stats.hasOverduePayments ? Icons.error : Icons.today,
                      color:
                          stats.hasOverduePayments ? Colors.red : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        stats.statusSummary,
                        style: TextStyle(
                          color: stats.hasOverduePayments
                              ? Colors.red
                              : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        stats.statusSummary,
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction(
      {required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Widgets auxiliares
class _StatItem extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingPaymentTile extends StatelessWidget {
  final od.OccurrenceWithDetails occ;
  const _UpcomingPaymentTile({required this.occ});

  @override
  Widget build(BuildContext context) {
    final occurrence = occ.occurrence;
    final dueDate = DateTime.fromMillisecondsSinceEpoch(occurrence.fechaDue);
    Color stateColor(String s) {
      switch (s) {
        case 'OVERDUE':
        case 'DUE_TODAY':
          return const Color(0xFFE74C3C);
        case 'NEAR':
          return const Color(0xFFF4D03F);
        case 'PAID':
          return const Color(0xFF27AE60);
        default:
          return const Color(0xFF111111); // PENDING
      }
    }

    final statusColor = stateColor(occurrence.estado);
    final statusIcon = occurrence.estado == 'PAID'
        ? Icons.check_circle
        : (occurrence.estado == 'OVERDUE' || occurrence.estado == 'DUE_TODAY')
            ? Icons.warning
            : Icons.schedule;
    final statusText = () {
      switch (occurrence.estado) {
        case 'PAID':
          return 'Pagado';
        case 'OVERDUE':
          return 'Vencido';
        case 'DUE_TODAY':
          return 'Vence hoy';
        case 'NEAR':
          return 'Próximo';
        default:
          return 'Pendiente';
      }
    }();

    final title = occ.template.nombre;
    final pm = occ.paymentMethod?.alias;
    final subtitle = pm != null ? '$statusText · $pm' : statusText;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(statusIcon, color: statusColor, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatMoney(occurrence.monto),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '${dueDate.day}/${dueDate.month}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        onTap: () => context.go('/calendar'),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  final double height;

  const _LoadingCard({required this.height});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: height,
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  final int itemCount;

  const _LoadingList({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: SizedBox()),
            title: Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            subtitle: Container(
              height: 12,
              width: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String error;

  const _ErrorCard({required this.error});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 8),
            Text(
              'Error cargando datos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              error,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const _EmptyState({
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
