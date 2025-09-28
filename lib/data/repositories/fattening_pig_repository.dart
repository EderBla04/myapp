import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../models/fattening_pig_model.dart';

class FatteningPigRepository {
  static const String boxName = 'fattening_pigs';
  
  // Obtener box de cerdos de engorda
  Box<FatteningPig> get _pigBox => Hive.box<FatteningPig>(boxName);
  
  // Obtener todos los cerdos
  List<FatteningPig> getAllPigs() {
    return _pigBox.values.toList();
  }
  
  // Obtener cerdo por ID
  FatteningPig? getPigById(int id) {
    try {
      return _pigBox.values.firstWhere((pig) => pig.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Agregar cerdo
  Future<void> addPig(FatteningPig pig) async {
    await _pigBox.add(pig);
  }
  
  // Actualizar cerdo
  Future<void> updatePig(FatteningPig pig) async {
    await pig.save();
  }
  
  // Eliminar cerdo
  Future<void> deletePig(FatteningPig pig) async {
    await pig.delete();
  }
  
  // Obtener cerdos por origen
  List<FatteningPig> getPigsByOrigen(String origen) {
    return _pigBox.values.where((pig) => pig.origen == origen).toList();
  }
  
  // Obtener ValueListenable para actualización reactiva
  ValueListenable<Box<FatteningPig>> getListenable() {
    return Hive.box<FatteningPig>(boxName).listenable();
  }
}