import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/sow_model.dart';
import '../widgets/sow_list_item.dart';
import '../controllers/sow_controller.dart';

class BreedingScreen extends StatefulWidget {
  const BreedingScreen({super.key});

  @override
  State<BreedingScreen> createState() => _BreedingScreenState();
}

class _BreedingScreenState extends State<BreedingScreen> {
  final SowController _controller = SowController();

  void _showAddSowDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Añadir Nueva Cerda'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nombre o ID de la cerda'),
            autofocus: true,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  _controller.addSow(nameController.text);
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
        valueListenable: Hive.box<Sow>('sows').listenable(),
        builder: (context, Box<Sow> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text('Aún no has añadido ninguna cerda de cría.'),
            );
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final sow = box.getAt(index)!;
              return SowListItem(sow: sow);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSowDialog,
        label: const Text('Añadir Cerda'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
