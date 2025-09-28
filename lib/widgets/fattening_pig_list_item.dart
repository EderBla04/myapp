import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/fattening_pig_model.dart';

class FatteningPigListItem extends StatelessWidget {
  final FatteningPig pig;

  const FatteningPigListItem({super.key, required this.pig});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/fattening/${pig.id}'),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Placeholder for Pig Illustration
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.ramen_dining, // Temporary icon
                    size: 40,
                    color: Colors.green.shade800,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Pig Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pig.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Peso: ${pig.pesoActual.toStringAsFixed(1)} kg',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(
                        pig.origen == 'manual' ? 'Manual' : 'Importado',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black87),
                      ),
                      backgroundColor: pig.origen == 'manual'
                          ? Colors.amber.withOpacity(0.3)
                          : Colors.blue.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
