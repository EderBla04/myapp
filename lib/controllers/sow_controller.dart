import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/sow_model.dart';
import '../models/fattening_pig_model.dart';
import '../data/repositories/sow_repository.dart';
import '../data/repositories/fattening_pig_repository.dart';
import '../utils/error_handler.dart';

class SowController {
  final SowRepository _sowRepository = SowRepository();
  final FatteningPigRepository _pigRepository = FatteningPigRepository();

  // Agregar nueva cerda
  Future<void> addSow(String name) async {
    final newSow = Sow(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
    );
    await _sowRepository.addSow(newSow);
  }

  // Marcar cerda como preñada
  Future<void> confirmPregnancy(Sow sow) async {
    sow.marcarComoPrenada();
    await _sowRepository.updateSow(sow);
  }

  // Obtener cerda por ID
  Sow? getSow(int id) {
    return ErrorHandler.handleDataException<Sow?>(
      () => _sowRepository.getSowById(id),
      errorMessage: 'Error al buscar cerda con ID: $id',
      fallbackValue: null,
    );
  }

  // Registrar parto y crear cerditos
  Future<void> registerBirth(Sow sow, int pigletsCount, double initialWeight) async {
    // 1. Register birth in sow
    sow.registrarParto(pigletsCount);
    await _sowRepository.updateSow(sow);

    // 2. Create new fattening pigs
    for (int i = 0; i < pigletsCount; i++) {
      final newPig = FatteningPig(
        id: DateTime.now().millisecondsSinceEpoch + i,
        name: 'Lechón de ${sow.name} #${i + 1}',
        pesoActual: initialWeight,
        origen: 'importado',
        fechaIngreso: DateTime.now(),
      );
      await _pigRepository.addPig(newPig);
    }
  }

  // Obtener ValueListenable para actualización reactiva
  ValueListenable<Box<Sow>> getSowListenable() {
    return _sowRepository.getListenable();
  }
}
