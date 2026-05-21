import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../models/substation_equipment.dart';
import '../widgets/glass_card.dart';

class ComponentDetailScreen extends StatelessWidget {
  final SubstationEquipment equipment;

  const ComponentDetailScreen({super.key, required this.equipment});

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Transformer Systems':
        return Icons.electric_meter;
      case 'RTU Systems':
        return Icons.router;
      case 'Protection Relays':
        return Icons.settings_system_daydream;
      case 'Smart Metering':
        return Icons.bolt;
      case 'Communication Network':
        return Icons.settings_ethernet;
      case 'ACDB Panels':
        return Icons.power;
      case 'Control Systems':
        return Icons.toggle_on;
      case 'Switchgear':
        return Icons.switch_access_shortcut;
      case 'SCADA Infrastructure':
        return Icons.dns;
      default:
        return Icons.electrical_services;
    }
  }

  void _openImageViewer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              equipment.name,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.asset(
                equipment.assetPath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, color: Colors.white, size: 80);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

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
            // Dynamic image/hero header
            SliverAppBar(
              expandedHeight: 280,
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
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: const Icon(Icons.fullscreen, color: Colors.white, size: 20),
                  ),
                  onPressed: () => _openImageViewer(context),
                ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Main real image
                    Image.asset(
                      equipment.assetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: TPColors.primaryContainer,
                          child: Center(
                            child: Icon(
                              _getCategoryIcon(equipment.category),
                              size: 96,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                        );
                      },
                    ),
                    // Glassy/dark gradient overlays
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
                    // Header label overlay
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
                                  color: Colors.cyan.shade800,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.cyan.shade300.withValues(alpha: 0.5)),
                                ),
                                child: Text(
                                  equipment.category.toUpperCase(),
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                ),
                                child: Text(
                                  'NODE #${equipment.id}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            equipment.name,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22,
                                  shadows: [
                                    const Shadow(
                                      color: Colors.black,
                                      offset: Offset(0, 2),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main body panels
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SCADA live telemetry status strip
                    _buildTelemetryBar(context),
                    const SizedBox(height: 24),

                    // Purpose Section
                    _buildSectionHeader(context, 'EQUIPMENT PURPOSE'),
                    const SizedBox(height: 10),
                    GlassCard(
                      borderRadius: 12,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        equipment.purpose,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: TPColors.onSurface,
                              height: 1.5,
                              fontSize: 14,
                            ),
                      ),
                    ).animate().fadeIn(duration: 400.ms),

                    const SizedBox(height: 24),

                    // Visible Details / Alarm indicators
                    if (equipment.visibleDetails.isNotEmpty) ...[
                      _buildSectionHeader(context, 'VISIBLE DETAILS & SYSTEM ASSETS'),
                      const SizedBox(height: 10),
                      GlassCard(
                        borderRadius: 12,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: List.generate(equipment.visibleDetails.length, (index) {
                            final detail = equipment.visibleDetails[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index < equipment.visibleDetails.length - 1 ? 12 : 0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.visibility,
                                    size: 16,
                                    color: Colors.blue.shade600,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      detail,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: TPColors.onSurface,
                                            height: 1.3,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                      const SizedBox(height: 24),
                    ],

                    // Technical Specifications (if present)
                    if (equipment.technicalDetails.isNotEmpty) ...[
                      _buildSectionHeader(context, 'TECHNICAL SPECIFICATIONS'),
                      const SizedBox(height: 10),
                      GlassCard(
                        borderRadius: 12,
                        padding: const EdgeInsets.all(16),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1.2),
                            1: FlexColumnWidth(1.8),
                          },
                          children: equipment.technicalDetails.entries.map((entry) {
                            final isGeneratedKey = entry.key.startsWith('Detail ');
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    isGeneratedKey ? 'Spec' : entry.key,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: TPColors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    entry.value,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: TPColors.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                      const SizedBox(height: 24),
                    ],

                    // Functional Notes Section
                    if (equipment.functionalNotes.isNotEmpty) ...[
                      _buildSectionHeader(context, 'OPERATIONAL & FUNCTIONAL NOTES'),
                      const SizedBox(height: 10),
                      ...List.generate(equipment.functionalNotes.length, (index) {
                        final note = equipment.functionalNotes[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.green.shade200.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 18,
                                color: Colors.green.shade700,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  note,
                                  style: TextStyle(
                                    color: Colors.green.shade900,
                                    fontSize: 12.5,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 300.ms, delay: (250 + index * 60).ms)
                            .slideX(begin: 0.05, end: 0, duration: 300.ms);
                      }),
                      const SizedBox(height: 40),
                    ],
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

  Widget _buildTelemetryBar(BuildContext context) {
    return GlassCard(
      borderRadius: 12,
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTelemetryMetric('LINK STATUS', 'ONLINE', Colors.green, true),
          _buildDivider(),
          _buildTelemetryMetric('CONTROL MODE', 'REMOTE', Colors.blue, false),
          _buildDivider(),
          _buildTelemetryMetric('LATENCY', '< 4 ms', Colors.purple, false),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 24,
      color: TPColors.outlineVariant.withValues(alpha: 0.3),
    );
  }

  Widget _buildTelemetryMetric(String label, String value, Color color, bool isPulseLed) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: TPColors.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isPulseLed) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 4, spreadRadius: 1),
                  ],
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
