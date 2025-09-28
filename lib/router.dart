import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'views/home_screen.dart';
import 'views/settings_screen.dart';
import 'views/sow_detail_screen.dart';
import 'views/fattening_pig_detail_screen.dart';
import 'views/engorda_settings_screen.dart';


// Página de error personalizada
class ErrorPage extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const ErrorPage({
    Key? key, 
    required this.errorMessage,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              if (onRetry != null)
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Reintentar'),
                ),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
  // Configuración global de errores
  redirect: (context, state) {
    // Aquí podríamos implementar redirecciones basadas en errores o autenticación
    return null; // null significa que no hay redirección
  },
);
