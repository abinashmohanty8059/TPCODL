import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets/glass_card.dart';

class ComponentDetailScreen extends StatelessWidget {
  final SubstationComponent component;

  const ComponentDetailScreen({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TPColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero app bar
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: TPColors.primaryContainer,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          TPColors.primary,
                          TPColors.primaryContainer,
                        ],
                      ),
                    ),
                  ),
                  // Pattern overlay
                  Positioned(
                    right: -40,
                    bottom: -40,
                    child: Icon(
                      component.icon,
                      size: 220,
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  // Content
                  Positioned(
                    bottom: 60,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tags
                        Row(
                          children: [
                            _buildTag(component.voltageClass,
                                TPColors.secondaryFixed),
                            const SizedBox(width: 8),
                            _buildTag(
                                component.priority, component.priorityColor),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          component.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview
                  Text(
                    'OVERVIEW',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: TPColors.onSurfaceVariant,
                          letterSpacing: 1,
                        ),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 8),
                  Text(
                    component.detailedDescription,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TPColors.onSurface,
                          height: 1.6,
                        ),
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                  const SizedBox(height: 28),

                  // Technical Specifications
                  Text(
                    'TECHNICAL SPECIFICATIONS',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: TPColors.onSurfaceVariant,
                          letterSpacing: 1,
                        ),
                  ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                  const SizedBox(height: 12),
                  GlassCard(
                    borderRadius: 16,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: List.generate(component.specs.length, (i) {
                        final parts = component.specs[i].split(': ');
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom:
                                i < component.specs.length - 1 ? 12 : 0,
                          ),
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
                              const SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: TPColors.onSurface,
                                        ),
                                    children: [
                                      TextSpan(
                                        text: parts.isNotEmpty
                                            ? '${parts[0]}: '
                                            : '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text: parts.length > 1
                                            ? parts.sublist(1).join(': ')
                                            : '',
                                        style: TextStyle(
                                          color: TPColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(
                      begin: 0.05, end: 0, duration: 400.ms),

                  const SizedBox(height: 28),

                  // Key Features
                  Text(
                    'KEY FEATURES',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: TPColors.onSurfaceVariant,
                          letterSpacing: 1,
                        ),
                  ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                  const SizedBox(height: 12),
                  ...List.generate(component.features.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: TPColors.primaryContainer
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.check,
                              size: 14,
                              color: TPColors.primaryContainer,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              component.features[i],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: TPColors.onSurface,
                                    height: 1.4,
                                  ),
                            ),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(
                              duration: 300.ms, delay: (500 + i * 80).ms)
                          .slideX(begin: 0.05, end: 0, duration: 300.ms),
                    );
                  }),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
          color: Colors.white,
        ),
      ),
    );
  }
}
