import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../models/substation_equipment.dart';
import '../widgets/component_card.dart';
import '../widgets/glass_card.dart';
import 'component_detail_screen.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;
  final String description;
  final String coverImage;
  final String voltageClass;
  final String priority;
  final List<SubstationEquipment> equipmentItems;

  const CategoryDetailScreen({
    super.key,
    required this.categoryName,
    required this.description,
    required this.coverImage,
    required this.voltageClass,
    required this.priority,
    required this.equipmentItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: TPColors.lightBlueGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            // Sliver App Bar with Category Cover Photo
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              backgroundColor: TPColors.primaryContainer,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
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
                    Image.asset(
                      coverImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: TPColors.primaryContainer,
                          child: const Center(
                            child: Icon(Icons.electrical_services, size: 64, color: Colors.white24),
                          ),
                        );
                      },
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                            stops: const [0.0, 0.4, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade800,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.blue.shade300.withValues(alpha: 0.5)),
                                ),
                                child: Text(
                                  voltageClass,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: priority == 'CRITICAL' ? Colors.red.shade900 : Colors.amber.shade900,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: priority == 'CRITICAL' ? Colors.red.shade300 : Colors.amber.shade300,
                                  ),
                                ),
                                child: Text(
                                  priority,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            categoryName,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Category overview & list of sub-equipments
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overview header
                    _buildSectionHeader(context, 'CATEGORY OVERVIEW'),
                    const SizedBox(height: 10),
                    GlassCard(
                      borderRadius: 12,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: TPColors.onSurface,
                              height: 1.5,
                              fontSize: 14.5,
                            ),
                      ),
                    ).animate().fadeIn(duration: 400.ms),

                    const SizedBox(height: 28),

                    // Sub-equipment list header
                    _buildSectionHeader(
                      context,
                      'MONITORED SYSTEM ASSETS (${equipmentItems.length})',
                    ),
                    const SizedBox(height: 12),

                    // Scrollable list of equipment cards
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: equipmentItems.length,
                      itemBuilder: (context, index) {
                        final eq = equipmentItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ComponentCard(
                            equipment: eq,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ComponentDetailScreen(equipment: eq),
                                ),
                              );
                            },
                          )
                              .animate()
                              .fadeIn(duration: 400.ms, delay: (index * 50).clamp(0, 300).ms)
                              .slideY(begin: 0.05, end: 0),
                        );
                      },
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

  Widget _buildSectionHeader(BuildContext context, String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: TPColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: TPColors.onSurfaceVariant,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                fontSize: 12,
              ),
        ),
      ],
    );
  }
}
