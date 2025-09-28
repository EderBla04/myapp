import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/sow_model.dart';

class SowListItem extends StatelessWidget {
  final Sow sow;

  const SowListItem({super.key, required this.sow});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/sow/${sow.id}'),
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
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.pets, // Temporary icon
                    size: 40,
                    color: Colors.brown,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Sow Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sow.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Chip(
                      label: Text(
                        sow.estadoVisual == 'preñada' ? 'Preñada' : 
                        sow.estadoVisual == 'parida' ? 'Parida' : 'En reposo',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                      ),
                      backgroundColor: sow.estadoVisual == 'preñada' ? Colors.orange : 
                                     sow.estadoVisual == 'parida' ? Colors.green : Colors.grey,
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    ),
                    const SizedBox(height: 8),
                    if (sow.estadoVisual == 'preñada')
                      Text(
                        'Parto en ${sow.diasRestantes} días',
                        style: Theme.of(context).textTheme.bodyMedium,
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
