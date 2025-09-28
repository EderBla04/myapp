import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/fattening_pig_model.dart';
import '../data/repositories/fattening_pig_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../utils/error_handler.dart';

class FatteningPigController {
  final FatteningPigRepository _pigRepository = FatteningPigRepository();
  final SettingsRepository _settingsRepository = SettingsRepository();

  // Obtener todos los cerdos
  List<FatteningPig> getAllPigs() {
    return _pigRepository.getAllPigs();
  }

  // Obtener cerdo por ID
  FatteningPig? getPig(String id) {
    try {
      final pigId = int.parse(id);
      return ErrorHandler.handleDataException<FatteningPig?>(
        () => _pigRepository.getPigById(pigId),
        errorMessage: 'Error al buscar cerdo con ID: $id',
        fallbackValue: null,
      );
    } catch (e) {
      debugPrint('Error al convertir ID: $e');
      return null;
    }
  }

  // Agregar cerdo manualmente
  Future<void> addPig({
    required String name,
    required double weight,
    String? origin,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    final pig = FatteningPig(
      id: id,
      name: name,
      pesoActual: weight,
      origen: origin ?? 'manual',
      fechaIngreso: DateTime.now(),
    );
    await _pigRepository.addPig(pig);
  }

  // Importar cerdos desde crianza
  Future<void> importarDesdeCrianza({
    required String baseName,
    required int cantidad,
    required double pesoPromedio,
  }) async {
    for (int i = 0; i < cantidad; i++) {
      final id = DateTime.now().millisecondsSinceEpoch + i;
      final pig = FatteningPig(
        id: id,
        name: '$baseName ${i + 1}',
        pesoActual: pesoPromedio,
        origen: 'importado',
        fechaIngreso: DateTime.now(),
      );
      await _pigRepository.addPig(pig);
    }
  }

  // Actualizar peso de cerdo
  Future<void> updateWeight(int pigId, double newWeight) async {
    final pig = _pigRepository.getPigById(pigId);
    if (pig != null) {
      pig.actualizarPeso(newWeight);
      await _pigRepository.updatePig(pig);
    }
  }

  // Eliminar cerdo
  Future<void> deletePig(int pigId) async {
    final pig = _pigRepository.getPigById(pigId);
    if (pig != null) {
      await _pigRepository.deletePig(pig);
    }
  }

  // Obtener precio global por kilo
  double getPrecioGlobalPorKilo() {
    return _settingsRepository.getPrecioGlobalPorKilo();
  }

  // Actualizar precio global por kilo
  Future<void> updatePrecioGlobalPorKilo(double nuevoPrecio) async {
    await _settingsRepository.updatePrecioGlobalPorKilo(nuevoPrecio);
  }

  // Calcular ganancia total de engorda
  double calcularGananciaTotalEngorda() {
    final precioGlobal = getPrecioGlobalPorKilo();
    double total = 0.0;
    
    for (final pig in getAllPigs()) {
      total += pig.calcularGananciaEstimada(precioGlobal);
    }
    
    return total;
  }

  // Cambiar estado visual (día/noche)
  Future<void> cambiarEstadoVisual(int pigId, String nuevoEstado) async {
    final pig = _pigRepository.getPigById(pigId);
    if (pig != null) {
      pig.estadoVisual = nuevoEstado;
      await _pigRepository.updatePig(pig);
    }
  }

  // Obtener cerdos por origen
  List<FatteningPig> getPigsByOrigen(String origen) {
    return _pigRepository.getPigsByOrigen(origen);
  }

  // Obtener estadísticas
  Map<String, dynamic> getEstadisticas() {
    final pigs = getAllPigs();
    final manuales = pigs.where((p) => p.origen == 'manual').length;
    final importados = pigs.where((p) => p.origen == 'importado').length;
    final pesoTotal = pigs.fold(0.0, (sum, pig) => sum + pig.pesoActual);
    final gananciaTotal = calcularGananciaTotalEngorda();

    return {
      'totalCerdos': pigs.length,
      'manuales': manuales,
      'importados': importados,
      'pesoTotal': pesoTotal,
      'gananciaTotal': gananciaTotal,
    };
  }
  
  // Obtener ValueListenable para actualización reactiva
  ValueListenable<Box<FatteningPig>> getPigListenable() {
    return _pigRepository.getListenable();
  }
}
