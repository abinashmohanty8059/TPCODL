import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../data.dart';

class SystemsScreen extends StatelessWidget {
  const SystemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildSystemCards(context),
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
            'Systems',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: TPColors.onSurface,
                ),
          ).animate().fadeIn(duration: 500.ms),
          const SizedBox(height: 4),
          Text(
            'Core operational systems that power the TPCODL distribution network.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TPColors.onSurfaceVariant,
                ),
          ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSystemCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(systemsData.length, (index) {
          final system = systemsData[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _SystemCard(system: system, index: index)
                .animate()
                .fadeIn(duration: 500.ms, delay: (index * 150 + 300).ms)
                .slideY(begin: 0.1, end: 0, duration: 500.ms),
          );
        }),
      ),
    );
  }
}

class _SystemCard extends StatefulWidget {
  final SystemInfo system;
  final int index;

  const _SystemCard({required this.system, required this.index});

  @override
  State<_SystemCard> createState() => _SystemCardState();
}

class _SystemCardState extends State<_SystemCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final system = widget.system;
    final gradientColors = [
      [TPColors.primary, TPColors.primaryContainer],
      [const Color(0xFF004162), TPColors.secondary],
      [TPColors.inverseSurface, const Color(0xFF3A4553)],
    ];
    final colors = gradientColors[widget.index % gradientColors.length];

    return Column(
      children: [
        // Main card
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors[0].withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Background icon
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    system.icon,
                    size: 150,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(system.icon,
                                size: 32, color: Colors.white),
                          ),
                          const Spacer(),
                          AnimatedRotation(
                            turns: _expanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: const Icon(Icons.expand_more,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        system.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        system.description,
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Expanded content
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: TPColors.surfaceContainerLowest,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(
                color: TPColors.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  system.detailText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: TPColors.onSurface,
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  'KEY HIGHLIGHTS',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: TPColors.onSurfaceVariant,
                        letterSpacing: 1,
                      ),
                ),
                const SizedBox(height: 8),
                ...system.keyPoints.map((point) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: TPColors.secondaryContainer,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              point,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: TPColors.onSurface,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
