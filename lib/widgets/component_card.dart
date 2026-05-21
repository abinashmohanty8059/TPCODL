import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/substation_equipment.dart';

class ComponentCard extends StatelessWidget {
  final SubstationEquipment equipment;
  final VoidCallback? onTap;

  const ComponentCard({super.key, required this.equipment, this.onTap});

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: TPColors.outlineVariant.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: TPColors.primaryContainer.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area with white gradient overlay and category icon badge
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  color: TPColors.surfaceContainerLow.withValues(alpha: 0.5),
                  child: Image.asset(
                    equipment.assetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          _getCategoryIcon(equipment.category),
                          size: 64,
                          color: TPColors.primaryContainer.withValues(alpha: 0.3),
                        ),
                      );
                    },
                  ),
                ),
                // Premium white/transparent gradient overlay matching original UI
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                // Circular icon badge in the top right (matching original UI)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: TPColors.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      _getCategoryIcon(equipment.category),
                      size: 20,
                      color: TPColors.secondary,
                    ),
                  ),
                ),
                // Node ID badge in top left
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'NODE #${equipment.id}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Equipment details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    equipment.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 18,
                          color: TPColors.onSurface,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    equipment.purpose,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: TPColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 12),
                  // Tags at the bottom (using Wrap to prevent overflows)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTag(
                        context,
                        equipment.category.toUpperCase(),
                        TPColors.secondaryContainer,
                      ),
                      _buildTag(
                        context,
                        '${equipment.visibleDetails.length} VISIBLE',
                        Colors.blue.shade600,
                      ),
                      _buildTag(
                        context,
                        '${equipment.technicalDetails.length} SPECS',
                        TPColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: GlassDecoration.glassTag(color: color),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}

class PulsingLed extends StatefulWidget {
  final Color color;
  const PulsingLed({super.key, required this.color});

  @override
  State<PulsingLed> createState() => _PulsingLedState();
}

class _PulsingLedState extends State<PulsingLed>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.8),
                  blurRadius: 5,
                  spreadRadius: 1.5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
