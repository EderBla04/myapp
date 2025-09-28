import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/fattening_pig_model.dart';

class PigAnimationWidget extends StatefulWidget {
  final FatteningPig pig;
  final bool isDayTime;

  const PigAnimationWidget({
    super.key,
    required this.pig,
    this.isDayTime = true,
  });

  @override
  State<PigAnimationWidget> createState() => _PigAnimationWidgetState();
}

class _PigAnimationWidgetState extends State<PigAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _walkController;
  late AnimationController _breathingController;
  late AnimationController _eatController;
  bool isEating = false;

  @override
  void initState() {
    super.initState();
    
    _walkController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _breathingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _eatController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _startRandomAnimations();
  }

  void _startRandomAnimations() {
    if (!mounted) return;
    
    // Caminar aleatoriamente
    Future.delayed(Duration(milliseconds: 3000 + (math.Random().nextInt(4000))), () {
      if (mounted && widget.isDayTime) {
        _walkController.forward().then((_) {
          _walkController.reverse();
          _startRandomAnimations();
        });
      } else {
        _startRandomAnimations();
      }
    });

    // Comer aleatoriamente
    Future.delayed(Duration(milliseconds: 2000 + (math.Random().nextInt(3000))), () {
      if (mounted && widget.isDayTime) {
        setState(() => isEating = true);
        _eatController.forward().then((_) {
          _eatController.reverse().then((_) {
            if (mounted) {
              setState(() => isEating = false);
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _walkController.dispose();
    _breathingController.dispose();
    _eatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Fondo (corral)
          _buildBackground(),
          
          // Cuerpo del cerdo
          AnimatedBuilder(
            animation: Listenable.merge([_breathingController, _walkController]),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  widget.isDayTime ? _walkController.value * 20 - 10 : 0,
                  0,
                ),
                child: Transform.scale(
                  scale: 1.0 + (_breathingController.value * 0.03),
                  child: _buildPigBody(),
                ),
              );
            },
          ),

          // Comida si está comiendo
          if (isEating && widget.isDayTime) _buildFood(),

          // Indicador de peso
          Positioned(
            bottom: 5,
            right: 5,
            child: _buildWeightIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: widget.isDayTime 
            ? Colors.brown.shade100 
            : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.brown.shade600,
          width: 2,
        ),
      ),
      child: widget.isDayTime
          ? Icon(Icons.wb_sunny, color: Colors.orange.shade400, size: 16)
          : Icon(Icons.bedtime, color: Colors.blue.shade300, size: 16),
    );
  }

  Widget _buildPigBody() {
    // Tamaño basado en peso del cerdo
    final weightFactor = (widget.pig.pesoActual / 100.0).clamp(0.8, 2.0);
    final baseSize = 30.0 * weightFactor;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Cuerpo principal
        Container(
          width: baseSize,
          height: baseSize * 0.8,
          decoration: BoxDecoration(
            color: Colors.pink.shade300,
            borderRadius: BorderRadius.circular(baseSize * 0.4),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.pink.shade200,
                Colors.pink.shade400,
              ],
            ),
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
          top: -baseSize * 0.15,
          child: Container(
            width: baseSize * 0.7,
            height: baseSize * 0.7,
            decoration: BoxDecoration(
              color: Colors.pink.shade400,
              borderRadius: BorderRadius.circular(baseSize * 0.35),
            ),
          ),
        ),

        // Ojos
        Positioned(
          top: -baseSize * 0.05,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEye(baseSize),
              SizedBox(width: baseSize * 0.1),
              _buildEye(baseSize),
            ],
          ),
        ),

        // Hocico
        Positioned(
          top: baseSize * 0.1,
          child: AnimatedBuilder(
            animation: _eatController,
            builder: (context, child) {
              return Transform.scale(
                scale: isEating ? 1.0 + (_eatController.value * 0.2) : 1.0,
                child: Container(
                  width: baseSize * 0.3,
                  height: baseSize * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade500,
                    borderRadius: BorderRadius.circular(baseSize * 0.1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 2,
                        height: 2,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 2,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Orejas
        Positioned(
          top: -baseSize * 0.25,
          left: baseSize * 0.1,
          child: Container(
            width: baseSize * 0.2,
            height: baseSize * 0.3,
            decoration: BoxDecoration(
              color: Colors.pink.shade300,
              borderRadius: BorderRadius.circular(baseSize * 0.1),
            ),
          )
          .animate(onPlay: (controller) => controller.repeat())
          .rotate(begin: -0.1, end: 0.1, duration: 2.seconds),
        ),
        Positioned(
          top: -baseSize * 0.25,
          right: baseSize * 0.1,
          child: Container(
            width: baseSize * 0.2,
            height: baseSize * 0.3,
            decoration: BoxDecoration(
              color: Colors.pink.shade300,
              borderRadius: BorderRadius.circular(baseSize * 0.1),
            ),
          )
          .animate(onPlay: (controller) => controller.repeat())
          .rotate(begin: 0.1, end: -0.1, duration: 2.seconds),
        ),

        // Patas
        Positioned(
          bottom: -baseSize * 0.2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) => 
              AnimatedBuilder(
                animation: _walkController,
                builder: (context, child) {
                  final offset = widget.isDayTime ? 
                    math.sin(_walkController.value * 2 * math.pi + index * math.pi) * 2 : 0.0;
                  return Transform.translate(
                    offset: Offset(0, offset),
                    child: Container(
                      width: baseSize * 0.15,
                      height: baseSize * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.pink.shade400,
                        borderRadius: BorderRadius.circular(baseSize * 0.075),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        // Cola
        Positioned(
          right: -baseSize * 0.1,
          child: Container(
            width: baseSize * 0.2,
            height: baseSize * 0.1,
            decoration: BoxDecoration(
              color: Colors.pink.shade400,
              borderRadius: BorderRadius.circular(baseSize * 0.05),
            ),
          )
          .animate(onPlay: (controller) => controller.repeat())
          .rotate(begin: -0.2, end: 0.2, duration: 1.5.seconds),
        ),
      ],
    );
  }

  Widget _buildEye(double baseSize) {
    return Container(
      width: baseSize * 0.1,
      height: baseSize * 0.1,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildFood() {
    return Positioned(
      bottom: 25,
      child: AnimatedBuilder(
        animation: _eatController,
        builder: (context, child) {
          return Opacity(
            opacity: 1.0 - _eatController.value,
            child: Container(
              width: 15,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.brown.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: List.generate(3, (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeightIndicator() {
    final weight = widget.pig.pesoActual;
    Color weightColor;
    
    if (weight < 50) {
      weightColor = Colors.red;
    } else if (weight < 80) {
      weightColor = Colors.orange;
    } else {
      weightColor = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: weightColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        '${weight.toInt()}kg',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}