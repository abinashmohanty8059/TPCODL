import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets/glass_card.dart';
import '../widgets/stat_card.dart';
import 'photos_view_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onNavigateToSubstation;

  const HomeScreen({super.key, this.onNavigateToSubstation});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero section
          _buildHeroSection(context),
          // Live Metrics
          _buildLiveMetrics(context),
          // Core Systems
          _buildCoreSystems(context),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
                'Welcome Intern,',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: TPColors.primary),
              )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideX(begin: -0.1, end: 0, duration: 600.ms),
          const SizedBox(height: 4),
          Text(
            'Explore TPCODL Infrastructure.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: TPColors.onSurfaceVariant),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
          const SizedBox(height: 16),
          // Banner image area
          Container(
                height: 192,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [TPColors.primaryContainer, TPColors.primary],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: TPColors.primaryContainer.withValues(alpha: 0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // Background pattern
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Icon(
                        Icons.bolt,
                        size: 200,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      bottom: -20,
                      child: Icon(
                        Icons.electrical_services,
                        size: 150,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Text(
                              '⚡ TPCODL',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Power Distribution\nInfrastructure',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(color: Colors.white, fontSize: 22),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Learn about substations, SCADA, and grid operations',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                          ),
                        ],
                      ),
                    ),
                    // Search bar overlay
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: GlassCard(
                        borderRadius: 9999,
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.search,
                          size: 20,
                          color: TPColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 300.ms)
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1, 1),
                duration: 600.ms,
              ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLiveMetrics(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'LIVE METRICS',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: TPColors.onSurfaceVariant,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 155,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: liveMetrics.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final metric = liveMetrics[index];
              return GestureDetector(
                onTap: () {
                  if (metric.label.toLowerCase() == 'photos') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PhotosViewScreen(),
                      ),
                    );
                  }
                },
                child: StatCard(data: metric)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: (index * 100).ms)
                    .slideX(begin: 0.2, end: 0, duration: 400.ms),
              );
            },
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildCoreSystems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CORE SYSTEMS',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: TPColors.onSurfaceVariant,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(coreSystemModules.length, (index) {
            final module = coreSystemModules[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  if (module.title.toLowerCase() == 'substation') {
                    onNavigateToSubstation?.call();
                  }
                },
                child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(255, 7, 30, 101),
                              Color.fromARGB(255, 31, 155, 233),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: TPColors.secondaryContainer.withValues(
                              alpha: 0.35,
                            ),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                module.icon,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    module.title,
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    module.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(9999),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: (index * 120 + 400).ms)
                      .slideX(begin: 0.1, end: 0, duration: 400.ms),
              ),
            );
          }),
        ],
      ),
    );
  }
}
