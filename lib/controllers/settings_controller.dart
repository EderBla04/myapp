import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/settings_model.dart';
import '../data/repositories/settings_repository.dart';

class SettingsController {
  final SettingsRepository _settingsRepository = SettingsRepository();
  
  // Obtener configuraciones
  AppSettings getSettings() {
    return _settingsRepository.getSettings();
  }
  
  // Guardar configuraciones
  Future<void> saveSettings(AppSettings settings) async {
    await _settingsRepository.saveSettings(settings);
  }
  
  // Guardar configuraciones con valores individuales
  Future<void> saveSettingsValues({
    required double pigletPrice,
    required double kgPrice,
  }) async {
    final settings = AppSettings(
      globalPigletPrice: pigletPrice,
      globalKgPrice: kgPrice,
    );
    await _settingsRepository.saveSettings(settings);
  }
  
  // Obtener precio global por cerdito
  double getPigletPrice() {
    return _settingsRepository.getPrecioGlobalCerdito();
  }
  
  // Actualizar precio global por cerdito
  Future<void> updatePigletPrice(double newPrice) async {
    await _settingsRepository.updatePrecioGlobalCerdito(newPrice);
  }
  
  // Obtener precio global por kilo
  double getKgPrice() {
    return _settingsRepository.getPrecioGlobalPorKilo();
  }
  
  // Actualizar precio global por kilo
  Future<void> updateKgPrice(double newPrice) async {
    await _settingsRepository.updatePrecioGlobalPorKilo(newPrice);
  }
  
  // Obtener ValueListenable para actualización reactiva
  ValueListenable<Box<AppSettings>> getSettingsListenable() {
    return _settingsRepository.getListenable();
  }
}