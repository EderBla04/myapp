import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'views/home_screen.dart';
import 'views/settings_screen.dart';
import 'views/sow_detail_screen.dart';
import 'views/fattening_pig_detail_screen.dart';

import 'views/engorda_settings_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsScreen();
          },
        ),
        GoRoute(
          path: 'sow/:id',
          builder: (BuildContext context, GoRouterState state) {
            final String id = state.pathParameters['id']!;
            return SowDetailScreen(sowId: id);
          },
        ),
        GoRoute(
          path: 'fattening/:id',
          builder: (BuildContext context, GoRouterState state) {
            final String id = state.pathParameters['id']!;
            return FatteningPigDetailScreen(pigId: id);
          },
        ),

        GoRoute(
          path: 'engorda-settings',  
          builder: (BuildContext context, GoRouterState state) {
            return const EngordaSettingsScreen();
          },
        ),
      ],
    ),
  ],
);
