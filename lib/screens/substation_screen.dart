import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets/component_card.dart';
import 'component_detail_screen.dart';

class SubstationScreen extends StatelessWidget {
  const SubstationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildComponentGrid(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Substation Components',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: TPColors.onSurface,
                ),
          ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: 8),
          // Animated pulse line
          _PulseLine().animate().fadeIn(duration: 600.ms, delay: 200.ms),
          const SizedBox(height: 12),
          Text(
            'Explore the critical hardware that powers the modern grid. High-fidelity utility components engineered for precision and reliability.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TPColors.onSurfaceVariant,
                ),
          ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildComponentGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(substationComponents.length, (index) {
          final component = substationComponents[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ComponentCard(
              component: component,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        ComponentDetailScreen(component: component),
                  ),
                );
              },
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: (index * 100 + 300).ms)
                .slideY(begin: 0.1, end: 0, duration: 400.ms),
          );
        }),
      ),
    );
  }
}

// Animated pulse line widget matching the Stitch design
class _PulseLine extends StatefulWidget {
  @override
  State<_PulseLine> createState() => _PulseLineState();
}

class _PulseLineState extends State<_PulseLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: 2,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                TPColors.secondaryContainer,
                Colors.transparent,
              ],
              stops: [
                (_controller.value - 0.3).clamp(0.0, 1.0),
                _controller.value,
                (_controller.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
