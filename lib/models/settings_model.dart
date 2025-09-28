import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 4) // Changed from 3 to 4 to resolve conflict
class AppSettings extends HiveObject {
  @HiveField(0)
  double globalPigletPrice;

  @HiveField(1)
  double globalKgPrice;

  AppSettings({
    required this.globalPigletPrice,
    required this.globalKgPrice,
  });
}
