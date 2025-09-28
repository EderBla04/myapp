import 'package:hive/hive.dart';
import '../models/sow_model.dart';
import '../models/settings_model.dart';

class CrianzaController {
  static const String boxName = 'sows';
  static const String settingsBoxName = 'settings';

  // Obtener box de cerdas
  Box<Sow> get _sowBox => Hive.box<Sow>(boxName);
  
  // Obtener box de configuración
  Box<AppSettings> get _settingsBox => Hive.box<AppSettings>(settingsBoxName);

  // Obtener todas las cerdas
  List<Sow> getAllSows() {
    return _sowBox.values.toList();
  }

  // Obtener cerda por ID
  Sow? getSow(int id) {
    return _sowBox.values.firstWhere(
      (sow) => sow.id == id,
      orElse: () => throw Exception('Cerda no encontrada'),
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
    await _sowBox.add(sow);
  }

  // Marcar cerda como prenada
  Future<void> marcarCerdaPrenada(int sowId) async {
    final sow = getSow(sowId);
    if (sow != null) {
      sow.marcarComoPrenada();
      await sow.save();
    }
  }

  // Registrar parto
  Future<void> registrarParto(int sowId, int numeroCerditos) async {
    final sow = getSow(sowId);
    if (sow != null) {
      sow.registrarParto(numeroCerditos);
      await sow.save();
    }
  }

  // Quitar cerditos que no sobrevivieron
  Future<void> quitarCerditosNoSobrevivieron(int sowId, int cantidad) async {
    final sow = getSow(sowId);
    if (sow != null) {
      sow.cerditosNoSobrevivieron = cantidad;
      await sow.save();
    }
  }

  // Importar cerditos a engorda
  Future<void> importarCerditos(int sowId, int cantidad) async {
    final sow = getSow(sowId);
    if (sow != null) {
      sow.cerditosImportados += cantidad;
      await sow.save();
    }
  }

  // Volver cerda a reposo
  Future<void> volverCerdaAReposo(int sowId) async {
    final sow = getSow(sowId);
    if (sow != null) {
      sow.volverAReposo();
      await sow.save();
    }
  }

  // Eliminar cerda
  Future<void> deleteSow(int sowId) async {
    final sow = getSow(sowId);
    if (sow != null) {
      await sow.delete();
    }
  }

  // Obtener precio global de cerditos
  double getPrecioGlobalCerdito() {
    final settings = _settingsBox.values.isNotEmpty 
        ? _settingsBox.values.first 
        : AppSettings(globalPigletPrice: 1500.0, globalKgPrice: 45.0);
    return settings.globalPigletPrice;
  }

  // Actualizar precio global de cerditos
  Future<void> updatePrecioGlobalCerdito(double nuevoPrecio) async {
    if (_settingsBox.values.isEmpty) {
      final settings = AppSettings(globalPigletPrice: nuevoPrecio, globalKgPrice: 45.0);
      await _settingsBox.add(settings);
    } else {
      final settings = _settingsBox.values.first;
      settings.globalPigletPrice = nuevoPrecio;
      await settings.save();
    }
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
    return _sowBox.values.where((sow) => sow.estadoVisual == estado).toList();
  }

  // Obtener estadísticas
  Map<String, dynamic> getEstadisticas() {
    final sows = getAllSows();
    final prenadas = sows.where((s) => s.estadoVisual == 'prenada').length;
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
}