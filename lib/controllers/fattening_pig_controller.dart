import 'package:hive/hive.dart';
import '../models/fattening_pig_model.dart';
import '../models/settings_model.dart';

class EngordaController {
  static const String boxName = 'fattening_pigs';
  static const String settingsBoxName = 'settings';

  // Obtener box de cerdos de engorda
  Box<FatteningPig> get _pigBox => Hive.box<FatteningPig>(boxName);
  
  // Obtener box de configuración
  Box<AppSettings> get _settingsBox => Hive.box<AppSettings>(settingsBoxName);

  // Obtener todos los cerdos
  List<FatteningPig> getAllPigs() {
    return _pigBox.values.toList();
  }

  // Obtener cerdo por ID
  FatteningPig? getPig(String id) {
    try {
      final pigId = int.parse(id);
      return _pigBox.values.firstWhere((pig) => pig.id == pigId);
    } catch (e) {
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
    await _pigBox.add(pig);
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
      await _pigBox.add(pig);
    }
  }

  // Actualizar peso de cerdo
  Future<void> updateWeight(int pigId, double newWeight) async {
    final pig = _pigBox.values.firstWhere((p) => p.id == pigId);
    pig.actualizarPeso(newWeight);
  }

  // Eliminar cerdo
  Future<void> deletePig(int pigId) async {
    final pig = _pigBox.values.firstWhere((p) => p.id == pigId);
    await pig.delete();
  }

  // Obtener precio global por kilo
  double getPrecioGlobalPorKilo() {
    final settings = _settingsBox.values.isNotEmpty 
        ? _settingsBox.values.first 
        : AppSettings(globalPigletPrice: 1500.0, globalKgPrice: 45.0);
    return settings.globalKgPrice;
  }

  // Actualizar precio global por kilo
  Future<void> updatePrecioGlobalPorKilo(double nuevoPrecio) async {
    if (_settingsBox.values.isEmpty) {
      final settings = AppSettings(globalPigletPrice: 1500.0, globalKgPrice: nuevoPrecio);
      await _settingsBox.add(settings);
    } else {
      final settings = _settingsBox.values.first;
      settings.globalKgPrice = nuevoPrecio;
      await settings.save();
    }
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
    final pig = _pigBox.values.firstWhere((p) => p.id == pigId);
    pig.estadoVisual = nuevoEstado;
    await pig.save();
  }

  // Obtener cerdos por origen
  List<FatteningPig> getPigsByOrigen(String origen) {
    return _pigBox.values.where((pig) => pig.origen == origen).toList();
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
}
