import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../models/settings_model.dart';

class SettingsRepository {
  static const String boxName = 'settings';
  
  // Obtener box de configuración
  Box<AppSettings> get _settingsBox => Hive.box<AppSettings>(boxName);
  
  // Obtener configuración
  AppSettings getSettings() {
    if (_settingsBox.values.isEmpty) {
      // Valores predeterminados
      return AppSettings(globalPigletPrice: 1500.0, globalKgPrice: 45.0);
    }
    return _settingsBox.values.first;
  }
  
  // Guardar configuración
  Future<void> saveSettings(AppSettings settings) async {
    if (_settingsBox.values.isEmpty) {
      await _settingsBox.add(settings);
    } else {
      // Actualizar la configuración existente
      final existingSettings = _settingsBox.values.first;
      existingSettings
        ..globalPigletPrice = settings.globalPigletPrice
        ..globalKgPrice = settings.globalKgPrice;
      await existingSettings.save();
    }
  }
  
  // Obtener precio global de cerditos
  double getPrecioGlobalCerdito() {
    return getSettings().globalPigletPrice;
  }
  
  // Actualizar precio global de cerditos
  Future<void> updatePrecioGlobalCerdito(double nuevoPrecio) async {
    final settings = getSettings();
    settings.globalPigletPrice = nuevoPrecio;
    await saveSettings(settings);
  }
  
  // Obtener precio global por kilo
  double getPrecioGlobalPorKilo() {
    return getSettings().globalKgPrice;
  }
  
  // Actualizar precio global por kilo
  Future<void> updatePrecioGlobalPorKilo(double nuevoPrecio) async {
    final settings = getSettings();
    settings.globalKgPrice = nuevoPrecio;
    await saveSettings(settings);
  }
  
  // Obtener ValueListenable para actualización reactiva
  ValueListenable<Box<AppSettings>> getListenable() {
    return Hive.box<AppSettings>(boxName).listenable();
  }
}