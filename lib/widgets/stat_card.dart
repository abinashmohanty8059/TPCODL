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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (data.lottieAsset != null)
              Expanded(
                child: Lottie.asset(
                  data.lottieAsset!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(data.icon, size: 36, color: TPColors.primary),
                    );
                  },
                ),
              )
            else
              Expanded(
                child: Center(
                  child: Icon(data.icon, size: 36, color: TPColors.primary),
                ),
              ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: TPColors.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        data.value,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: TPColors.onSurface,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (data.isLive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: TPColors.secondaryContainer.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'LIVE',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: TPColors.secondaryContainer,
                            fontWeight: FontWeight.w800,
                            fontSize: 8,
                          ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
