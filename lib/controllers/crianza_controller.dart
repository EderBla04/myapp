import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/sow_model.dart';
import '../models/settings_model.dart';
import '../data/repositories/sow_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../utils/error_handler.dart';

class CrianzaController {
  final SowRepository _sowRepository = SowRepository();
  final SettingsRepository _settingsRepository = SettingsRepository();

  // Obtener todas las cerdas
  List<Sow> getAllSows() {
    return _sowRepository.getAllSows();
  }

  // Obtener cerda por ID
  Sow? getSow(int id) {
    return ErrorHandler.handleDataException<Sow?>(
      () => _sowRepository.getSowById(id),
      errorMessage: 'Error al buscar cerda con ID: $id',
      fallbackValue: null,
    );
  }

  // Agregar nueva cerda
  Future<void> addSow({
    required String name,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch; // ID único basado en timestamp
    final sow = Sow(
      id: id,
      name: name,
    );
    await _sowRepository.addSow(sow);
  }

  // Marcar cerda como prenada
  Future<void> marcarCerdaPrenada(int sowId, [DateTime? fechaPersonalizada]) async {
    final sow = getSow(sowId);
    if (sow != null) {
      sow.marcarComoPrenada(fechaPersonalizada);
      await _sowRepository.updateSow(sow);
      debugPrint('Cerda ${sow.name} marcada como preñada. Estado: ${sow.estadoVisual}');
    } else {
      debugPrint('Error: No se encontró la cerda con ID $sowId');
    }
  }

  // Registrar parto
  Future<void> registrarParto(int sowId, int numeroCerditos) async {
    final sow = getSow(sowId);
    if (sow != null) {
      sow.registrarParto(numeroCerditos);
      await _sowRepository.updateSow(sow);
    }
  }

  // Quitar cerditos que no sobrevivieron
  Future<void> quitarCerditosNoSobrevivieron(int sowId, int cantidad) async {
    final sow = getSow(sowId);
    if (sow != null) {
      sow.cerditosNoSobrevivieron = cantidad;
      await _sowRepository.updateSow(sow);
    }
  }

  // Importar cerditos a engorda
  Future<void> importarCerditos(int sowId, int cantidad) async {
    final sow = getSow(sowId);
    if (sow != null) {
      sow.cerditosImportados += cantidad;
      await _sowRepository.updateSow(sow);
    }
  }

  // Volver cerda a reposo
  Future<void> volverCerdaAReposo(int sowId) async {
    final sow = getSow(sowId);
    if (sow != null) {
      sow.volverAReposo();
      await _sowRepository.updateSow(sow);
    }
  }

  // Eliminar cerda
  Future<void> deleteSow(int sowId) async {
    final sow = getSow(sowId);
    if (sow != null) {
      await _sowRepository.deleteSow(sow);
    }
  }

  // Obtener precio global de cerditos
  double getPrecioGlobalCerdito() {
    return _settingsRepository.getPrecioGlobalCerdito();
  }

  // Actualizar precio global de cerditos
  Future<void> updatePrecioGlobalCerdito(double nuevoPrecio) async {
    await _settingsRepository.updatePrecioGlobalCerdito(nuevoPrecio);
  }

  // Calcular ganancia total de crianza
  double calcularGananciaTotalCrianza() {
    final precioGlobal = getPrecioGlobalCerdito();
    double total = 0.0;
    
    for (final sow in getAllSows()) {
      total += sow.calcularGananciaEstimada(precioGlobal);
    }
    
    return total;
  }

  // Obtener cerdas por estado
  List<Sow> getSowsByEstado(String estado) {
    return _sowRepository.getSowsByState(estado);
  }

  // Obtener estadísticas
  Map<String, dynamic> getEstadisticas() {
    final sows = getAllSows();
    final prenadas = sows.where((s) => s.estadoVisual == 'preñada').length;
    final paridas = sows.where((s) => s.estadoVisual == 'parida').length;
    final reposo = sows.where((s) => s.estadoVisual == 'reposo').length;
    final totalCerditos = sows.fold(0, (sum, sow) => sum + sow.cerditosNacidos);
    final gananciTotal = calcularGananciaTotalCrianza();

    return {
      'totalCerdas': sows.length,
      'prenadas': prenadas,
      'paridas': paridas,
      'reposo': reposo,
      'totalCerditos': totalCerditos,
      'gananciaTotal': gananciTotal,
    };
  }
  
  // Obtener ValueListenable para actualización reactiva
  ValueListenable<Box<Sow>> getSowListenable() {
    return _sowRepository.getListenable();
  }
}