import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/sow_model.dart';

class SowAnimationWidget extends StatefulWidget {
  final Sow sow;
  final bool isDayTime;

  const SowAnimationWidget({
    super.key,
    required this.sow,
    this.isDayTime = true,
  });

  @override
  State<SowAnimationWidget> createState() => _SowAnimationWidgetState();
}

class _SowAnimationWidgetState extends State<SowAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    // Parpadeo aleatorio
    _startRandomBlinking();
  }

  void _startRandomBlinking() {
    Future.delayed(Duration(milliseconds: 2000 + (DateTime.now().millisecond % 3000)), () {
      if (mounted) {
        _blinkController.forward().then((_) {
          _blinkController.reverse();
          _startRandomBlinking();
        });
      }
    });
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Fondo (corral o patio)
          _buildBackground(),
          
          // Cuerpo de la cerda
          AnimatedBuilder(
            animation: _breathingController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_breathingController.value * 0.05),
                child: _buildSowBody(),
              );
            },
          ),

          // Cerditos si está en estado "parida"
          if (widget.sow.estadoVisual == 'parida') ..._buildPiglets(),

          // Indicador de estado
          Positioned(
            top: 5,
            right: 5,
            child: _buildStatusIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: widget.isDayTime ? Colors.green.shade100 : Colors.indigo.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.brown.shade400,
          width: 2,
        ),
      ),
      child: widget.isDayTime
          ? Icon(Icons.grass, color: Colors.green.shade400, size: 20)
          : Icon(Icons.nightlight_round, color: Colors.indigo.shade400, size: 20),
    );
  }

  Widget _buildSowBody() {
    final pregnancyProgress = widget.sow.porcentajeEmbarazo;
    final isPregnant = widget.sow.estadoVisual == 'prenada';
    
    // Tamaño base más grande
    double baseSize = 40.0;
    double bellySizeMultiplier = 1.0;
    
    if (isPregnant) {
      // Incrementar tamaño de barriga basado en progreso del embarazo
      bellySizeMultiplier = 1.0 + (pregnancyProgress * 0.8);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Cuerpo principal
        Container(
          width: baseSize,
          height: baseSize * bellySizeMultiplier,
          decoration: BoxDecoration(
            color: Colors.pink.shade200,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        
        // Cabeza
        Positioned(
          top: -8,
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: Colors.pink.shade300,
              borderRadius: BorderRadius.circular(12.5),
            ),
          ),
        ),

        // Ojos
        Positioned(
          top: -5,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _blinkController,
                builder: (context, child) {
                  return Container(
                    width: 4,
                    height: _blinkController.value > 0.5 ? 1 : 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _blinkController,
                builder: (context, child) {
                  return Container(
                    width: 4,
                    height: _blinkController.value > 0.5 ? 1 : 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // Hocico
        Positioned(
          top: 2,
          child: Container(
            width: 8,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.pink.shade400,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),

        // Patas
        Positioned(
          bottom: -8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) => Container(
              width: 6,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.pink.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            )),
          ),
        ),

        // Cola
        Positioned(
          right: -6,
          child: Container(
            width: 8,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.pink.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          )
          .animate(onPlay: (controller) => controller.repeat())
          .rotate(begin: -0.1, end: 0.1, duration: 1.seconds),
        ),
      ],
    );
  }

  List<Widget> _buildPiglets() {
    final pigletCount = widget.sow.cerditosNacidos;
    final availablePiglets = pigletCount - widget.sow.cerditosNoSobrevivieron - widget.sow.cerditosImportados;
    
    return List.generate(availablePiglets.clamp(0, 6), (index) {
      final angle = (index * 60.0) * (3.14159 / 180); // Convertir a radianes
      final radius = 35.0;
      
      return Positioned(
        left: 60 + (radius * 0.8) * math.cos(angle) - 6,
        top: 60 + (radius * 0.8) * math.sin(angle) - 6,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.pink.shade100,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.pink.shade300, width: 1),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(delay: Duration(milliseconds: index * 200), duration: 2.seconds)
        .moveY(begin: 0, end: -2, duration: 1.seconds)
        .then()
        .moveY(begin: -2, end: 0, duration: 1.seconds),
      );
    });
  }

  Widget _buildStatusIndicator() {
    Color indicatorColor;
    IconData icon;
    
    switch (widget.sow.estadoVisual) {
      case 'prenada':
        indicatorColor = Colors.orange;
        icon = Icons.favorite;
        break;
      case 'parida':
        indicatorColor = Colors.green;
        icon = Icons.family_restroom;
        break;
      default:
        indicatorColor = Colors.blue;
        icon = Icons.pets;
    }

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: indicatorColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 12,
      ),
    );
  }
}

