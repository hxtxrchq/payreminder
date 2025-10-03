import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/notifications/notification_service.dart';

class NotificationsPreviewScreen extends ConsumerStatefulWidget {
  const NotificationsPreviewScreen({super.key});

  @override
  ConsumerState<NotificationsPreviewScreen> createState() =>
      _NotificationsPreviewScreenState();
}

class _NotificationsPreviewScreenState
    extends ConsumerState<NotificationsPreviewScreen> {
  bool _permissionGranted = true;
  bool _loadingPerm = false;

  @override
  void initState() {
    super.initState();
    _refreshPermission();
  }

  Future<void> _refreshPermission() async {
    final granted =
        await NotificationService.instance.areNotificationsEnabled();
    if (mounted) setState(() => _permissionGranted = granted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Probar notificación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _permissionGranted
                      ? Icons.notifications_active
                      : Icons.notifications_off,
                  color: _permissionGranted ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _permissionGranted
                        ? 'Permiso de notificaciones: Concedido'
                        : 'Permiso de notificaciones: No concedido (Android 13+)',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _permissionGranted || _loadingPerm
                      ? null
                      : () async {
                          setState(() => _loadingPerm = true);
                          await NotificationService.instance
                              .requestNotificationsPermission();
                          setState(() => _loadingPerm = false);
                          await _refreshPermission();
                        },
                  child: _loadingPerm
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Conceder permiso'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Pulsa un botón para ver cómo se vería el aviso de pago.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.visibility_outlined),
                label:
                    const Text('Mostrar notificación de ejemplo (inmediata)'),
                onPressed: () async {
                  await NotificationService.instance.showPaymentReminderNow(
                    id: 'preview:demo',
                    title: 'Recordatorio de pago',
                    body: 'Hoy vence tu pago de S/ 120.00 — "Alquiler"',
                    payload: 'preview:demo',
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notificación enviada')),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.schedule_outlined),
                label: const Text(
                    'Programar en 5 segundos (probar en background)'),
                onPressed: () async {
                  await NotificationService.instance.scheduleInSeconds(
                    id: 'preview:demo5s',
                    title: 'Recordatorio de pago',
                    body: 'Hoy vence tu pago de S/ 120.00 — "Alquiler"',
                    seconds: 5,
                    payload: 'preview:demo5s',
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Programada en 5s. Pulsa Home para mandar la app al fondo y ver la notificación.')),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sugerencia: tras pulsar, envía la app a segundo plano (botón Home) para ver la notificación como heads‑up. ',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Si no aparece: desactiva ahorro de batería para la app y verifica que No molestar permita notificaciones de alta prioridad.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
