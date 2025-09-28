import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';
import '../utils/error_handler.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _settingsController = SettingsController();
  late TextEditingController _pigletPriceController;
  late TextEditingController _kgPriceController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with values from the controller
    final settings = _settingsController.getSettings();
    _pigletPriceController = TextEditingController(text: settings.globalPigletPrice.toString());
    _kgPriceController = TextEditingController(text: settings.globalKgPrice.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes de Precios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Precios Globales',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Estos valores se usarán para calcular las ganancias estimadas.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            
            // Piglet Price
            TextField(
              controller: _pigletPriceController,
              decoration: const InputDecoration(
                labelText: 'Precio por Lechón (Crianza)',
                prefixText: 'S/ ',
                border: OutlineInputBorder(),
                helperText: 'Ganancia por cada lechón nacido y vendido.',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            
            const SizedBox(height: 24),

            // Price per Kg
            TextField(
              controller: _kgPriceController,
              decoration: const InputDecoration(
                labelText: 'Precio por Kilo (Engorda)',
                prefixText: 'S/ ',
                border: OutlineInputBorder(),
                helperText: 'Precio de venta por cada kilogramo de peso.',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),

            const Spacer(),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.save_alt_rounded),
                label: const Text('Guardar Cambios'),
                onPressed: _saveSettings,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _saveSettings() async {
    final double pigletPrice = double.tryParse(_pigletPriceController.text) ?? 50.0;
    final double kgPrice = double.tryParse(_kgPriceController.text) ?? 2.5;

    try {
      await _settingsController.saveSettingsValues(
        pigletPrice: pigletPrice,
        kgPrice: kgPrice,
      );
      
      if (mounted) {
        // Show confirmation and pop
        ErrorHandler.showSuccessSnackBar(
          context, 'Ajustes guardados correctamente.'
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(
          context, 'Error al guardar configuraciones: ${e.toString()}'
        );
      }
    }
  }

  @override
  void dispose() {
    _pigletPriceController.dispose();
    _kgPriceController.dispose();
    super.dispose();
  }
}
