import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/sow_model.dart';
import '../controllers/sow_controller.dart';

class SowDetailScreen extends StatefulWidget {
  final String sowId;

  const SowDetailScreen({super.key, required this.sowId});

  @override
  State<SowDetailScreen> createState() => _SowDetailScreenState();
}

class _SowDetailScreenState extends State<SowDetailScreen> {
  final SowController _controller = SowController();

  void _showRegisterBirthDialog(Sow sow) {
    final pigletsController = TextEditingController();
    final weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Registrar Parto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pigletsController,
                decoration: const InputDecoration(labelText: 'Número de lechones'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Peso promedio inicial (kg)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () {
                final pigletsCount = int.tryParse(pigletsController.text);
                final initialWeight = double.tryParse(weightController.text);

                if (pigletsCount != null && initialWeight != null && pigletsCount > 0) {
                  // Call the controller to perform the business logic
                  _controller.registerBirth(sow, pigletsCount, initialWeight);
                  
                  // Handle UI logic here in the view
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$pigletsCount lechones añadidos a engorde.')),
                  );
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Sow>('sows').listenable(),
      builder: (context, Box<Sow> box, _) {
        final sow = box.values.firstWhere((s) => s.id.toString() == widget.sowId);

        return Scaffold(
          appBar: AppBar(title: Text(sow.name)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estado Actual', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(sow.isPregnant ? 'Preñada' : 'En reposo'),
                        if (sow.isPregnant)
                          Text('Fecha de parto estimada: ${sow.estimatedBirthDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Acciones', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    ElevatedButton.icon(
                      onPressed: sow.isPregnant ? null : () => _controller.confirmPregnancy(sow),
                      icon: const Icon(Icons.favorite_border),
                      label: const Text('Confirmar Preñez'),
                    ),
                    ElevatedButton.icon(
                      onPressed: !sow.isPregnant ? null : () => _showRegisterBirthDialog(sow),
                      icon: const Icon(Icons.child_care),
                      label: const Text('Registrar Parto'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
