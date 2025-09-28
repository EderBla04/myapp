import 'package:hive/hive.dart';

part 'sow_model.g.dart';

@HiveType(typeId: 0)
class Sow extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  bool isPregnant;

  @HiveField(3)
  DateTime? estimatedBirthDate;

  @HiveField(4)
  String visualState; // e.g., "resting", "pregnant", "nursing"

  Sow({
    required this.id,
    required this.name,
    this.isPregnant = false,
    this.estimatedBirthDate,
    this.visualState = "resting",
  });

  // Calculated property, not stored in Hive
  int get remainingDaysForBirth {
    if (estimatedBirthDate == null) return 0;
    final difference = estimatedBirthDate!.difference(DateTime.now());
    // Return 0 if the date has passed
    return difference.inDays > 0 ? difference.inDays : 0;
  }
}
