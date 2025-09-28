import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/fattening_pig_model.dart';
import '../controllers/fattening_pig_controller.dart';
import '../utils/error_handler.dart';

class FatteningPigDetailScreen extends StatefulWidget {
  final String pigId;

  const FatteningPigDetailScreen({super.key, required this.pigId});

  @override
  State<FatteningPigDetailScreen> createState() => _FatteningPigDetailScreenState();
}

class _FatteningPigDetailScreenState extends State<FatteningPigDetailScreen> {
  final FatteningPigController _controller = FatteningPigController();

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
              onPressed: () async {
                final weight = double.tryParse(weightController.text);
                if (weight != null) {
                  await _controller.updateWeight(pig.id, weight);
                  if (mounted) {
                    Navigator.pop(dialogContext);
                    ErrorHandler.showSuccessSnackBar(
                      context, 'Peso actualizado a ${weight.toStringAsFixed(1)} kg'
                    );
                  }
                } else {
                  ErrorHandler.showErrorSnackBar(context, 'Por favor ingrese un valor válido');
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
      valueListenable: _controller.getPigListenable(),
      builder: (context, Box<FatteningPig> box, _) {
        final pig = _controller.getPig(widget.pigId);
        
        if (pig == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cerdo no encontrado')),
            body: const Center(
              child: Text('El cerdo solicitado no existe.'),
            ),
          );
        }

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
                      onPressed: () => _showDeletePigDialog(pig),
                      icon: const Icon(Icons.delete),
                      label: const Text('Eliminar Cerdo'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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

  void _showDeletePigDialog(FatteningPig pig) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 28),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Eliminar Cerdo',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('¿Estás seguro de que deseas eliminar el cerdo "${pig.name}"?'),
              const SizedBox(height: 16),
              const Text(
                'Esta acción no se puede deshacer.',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                await _controller.deletePig(pig.id);
                if (mounted) {
                  Navigator.pop(dialogContext);
                  Navigator.pop(context); // Regresar a la lista de cerdos
                  ErrorHandler.showSuccessSnackBar(
                    context, 'Cerdo "${pig.name}" eliminado'
                  );
                }
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
