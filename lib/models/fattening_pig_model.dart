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
  double currentWeight;

  @HiveField(3)
  final String origin; // e.g., 'manual', 'imported'

  @HiveField(4)
  final DateTime entryDate;

  @HiveField(5)
  HiveList<WeightEntry>? weightHistory;

  FatteningPig({
    required this.id,
    required this.name,
    required this.currentWeight,
    required this.origin,
    required this.entryDate,
    this.weightHistory,
  }) {
    weightHistory ??= HiveList(Hive.box<WeightEntry>('weight_entries'));
    weightHistory!.add(WeightEntry(date: entryDate, weight: currentWeight));
  }
}
