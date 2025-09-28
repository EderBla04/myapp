import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/fattening_pig_model.dart';
import '../controllers/fattening_pig_controller.dart';

class FatteningPigDetailScreen extends StatefulWidget {
  final String pigId;

  const FatteningPigDetailScreen({super.key, required this.pigId});

  @override
  State<FatteningPigDetailScreen> createState() => _FatteningPigDetailScreenState();
}

class _FatteningPigDetailScreenState extends State<FatteningPigDetailScreen> {
  final EngordaController _controller = EngordaController();

  void _showRecordWeightDialog(FatteningPig pig) {
    final weightController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Registrar Nuevo Peso'),
          content: TextField(
            controller: weightController,
            decoration: const InputDecoration(labelText: 'Peso (kg)'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () {
                final weight = double.tryParse(weightController.text);
                if (weight != null) {
                  _controller.updateWeight(pig.id, weight);
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<FatteningPig>('fattening_pigs').listenable(),
      builder: (context, Box<FatteningPig> box, _) {
        final pig = box.values.firstWhere((p) => p.id.toString() == widget.pigId);

        return Scaffold(
          appBar: AppBar(title: Text(pig.name)),
          body: SingleChildScrollView(
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
                        Text('Información General', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text('Peso actual: ${pig.pesoActual.toStringAsFixed(1)} kg'),
                        Text('Fecha de entrada: ${pig.fechaIngreso.toLocal().toString().split(' ')[0]}'),
                        Text('Origen: ${pig.origen}'),
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
                      onPressed: () => _showRecordWeightDialog(pig),
                      icon: const Icon(Icons.monitor_weight_outlined),
                      label: const Text('Registrar Pesaje'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _controller.deletePig(pig.id);
                        context.go('/');
                      },
                      icon: const Icon(Icons.sell_outlined),
                      label: const Text('Registrar Venta'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Historial de Peso', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                if (pig.weightHistory == null || pig.weightHistory!.isEmpty)
                  const Center(child: Text('Aún no hay registros de peso.')),
                if (pig.weightHistory != null)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pig.weightHistory!.length,
                    itemBuilder: (context, index) {
                      final entry = pig.weightHistory![index];
                      return ListTile(
                        leading: const Icon(Icons.calendar_today_outlined),
                        title: Text('${entry.weight.toStringAsFixed(1)} kg'),
                        subtitle: Text(entry.date.toLocal().toString().split(' ')[0]),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
