import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:porciapp/models/sow_model.dart';
import 'package:porciapp/models/fattening_pig_model.dart';
import 'package:porciapp/models/weight_entry_model.dart';
import 'package:porciapp/models/settings_model.dart';
import 'package:porciapp/router.dart';
import 'package:porciapp/theme/theme.dart';

void main() async {
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(SowAdapter());
  Hive.registerAdapter(FatteningPigAdapter());
  Hive.registerAdapter(WeightEntryAdapter());
  Hive.registerAdapter(AppSettingsAdapter());

  // Open Hive Boxes
  await Hive.openBox<Sow>('sows');
  await Hive.openBox<FatteningPig>('fattening_pigs');
  await Hive.openBox<WeightEntry>('weight_entries');
  await Hive.openBox<AppSettings>('settings');

  runApp(const PorciApp());
}

class PorciApp extends StatelessWidget {
  const PorciApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PorciApp',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
