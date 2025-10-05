import 'package:flutter/material.dart';

class CardFormScreen extends StatefulWidget {
  final String? cardId;
  const CardFormScreen({super.key, this.cardId});

  @override
  State<CardFormScreen> createState() => _CardFormScreenState();
}

class _CardFormScreenState extends State<CardFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _last4Ctrl = TextEditingController();
  final _colorCtrl = TextEditingController(text: '#27AE60');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.cardId == null ? 'Nueva tarjeta' : 'Editar tarjeta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre (alias)'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _last4Ctrl,
                decoration: const InputDecoration(labelText: 'Últimas 4 (opcional)'),
              ),
              TextFormField(
                controller: _colorCtrl,
                decoration: const InputDecoration(labelText: 'Color (#RRGGBB)'),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: guardar
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}