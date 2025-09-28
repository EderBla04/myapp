import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/fattening_pig_model.dart';
import '../controllers/fattening_pig_controller.dart';
import '../widgets/pig_animation_widget.dart';
import '../theme/theme.dart';
import '../utils/error_handler.dart';

class FatteningScreen extends StatefulWidget {
  const FatteningScreen({super.key});

  @override
  State<FatteningScreen> createState() => _FatteningScreenState();
}

class _FatteningScreenState extends State<FatteningScreen> {
  final FatteningPigController _controller = FatteningPigController();
  final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  void _showAddPigDialog() {
    final nameController = TextEditingController();
    final weightController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.agriculture, color: PorciColors.pigPink, size: 28),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Añadir Cerdo',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del cerdo',
                  hintText: 'Ej: Cochito, Cerdo #001...',
                  prefixIcon: Icon(Icons.edit),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(
                  labelText: 'Peso inicial (kg)',
                  hintText: 'Ej: 25.5',
                  prefixIcon: Icon(Icons.monitor_weight),
                  suffixText: 'kg',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                final name = nameController.text.trim();
                final weight = double.tryParse(weightController.text);
                if (name.isNotEmpty && weight != null && weight > 0) {
                  await _controller.addPig(name: name, weight: weight);
                  if (mounted) {
                    Navigator.pop(context);
                    ErrorHandler.showSuccessSnackBar(
                      context, 'Cerdo "$name" añadido'
                    );
                  }
                } else {
                  ErrorHandler.showWarningSnackBar(
                    context, 'Por favor ingrese un nombre y un peso válido'
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
      text: _controller.getPrecioGlobalPorKilo().toString(),
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
                  'Precio por Kilo',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Establece el precio global por kilogramo para calcular las ganancias:'),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Precio por kilogramo',
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
                  await _controller.updatePrecioGlobalPorKilo(price);
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

  void _showImportFromBreedingDialog() {
    final baseNameController = TextEditingController();
    final quantityController = TextEditingController();
    final weightController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.import_export, color: Colors.blue, size: 28),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Importar desde Crianza',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Importa cerditos desde la sección de crianza:'),
              const SizedBox(height: 16),
              TextField(
                controller: baseNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre base',
                  hintText: 'Ej: Cerdito de Rosita',
                  prefixIcon: Icon(Icons.label),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  prefixIcon: Icon(Icons.numbers),
                  suffixText: 'cerditos',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Peso promedio',
                  prefixIcon: Icon(Icons.monitor_weight),
                  suffixText: 'kg',
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
                final baseName = baseNameController.text.trim();
                final quantity = int.tryParse(quantityController.text);
                final weight = double.tryParse(weightController.text);
                if (baseName.isNotEmpty && quantity != null && quantity > 0 && weight != null && weight > 0) {
                  await _controller.importarDesdeCrianza(
                    baseName: baseName,
                    cantidad: quantity,
                    pesoPromedio: weight,
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    ErrorHandler.showSuccessSnackBar(
                      context, 'Se han importado $quantity cerditos'
                    );
                  }
                } else {
                  ErrorHandler.showWarningSnackBar(
                    context, 'Por favor complete todos los campos correctamente'
                  );
                }
              },
              child: const Text('Importar'),
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
                    _buildStatsCard(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _showPriceSettingsDialog,
                            icon: const Icon(Icons.settings, size: 18),
                            label: const Text('Precios'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _showImportFromBreedingDialog,
                            icon: const Icon(Icons.import_export, size: 18),
                            label: const Text('Importar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Lista de cerdos de engorda
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _controller.getPigListenable(),
              builder: (context, Box<FatteningPig> box, _) {
                final pigs = _controller.getAllPigs();
                if (pigs.isEmpty) {
                  return _buildEmptyState();
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: pigs.length,
                  itemBuilder: (context, index) {
                    final pig = pigs[index];
                    return _buildPigCard(pig);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _controller.getPigListenable(),
        builder: (context, Box<FatteningPig> box, _) {
          // Solo mostrar el FAB cuando hay cerdos
          if (box.values.isEmpty) {
            return const SizedBox.shrink();
          }
          
          return FloatingActionButton.extended(
            onPressed: _showAddPigDialog,
            label: const Text('Añadir Cerdo'),
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
          'Resumen de Engorda',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: PorciColors.pigPink,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildStatChip('Cerdos: ${stats['totalCerdos']}', Colors.blue)),
            const SizedBox(width: 8),
            Expanded(child: _buildStatChip('Manuales: ${stats['manuales']}', Colors.green)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(child: _buildStatChip('Importados: ${stats['importados']}', Colors.orange)),
            const SizedBox(width: 8),
            Expanded(child: _buildStatChip('Peso Total: ${stats['pesoTotal'].toInt()} kg', Colors.purple)),
          ],
        ),
        const SizedBox(height: 4),
        _buildStatChip('Ganancia: ${currencyFormatter.format(stats['gananciaTotal'])}', Colors.red),
      ],
    );
  }

  Widget _buildStatChip(String label, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Color.lerp(color, Colors.black, 0.3)!,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
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
              color: PorciColors.pigPink.withOpacity(0.2),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.agriculture,
              size: 60,
              color: PorciColors.pigPink,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aún no hay cerdos de engorda',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega cerdos manualmente o\nimpórtalos desde crianza',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _showAddPigDialog,
                icon: const Icon(Icons.add),
                label: const Text('Añadir Cerdo'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _showImportFromBreedingDialog,
                icon: const Icon(Icons.import_export),
                label: const Text('Importar'),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildPigCard(FatteningPig pig) {
    final ganancia = pig.calcularGananciaEstimada(_controller.getPrecioGlobalPorKilo());
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.go('/fattening/${pig.id}'),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Animación del cerdo
              PigAnimationWidget(
                pig: pig,
                isDayTime: DateTime.now().hour >= 6 && DateTime.now().hour <= 20,
              ),
              
              const SizedBox(width: 16),
              
              // Información del cerdo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pig.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildPigInfo(pig, ganancia),
                  ],
                ),
              ),
              
              // Botón de acciones
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'details':
                      context.go('/fattening/${pig.id}');
                      break;
                    case 'delete':
                      _showDeletePigDialog(pig);
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

  Widget _buildPigInfo(FatteningPig pig, double ganancia) {
    Color originColor = pig.origen == 'manual' ? Colors.green : Colors.orange;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Origen y peso
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: originColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: originColor.withOpacity(0.5)),
              ),
              child: Text(
                pig.origen.toUpperCase(),
                style: TextStyle(
                  color: Color.lerp(originColor, Colors.black, 0.3)!,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${pig.pesoActual.toInt()} kg',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        
        // Días desde ingreso
        Row(
          children: [
            Icon(Icons.access_time, size: 14, color: Colors.blue),
            const SizedBox(width: 4),
            Text(
              '${pig.diasDesdeIngreso} días',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.trending_up, size: 14, color: Colors.green),
            const SizedBox(width: 4),
            Text(
              '+${pig.incrementoPeso.toStringAsFixed(1)} kg',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        
        // Ganancia estimada
        Row(
          children: [
            Icon(Icons.attach_money, size: 14, color: Colors.purple),
            const SizedBox(width: 4),
            Text(
              'Ganancia: ${currencyFormatter.format(ganancia)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.purple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDeletePigDialog(FatteningPig pig) {
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
                  'Eliminar Cerdo',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('¿Estás seguro de que deseas eliminar el cerdo "${pig.name}"?'),
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
                await _controller.deletePig(pig.id);
                if (mounted) {
                  Navigator.pop(dialogContext);
                  ErrorHandler.showSuccessSnackBar(
                    context, 'Cerdo "${pig.name}" eliminado'
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
