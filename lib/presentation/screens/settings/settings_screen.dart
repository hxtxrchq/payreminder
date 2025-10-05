import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../logic/providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final value = settings.nearThreshold.clamp(1, 30);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        leading: BackButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Probar notificación'),
            subtitle: const Text('Pulsa para ver una notificación de ejemplo'),
            onTap: () => context.push('/settings/notifications-preview'),
          ),
          const Divider(height: 24),
          Text(
            'Avisarme cuando falten X días',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  label: '$value',
                  onChanged: (v) => notifier.setNearThreshold(v.round()),
                ),
              ),
              SizedBox(
                width: 48,
                child: Text('$value', textAlign: TextAlign.center),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Leyenda de colores',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _LegendChip(
                  color: Color(0xFF111111), text: 'Pendiente (> X días)'),
              _LegendChip(
                  color: Color(0xFFF4D03F), text: 'Próximo (≤ X y > 0)'),
              _LegendChip(color: Color(0xFFE74C3C), text: 'Hoy / Vencido'),
              _LegendChip(color: Color(0xFF27AE60), text: 'Pagado'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  final Color color;
  final String text;
  const _LegendChip({required this.color, required this.text});
  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(backgroundColor: color),
      label: Text(text),
    );
  }
}
