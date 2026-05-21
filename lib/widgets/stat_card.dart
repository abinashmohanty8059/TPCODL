import 'package:flutter/material.dart';
import '../theme.dart';
import '../data.dart';
import 'glass_card.dart';

class StatCard extends StatelessWidget {
  final StatData data;

  const StatCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 8,
      borderColor: TPColors.secondaryFixed.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: TPColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Icon(data.icon, size: 18, color: TPColors.primary),
                ),
                if (data.isLive)
                  Text(
                    'LIVE',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: TPColors.secondaryContainer,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          fontSize: 10,
                        ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              data.value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: TPColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 1),
            Text(
              data.label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TPColors.onSurfaceVariant,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
