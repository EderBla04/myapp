import 'package:flutter/material.dart';

// Enumeración para los diferentes tipos de errores
enum ErrorType {
  notFound,
  validation,
  database,
  network,
  unknown,
}

class AppError {
  final ErrorType type;
  final String message;
  final dynamic details;

  const AppError({
    required this.type,
    required this.message,
    this.details,
  });

  @override
  String toString() => 'AppError: $message (Type: $type)';
}

class ErrorHandler {
  // Método para mostrar un snackbar de error
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16.0),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
  
  // Método para mostrar un snackbar de éxito
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16.0),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Método para mostrar un snackbar de advertencia
  static void showWarningSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.black87),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.black87))),
          ],
        ),
        backgroundColor: Colors.amber,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16.0),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Método para mostrar un diálogo de error
  static void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  // Método para manejar errores de consulta de datos
  static T? handleDataException<T>(
    Function() dataOperation, {
    String? errorMessage,
    T? fallbackValue,
  }) {
    try {
      return dataOperation() as T?;
    } catch (e) {
      debugPrint('$errorMessage: $e');
      return fallbackValue;
    }
  }

  // Método para manejar errores en operaciones asincrónicas
  static Future<T?> handleAsyncOperation<T>(
    Future<T> Function() asyncOperation, {
    required BuildContext context,
    required String errorMessage,
    bool showError = true,
    T? fallbackValue,
  }) async {
    try {
      return await asyncOperation();
    } catch (e) {
      debugPrint('$errorMessage: $e');
      
      if (showError) {
        showErrorSnackBar(context, errorMessage);
      }
      
      return fallbackValue;
    }
  }

  // Método para manejar errores en operaciones que requieren validación
  static T? handleValidation<T>(
    bool condition,
    T? value,
    String errorMessage, {
    BuildContext? context,
    bool showError = false,
    T? fallbackValue,
  }) {
    if (condition) {
      return value;
    }
    
    debugPrint('Validation error: $errorMessage');
    
    if (showError && context != null) {
      showWarningSnackBar(context, errorMessage);
    }
    
    return fallbackValue;
  }
}