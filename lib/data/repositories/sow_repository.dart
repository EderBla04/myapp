import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../models/sow_model.dart';

class SowRepository {
  static const String boxName = 'sows';
  
  // Obtener box de cerdas
  Box<Sow> get _sowBox => Hive.box<Sow>(boxName);
  
  // Obtener todas las cerdas
  List<Sow> getAllSows() {
    return _sowBox.values.toList();
  }
  
  // Obtener cerda por ID
  Sow? getSowById(int id) {
    try {
      return _sowBox.values.firstWhere((sow) => sow.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Agregar cerda
  Future<void> addSow(Sow sow) async {
    await _sowBox.add(sow);
  }
  
  // Actualizar cerda
  Future<void> updateSow(Sow sow) async {
    await sow.save();
  }
  
  // Eliminar cerda
  Future<void> deleteSow(Sow sow) async {
    await sow.delete();
  }
  
  // Obtener cerdas por estado
  List<Sow> getSowsByState(String state) {
    return _sowBox.values.where((sow) => sow.estadoVisual == state).toList();
  }
  
  // Obtener ValueListenable para actualización reactiva
  ValueListenable<Box<Sow>> getListenable() {
    return Hive.box<Sow>(boxName).listenable();
  }
}