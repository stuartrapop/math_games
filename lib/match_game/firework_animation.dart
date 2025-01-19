import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class FireworkAnimation extends PositionComponent {
  FireworkAnimation() {
    // Set a short lifespan to automatically remove the component after animation
    Future.delayed(const Duration(seconds: 2), () {
      removeFromParent();
    });
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final particles = ParticleSystemComponent(
      particle: Particle.generate(
        count: 50,
        lifespan: 1.0,
        generator: (i) {
          final random = Random();
          final speed = random.nextDouble() * 100 + 50; // Random speed
          final angle = random.nextDouble() * 2 * pi; // Random direction
          final color = Color.lerp(
            Colors.orange,
            Colors.red,
            random.nextDouble(),
          )!;

          return AcceleratedParticle(
            acceleration: Vector2(0, 50), // Gravity effect
            speed: Vector2(speed * cos(angle), speed * sin(angle)),
            position: position.clone(),
            child: CircleParticle(
              radius: 2.5,
              paint: Paint()..color = color,
            ),
          );
        },
      ),
    );

    add(particles);
  }
}
