import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/sow_model.dart';
import '../controllers/crianza_controller.dart';
import '../widgets/sow_animation_widget.dart';
import '../theme/theme.dart';

class SowDetailScreen extends StatefulWidget {
  final String sowId;

  const SowDetailScreen({super.key, required this.sowId});

  @override
  State<SowDetailScreen> createState() => _SowDetailScreenState();
}

class _SowDetailScreenState extends State<SowDetailScreen> {
  final CrianzaController _controller = CrianzaController();
  final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  void _showRegisterBirthDialog(Sow sow) {
    final pigletsController = TextEditingController();
    final weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Registrar Parto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pigletsController,
                decoration: const InputDecoration(labelText: 'Número de lechones'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Peso promedio inicial (kg)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () {
                final pigletsCount = int.tryParse(pigletsController.text);
                final initialWeight = double.tryParse(weightController.text);

                if (pigletsCount != null && initialWeight != null && pigletsCount > 0) {
                  // Registrar parto
                  _controller.registrarParto(sow.id, pigletsCount);
                  
                  // Handle UI logic here in the view
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Parto registrado: $pigletsCount cerditos')),
                  );
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Sow>('sows').listenable(),
      builder: (context, Box<Sow> box, _) {
        final sow = box.values.firstWhere((s) => s.id.toString() == widget.sowId);

        return Scaffold(
          appBar: AppBar(
            title: Text(sow.name),
            backgroundColor: PorciColors.sowPink,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarjeta con animación de la cerda
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SowAnimationWidget(
                          sow: sow,
                          isDayTime: DateTime.now().hour >= 6 && DateTime.now().hour <= 20,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          sow.name,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildStatusChip(sow),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Información detallada
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              'Información Detallada',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoSection(sow),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Acciones disponibles
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.touch_app, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              'Acciones',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildActionButtons(sow),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(Sow sow) {
    Color chipColor;
    String statusText;
    IconData icon;

    switch (sow.estadoVisual) {
      case 'prenada':
        chipColor = Colors.orange;
        statusText = 'Preñada';
        icon = Icons.favorite;
        break;
      case 'parida':
        chipColor = Colors.green;
        statusText = 'Ha Parido';
        icon = Icons.family_restroom;
        break;
      default:
        chipColor = Colors.blue;
        statusText = 'En Reposo';
        icon = Icons.pets;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: chipColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: chipColor, size: 16),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              color: chipColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(Sow sow) {
    final ganancia = sow.calcularGananciaEstimada(_controller.getPrecioGlobalCerdito());
    
    return Column(
      children: [
        if (sow.estadoVisual == 'prenada') ...[
          _buildInfoRow(
            'Días Restantes',
            '${sow.diasRestantes} días',
            Icons.schedule,
            Colors.orange,
          ),
          _buildInfoRow(
            'Fecha Estimada de Parto',
            DateFormat('dd/MM/yyyy').format(sow.fechaPartoEstimado!),
            Icons.calendar_today,
            Colors.blue,
          ),
          _buildInfoRow(
            'Progreso',
            '${(sow.porcentajeEmbarazo * 100).toInt()}%',
            Icons.trending_up,
            Colors.purple,
          ),
        ],
        
        if (sow.estadoVisual == 'parida') ...[
          _buildInfoRow(
            'Cerditos Nacidos',
            '${sow.cerditosNacidos}',
            Icons.child_friendly,
            Colors.green,
          ),
          _buildInfoRow(
            'No Sobrevivieron',
            '${sow.cerditosNoSobrevivieron}',
            Icons.remove_circle,
            Colors.red,
          ),
          _buildInfoRow(
            'Importados a Engorda',
            '${sow.cerditosImportados}',
            Icons.import_export,
            Colors.blue,
          ),
          _buildInfoRow(
            'Ganancia Estimada',
            currencyFormatter.format(ganancia),
            Icons.attach_money,
            Colors.green,
          ),
        ],
        
        _buildInfoRow(
          'Estado Visual',
          sow.estadoVisual.toUpperCase(),
          Icons.visibility,
          Colors.grey,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Sow sow) {
    return Column(
      children: [
        // Marcar como preñada
        if (sow.estadoVisual == 'reposo')
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _controller.marcarCerdaPrenada(sow.id),
              icon: const Icon(Icons.favorite),
              label: const Text('Marcar como Preñada'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        
        // Registrar parto
        if (sow.estadoVisual == 'prenada') ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showRegisterBirthDialog(sow),
              icon: const Icon(Icons.child_care),
              label: const Text('Registrar Parto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
        
        // Acciones para cerda parida
        if (sow.estadoVisual == 'parida') ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showManagePigletsDialog(sow),
              icon: const Icon(Icons.edit),
              label: const Text('Gestionar Cerditos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _controller.volverCerdaAReposo(sow.id),
              icon: const Icon(Icons.refresh),
              label: const Text('Volver a Reposo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showManagePigletsDialog(Sow sow) {
    final noSobrevivieronController = TextEditingController(text: sow.cerditosNoSobrevivieron.toString());
    final importadosController = TextEditingController(text: sow.cerditosImportados.toString());
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Gestionar Cerditos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nacidos: ${sow.cerditosNacidos}'),
              const SizedBox(height: 16),
              TextField(
                controller: noSobrevivieronController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'No sobrevivieron',
                  prefixIcon: Icon(Icons.remove_circle),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: importadosController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Importados a engorda',
                  prefixIcon: Icon(Icons.import_export),
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
              onPressed: () {
                final noSobrevivieron = int.tryParse(noSobrevivieronController.text) ?? 0;
                final importados = int.tryParse(importadosController.text) ?? 0;
                
                _controller.quitarCerditosNoSobrevivieron(sow.id, noSobrevivieron);
                _controller.importarCerditos(sow.id, importados - sow.cerditosImportados);
                
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
