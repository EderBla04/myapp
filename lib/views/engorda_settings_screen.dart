import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/fattening_pig_controller.dart';
import '../theme/theme.dart';
import '../utils/error_handler.dart';

class EngordaSettingsScreen extends StatefulWidget {
  const EngordaSettingsScreen({super.key});

  @override
  State<EngordaSettingsScreen> createState() => _EngordaSettingsScreenState();
}

class _EngordaSettingsScreenState extends State<EngordaSettingsScreen> {
  final FatteningPigController _controller = FatteningPigController();
  final TextEditingController _priceController = TextEditingController();
  final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _priceController.text = _controller.getPrecioGlobalPorKilo().toString();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _savePrice() async {
    final price = double.tryParse(_priceController.text);
    if (price != null && price > 0) {
      await _controller.updatePrecioGlobalPorKilo(price);
      if (mounted) {
        ErrorHandler.showSuccessSnackBar(
          context, 'Precio actualizado correctamente'
        );
      }
    } else {
      ErrorHandler.showErrorSnackBar(
        context, 'Por favor ingresa un precio válido'
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = _controller.getEstadisticas();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Engorda'),
        backgroundColor: PorciColors.pigPink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de estadísticas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.analytics, color: PorciColors.pigPink),
                        const SizedBox(width: 8),
                        Text(
                          'Resumen General',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Cerdos',
                            stats['totalCerdos'].toString(),
                            Icons.agriculture,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Manuales',
                            stats['manuales'].toString(),
                            Icons.add,
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Importados',
                            stats['importados'].toString(),
                            Icons.import_export,
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Peso Total',
                            '${stats['pesoTotal'].toInt()} kg',
                            Icons.monitor_weight,
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      'Ganancia Total',
                      currencyFormatter.format(stats['gananciaTotal']),
                      Icons.attach_money,
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Configuración de precio
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.attach_money, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          'Precio por Kilogramo',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Establece el precio de venta por kilogramo de cerdo en pie para calcular las ganancias estimadas. Este precio se aplicará al peso actual de cada cerdo.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Precio por kilogramo',
                              prefixIcon: const Icon(Icons.attach_money),
                              suffixText: 'pesos/kg',
                              helperText: 'Precio actual: ${currencyFormatter.format(_controller.getPrecioGlobalPorKilo())}/kg',
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _savePrice,
                          icon: const Icon(Icons.save),
                          label: const Text('Guardar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Información adicional
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
                          'Información',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoItem(
                      'Origen Manual',
                      'Cerdos agregados directamente a la sección de engorda.',
                      Icons.add,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoItem(
                      'Origen Importado',
                      'Cerdos traidos desde la sección de crianza automáticamente.',
                      Icons.import_export,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoItem(
                      'Cálculo de ganancias',
                      'Ganancia = Peso actual del cerdo × Precio por kilogramo',
                      Icons.calculate,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoItem(
                      'Seguimiento de peso',
                      'Registra el peso regularmente para ver el crecimiento y actualizar ganancias.',
                      Icons.trending_up,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String description, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}