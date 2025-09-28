import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/sow_model.dart';
import '../controllers/crianza_controller.dart';
import '../widgets/sow_animation_widget.dart';
import '../theme/theme.dart';
import '../utils/error_handler.dart';

class BreedingScreen extends StatefulWidget {
  const BreedingScreen({super.key});

  @override
  State<BreedingScreen> createState() => _BreedingScreenState();
}

class _BreedingScreenState extends State<BreedingScreen> {
  final CrianzaController _controller = CrianzaController();
  final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  void _showAddSowDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.pets, color: PorciColors.sowPink, size: 28),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Añadir Cerda',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre de la cerda',
              hintText: 'Ej: Rosita, Cerda #001...',
              prefixIcon: Icon(Icons.edit),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController.text.trim().isNotEmpty) {
                  await _controller.addSow(name: nameController.text.trim());
                  if (mounted) {
                    Navigator.pop(context);
                    ErrorHandler.showSuccessSnackBar(
                      context, 'Cerda "${nameController.text.trim()}" añadida'
                    );
                  }
                } else {
                  ErrorHandler.showWarningSnackBar(
                    context, 'Por favor ingrese un nombre válido'
                  );
                }
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }

  void _showPriceSettingsDialog() {
    final priceController = TextEditingController(
      text: _controller.getPrecioGlobalCerdito().toString(),
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.attach_money, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Precio por Cerdito',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Establece el precio global por cerdito para calcular las ganancias:'),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Precio por cerdito',
                  prefixIcon: Icon(Icons.attach_money),
                  suffixText: 'pesos',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final price = double.tryParse(priceController.text);
                if (price != null && price > 0) {
                  await _controller.updatePrecioGlobalCerdito(price);
                  if (mounted) {
                    Navigator.pop(context);
                    ErrorHandler.showSuccessSnackBar(
                      context, 'Precio actualizado correctamente'
                    );
                  }
                } else {
                  ErrorHandler.showErrorSnackBar(
                    context, 'Por favor ingrese un precio válido'
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header con estadísticas
          Container(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _controller.getSowListenable(),
                      builder: (context, Box<Sow> box, _) {
                        return _buildStatsCard();
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _showPriceSettingsDialog,
                        icon: const Icon(Icons.settings, size: 18),
                        label: const Text('Configurar Precios'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Lista de cerdas
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _controller.getSowListenable(),
              builder: (context, Box<Sow> box, _) {
                final sows = _controller.getAllSows();
                if (sows.isEmpty) {
                  return _buildEmptyState();
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: sows.length,
                  itemBuilder: (context, index) {
                    final sow = sows[index];
                    return _buildSowCard(sow);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _controller.getSowListenable(),
        builder: (context, Box<Sow> box, _) {
          // Solo mostrar el FAB cuando hay cerdas
          if (box.values.isEmpty) {
            return const SizedBox.shrink();
          }
          
          return FloatingActionButton.extended(
            onPressed: _showAddSowDialog,
            label: const Text('Añadir Cerda'),
            icon: const Icon(Icons.add),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard() {
    final stats = _controller.getEstadisticas();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen de Crianza',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: PorciColors.sowPink,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildStatChip('Cerdas: ${stats['totalCerdas']}', Colors.blue),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatChip('Preñadas: ${stats['prenadas']}', Colors.orange),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: _buildStatChip('Cerditos: ${stats['totalCerditos']}', Colors.green),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatChip('Ganancia: ${currencyFormatter.format(stats['gananciaTotal'])}', Colors.purple),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatChip(String label, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4), width: 1.2),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.lerp(color, Colors.black, 0.2)!,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: PorciColors.sowPink.withOpacity(0.2),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.pets,
              size: 60,
              color: PorciColors.sowPink,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aún no has añadido cerdas',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega tu primera cerda para comenzar\ncon la crianza',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddSowDialog,
            icon: const Icon(Icons.add),
            label: const Text('Añadir Primera Cerda'),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildSowCard(Sow sow) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.go('/sow/${sow.id}'),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Animación de la cerda
              SowAnimationWidget(
                sow: sow,
                isDayTime: DateTime.now().hour >= 6 && DateTime.now().hour <= 20,
              ),
              
              const SizedBox(width: 16),
              
              // Información de la cerda
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sow.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildStatusInfo(sow),
                    if (sow.estadoVisual == 'preñada') ...[
                      const SizedBox(height: 8),
                      _buildProgressBar(sow),
                    ],
                    if (sow.estadoVisual == 'parida') ...[
                      const SizedBox(height: 8),
                      _buildPigletInfo(sow),
                    ],
                  ],
                ),
              ),
              
              // Botón de acciones
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'details':
                      context.go('/sow/${sow.id}');
                      break;
                    case 'delete':
                      _showDeleteSowDialog(sow);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'details',
                    child: ListTile(
                      leading: Icon(Icons.visibility),
                      title: Text('Ver Detalles'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text('Eliminar', style: TextStyle(color: Colors.red)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
                child: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusInfo(Sow sow) {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    switch (sow.estadoVisual) {
      case 'preñada':
        statusText = 'Preñada - ${sow.diasRestantes} días restantes';
        statusColor = Colors.orange;
        statusIcon = Icons.favorite;
        break;
      case 'parida':
        statusText = 'Ha parido - ${sow.cerditosNacidos} cerditos';
        statusColor = Colors.green;
        statusIcon = Icons.family_restroom;
        break;
      default:
        statusText = 'En reposo';
        statusColor = Colors.blue;
        statusIcon = Icons.pets;
    }

    return Row(
      children: [
        Icon(statusIcon, size: 16, color: statusColor),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            statusText,
            style: TextStyle(
              color: Color.lerp(statusColor, Colors.black, 0.3)!,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(Sow sow) {
    final progress = sow.porcentajeEmbarazo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progreso del embarazo',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.orange.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
        const SizedBox(height: 2),
        Text(
          '${(progress * 100).toInt()}%',
          style: TextStyle(
            fontSize: 12,
            color: Color.lerp(Colors.orange, Colors.black, 0.3)!,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPigletInfo(Sow sow) {
    final ganancia = sow.calcularGananciaEstimada(_controller.getPrecioGlobalCerdito());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.child_friendly, size: 14, color: Colors.green),
            const SizedBox(width: 4),
            Text(
              '${sow.cerditosNacidos - sow.cerditosNoSobrevivieron - sow.cerditosImportados - 1} disponibles',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(Icons.attach_money, size: 14, color: Colors.green),
            const SizedBox(width: 4),
            Text(
              'Ganancia: ${currencyFormatter.format(ganancia)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDeleteSowDialog(Sow sow) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 28),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Eliminar Cerda',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('¿Estás seguro de que deseas eliminar la cerda "${sow.name}"?'),
              const SizedBox(height: 16),
              const Text(
                'Esta acción no se puede deshacer.',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                await _controller.deleteSow(sow.id);
                if (mounted) {
                  Navigator.pop(dialogContext);
                  ErrorHandler.showSuccessSnackBar(
                    context, 'Cerda "${sow.name}" eliminada'
                  );
                }
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
