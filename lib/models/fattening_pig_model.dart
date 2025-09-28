import 'package:hive/hive.dart';
import 'weight_entry_model.dart';

part 'fattening_pig_model.g.dart';

@HiveType(typeId: 2)
class FatteningPig extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  double pesoActual;

  @HiveField(3)
  final String origen; // 'manual', 'importado'

  @HiveField(4)
  final DateTime fechaIngreso;

  @HiveField(5)
  String estadoVisual; // 'dia', 'noche'

  @HiveField(6)
  HiveList<WeightEntry>? weightHistory;

  FatteningPig({
    required this.id,
    required this.name,
    required this.pesoActual,
    required this.origen,
    required this.fechaIngreso,
    this.estadoVisual = 'dia',
    this.weightHistory,
  }) {
    weightHistory ??= HiveList(Hive.box<WeightEntry>('weight_entries'));
    if (weightHistory!.isEmpty) {
      weightHistory!.add(WeightEntry(date: fechaIngreso, weight: pesoActual));
    }
  }

  // Calculated property - ganancia estimada
  double calcularGananciaEstimada(double precioGlobalPorKilo) {
    return pesoActual * precioGlobalPorKilo;
  }

  // Método para actualizar peso
  void actualizarPeso(double nuevoPeso) {
    pesoActual = nuevoPeso;
    weightHistory!.add(WeightEntry(date: DateTime.now(), weight: nuevoPeso));
    save(); // Guardar cambios en Hive
  }

  // Getter para obtener el peso inicial
  double get pesoInicial {
    if (weightHistory == null || weightHistory!.isEmpty) return pesoActual;
    return weightHistory!.first.weight;
  }

  // Getter para obtener el incremento de peso
  double get incrementoPeso {
    return pesoActual - pesoInicial;
  }

  // Días desde ingreso
  int get diasDesdeIngreso {
    return DateTime.now().difference(fechaIngreso).inDays;
  }
}
