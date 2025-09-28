import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/fattening_pig_model.dart';
import '../widgets/fattening_pig_list_item.dart';
import '../controllers/fattening_pig_controller.dart';

class FatteningScreen extends StatefulWidget {
  const FatteningScreen({super.key});

  @override
  State<FatteningScreen> createState() => _FatteningScreenState();
}

class _FatteningScreenState extends State<FatteningScreen> {
  final FatteningPigController _controller = FatteningPigController();

  void _showAddPigDialog() {
    final nameController = TextEditingController();
    final weightController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Añadir Cerdo de Engorde'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre o ID del cerdo'),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Peso inicial (kg)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () {
                final name = nameController.text;
                final weight = double.tryParse(weightController.text);
                if (name.isNotEmpty && weight != null) {
                  _controller.addPig(name, weight);
                  Navigator.pop(context);
                }
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: Hive.box<FatteningPig>('fattening_pigs').listenable(),
        builder: (context, Box<FatteningPig> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text('Aún no has añadido ningún cerdo de engorde.'),
            );
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final pig = box.getAt(index)!;
              return FatteningPigListItem(pig: pig);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPigDialog,
        label: const Text('Añadir Cerdo'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
