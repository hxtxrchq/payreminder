import 'package:flutter/material.dart';

class OccurrenceDetailScreen extends StatelessWidget {
  final String occurrenceId;
  const OccurrenceDetailScreen({super.key, required this.occurrenceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ocurrencia $occurrenceId')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detalle de ocurrencia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Monto, estado, tarjeta, recordatorios...'),
            const Spacer(),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {/* TODO: marcar pagado */},
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Marcar pagado'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {/* TODO: deshacer */},
                  child: const Text('Deshacer'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}