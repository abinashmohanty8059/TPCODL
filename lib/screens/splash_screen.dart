import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Navigate to home after 3 seconds
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/main');
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TPColors.splashBackground,
      body: Stack(
        children: [
          // Floating particles
          ...List.generate(20, (i) => _buildParticle(i)),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Concentric circles (pulse rings + glowing logo)
                SizedBox(
                  width: 320,
                  height: 320,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Concentric animated pulse rings
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              _buildPulseRing(160, 0),
                              _buildPulseRing(240, 0.33),
                              _buildPulseRing(320, 0.66),
                            ],
                          );
                        },
                      ),
                      // Glowing logo
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Glow effect
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: TPColors.secondaryFixed.withValues(alpha: 0.2),
                                  blurRadius: 60,
                                  spreadRadius: 20,
                                ),
                              ],
                            ),
                          ),
                          // Logo icon
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  TPColors.primaryContainer,
                                  TPColors.primary,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      TPColors.secondaryFixed.withValues(alpha: 0.5),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.bolt,
                              size: 52,
                              color: Colors.white,
                            ),
                          )
                              .animate(
                                onPlay: (c) => c.repeat(reverse: true),
                              )
                              .scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.05, 1.05),
                                duration: 2000.ms,
                                curve: Curves.easeInOut,
                              ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                // Title
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w700,
                        ),
                    children: [
                      const TextSpan(text: 'TPCODL '),
                      TextSpan(
                        text: 'INTERN',
                        style: TextStyle(color: TPColors.secondaryFixed),
                      ),
                      const TextSpan(text: '\nLEARNING'),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 800.ms, delay: 300.ms)
                    .slideY(begin: 0.3, end: 0, duration: 800.ms),
                const SizedBox(height: 16),
                // Subtitle
                Text(
                  'POWERING KNOWLEDGE',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: TPColors.secondaryFixedDim.withValues(alpha: 0.8),
                        letterSpacing: 6,
                        fontSize: 14,
                      ),
                )
                    .animate()
                    .fadeIn(duration: 800.ms, delay: 600.ms),
                const SizedBox(height: 48),
                // Bouncing dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: TPColors.secondaryFixed,
                      ),
                    )
                        .animate(
                          onPlay: (c) => c.repeat(),
                        )
                        .slideY(
                          begin: 0,
                          end: -1,
                          duration: 600.ms,
                          delay: (index * 100).ms,
                          curve: Curves.easeInOut,
                        )
                        .then()
                        .slideY(
                          begin: -1,
                          end: 0,
                          duration: 600.ms,
                          curve: Curves.easeInOut,
                        );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulseRing(double size, double delayFraction) {
    final value = (_pulseController.value + delayFraction) % 1.0;
    final scale = 1.0 + (value * 0.5);
    final opacity = (1.0 - value) * 0.3;

    return Transform.scale(
      scale: scale,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: TPColors.secondaryFixed.withValues(alpha: opacity),
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildParticle(int index) {
    final random = Random(index);
    final left = random.nextDouble() * 400;
    final top = random.nextDouble() * 800;
    final size = random.nextDouble() * 4 + 1;
    final delay = random.nextInt(4000);
    final duration = random.nextInt(3000) + 3000;

    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: TPColors.secondaryFixed,
        ),
      )
          .animate(
            onPlay: (c) => c.repeat(),
          )
          .fadeIn(duration: (duration ~/ 2).ms, delay: delay.ms)
          .slideY(begin: 0, end: -2, duration: duration.ms)
          .then()
          .fadeOut(duration: (duration ~/ 2).ms),
    );
  }
}
