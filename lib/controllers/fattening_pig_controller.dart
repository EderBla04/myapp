import 'package:hive/hive.dart';
import '../models/fattening_pig_model.dart';
import '../models/weight_entry_model.dart';

class FatteningPigController {
  final fatteningPigsBox = Hive.box<FatteningPig>('fattening_pigs');

  void addPig(String name, double weight) {
    final newPig = FatteningPig(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      currentWeight: weight,
      origin: 'manual',
      entryDate: DateTime.now(),
    );
    fatteningPigsBox.add(newPig);
  }

  void recordWeight(FatteningPig pig, double weight) {
    final newEntry = WeightEntry(date: DateTime.now(), weight: weight);
    pig.weightHistory?.add(newEntry);
    pig.currentWeight = weight; // Update current weight
    pig.save();
  }

  void sellPig(FatteningPig pig) {
    pig.delete();
  }
}
