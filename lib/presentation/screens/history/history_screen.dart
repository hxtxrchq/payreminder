import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        leading: BackButton(
            onPressed: () =>
                context.canPop() ? context.pop() : context.go('/')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(child: _DateField(label: 'Desde')),
              const SizedBox(width: 12),
              Expanded(child: _DateField(label: 'Hasta')),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Estado'),
            items: const [
              DropdownMenuItem(value: 'ALL', child: Text('Todos')),
              DropdownMenuItem(value: 'PENDING', child: Text('Pendiente')),
              DropdownMenuItem(value: 'PAID', child: Text('Pagado')),
              DropdownMenuItem(value: 'OVERDUE', child: Text('Vencido')),
            ],
            onChanged: (_) {},
          ),
          const SizedBox(height: 16),
          const Text('Totales: S/ 0.00'),
          const SizedBox(height: 24),
          const Center(child: Text('Filtros, totales y lista de pagos.')),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  const _DateField({required this.label});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      readOnly: true,
      onTap: () {},
    );
  }
}
