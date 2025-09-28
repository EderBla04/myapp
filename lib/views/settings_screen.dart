import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/settings_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final settingsBox = Hive.box<AppSettings>('settings');
  late TextEditingController _pigletPriceController;
  late TextEditingController _kgPriceController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with values from Hive, or defaults.
    final settings = settingsBox.get(0, defaultValue: AppSettings(globalPigletPrice: 50.0, globalKgPrice: 2.5));
    _pigletPriceController = TextEditingController(text: settings!.globalPigletPrice.toString());
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

  void _saveSettings() {
    final double pigletPrice = double.tryParse(_pigletPriceController.text) ?? 50.0;
    final double kgPrice = double.tryParse(_kgPriceController.text) ?? 2.5;

    final newSettings = AppSettings(
      globalPigletPrice: pigletPrice,
      globalKgPrice: kgPrice,
    );

    // Hive uses a single entry for settings, with key 0.
    settingsBox.put(0, newSettings);

    // Show confirmation and pop
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ajustes guardados correctamente.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _pigletPriceController.dispose();
    _kgPriceController.dispose();
    super.dispose();
  }
}
