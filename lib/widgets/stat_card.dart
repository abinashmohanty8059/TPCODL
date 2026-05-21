import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme.dart';
import '../data.dart';
import 'glass_card.dart';

class StatCard extends StatelessWidget {
  final StatData data;

  const StatCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 16,
      borderColor: TPColors.secondaryFixed.withValues(alpha: 0.35),
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: 150,
        height: 125,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.lottieAsset != null)
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: TPColors.surfaceContainer.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Lottie.asset(
                      data.lottieAsset!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(data.icon, size: 20, color: TPColors.primary),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: TPColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Icon(data.icon, size: 20, color: TPColors.primary),
                  ),
                if (data.isLive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: TPColors.secondaryContainer.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'LIVE',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: TPColors.secondaryContainer,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            fontSize: 9,
                          ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              data.value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: TPColors.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: 1),
            Text(
              data.label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TPColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
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
