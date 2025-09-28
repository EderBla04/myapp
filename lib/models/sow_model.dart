import 'package:hive/hive.dart';

part 'sow_model.g.dart';

@HiveType(typeId: 0)
class Sow extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime? fechaPrenada;

  @HiveField(3)
  DateTime? fechaPartoEstimado;

  @HiveField(4)
  int cerditosNacidos;

  @HiveField(5)
  int cerditosNoSobrevivieron;

  @HiveField(6)
  int cerditosImportados;

  @HiveField(7)
  String estadoVisual; // "preñada", "parida", "reposo"

  @HiveField(8)
  bool hasDado = false;

  Sow({
    required this.id,
    required this.name,
    this.fechaPrenada,
    this.fechaPartoEstimado,
    this.cerditosNacidos = 0,
    this.cerditosNoSobrevivieron = 0,
    this.cerditosImportados = 0,
    this.estadoVisual = "reposo",
    this.hasDado = false,
  });

  // Calculated property - días restantes para parto
  int get diasRestantes {
    if (fechaPartoEstimado == null) return 0;
    final difference = fechaPartoEstimado!.difference(DateTime.now());
    return difference.inDays > 0 ? difference.inDays : 0;
  }

  // Calculated property - ganancia estimada
  double calcularGananciaEstimada(double precioGlobalCerdito) {
    final cerditosDisponibles = cerditosNacidos - cerditosNoSobrevivieron - cerditosImportados - 1; // -1 para el dueño del cerdo
    return cerditosDisponibles > 0 ? cerditosDisponibles * precioGlobalCerdito : 0.0;
  }

  // Método para marcar como preñada
  void marcarComoPrenada([DateTime? fechaPersonalizada]) {
    fechaPrenada = fechaPersonalizada ?? DateTime.now();
    fechaPartoEstimado = fechaPrenada!.add(const Duration(days: 114)); // Gestación cerda ~114 días
    estadoVisual = "preñada";
    hasDado = false;
  }

  // Método para registrar parto
  void registrarParto(int numeroCerditos) {
    cerditosNacidos = numeroCerditos;
    estadoVisual = "parida";
    hasDado = true;
  }

  // Método para volver a reposo
  void volverAReposo() {
    fechaPrenada = null;
    fechaPartoEstimado = null;
    cerditosNacidos = 0;
    cerditosNoSobrevivieron = 0;
    cerditosImportados = 0;
    estadoVisual = "reposo";
    hasDado = false;
  }

  // Estado de embarazo (0.0 a 1.0)
  double get porcentajeEmbarazo {
    if (fechaPrenada == null || fechaPartoEstimado == null) return 0.0;
    final duracionTotal = fechaPartoEstimado!.difference(fechaPrenada!).inDays;
    final diasTranscurridos = DateTime.now().difference(fechaPrenada!).inDays;
    final progreso = diasTranscurridos / duracionTotal;
    return progreso.clamp(0.0, 1.0);
  }
}
