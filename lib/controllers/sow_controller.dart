import 'package:hive/hive.dart';
import '../models/sow_model.dart';
import '../models/fattening_pig_model.dart';

class SowController {
  final sowBox = Hive.box<Sow>('sows');
  final fatteningPigsBox = Hive.box<FatteningPig>('fattening_pigs');

  void addSow(String name) {
    final newSow = Sow(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      isPregnant: false,
    );
    sowBox.add(newSow);
  }

  void confirmPregnancy(Sow sow) {
    final pregnancyDate = DateTime.now();
    final estimatedBirthDate = pregnancyDate.add(const Duration(days: 114));

    sow.isPregnant = true;
    sow.estimatedBirthDate = estimatedBirthDate;
    sow.save();
  }

  void registerBirth(Sow sow, int pigletsCount, double initialWeight) {
    // 1. Reset the sow's state
    sow.isPregnant = false;
    sow.estimatedBirthDate = null;
    sow.save();

    // 2. Create new fattening pigs
    for (int i = 0; i < pigletsCount; i++) {
      final newPig = FatteningPig(
        id: DateTime.now().millisecondsSinceEpoch + i,
        name: 'Lechón de ${sow.name} #${i + 1}',
        currentWeight: initialWeight,
        origin: 'Crianza',
        entryDate: DateTime.now(),
      );
      fatteningPigsBox.add(newPig);
    }
  }
}
