import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        children: [
          _buildProfileHeader(context),
          _buildProgressSection(context),
          _buildLottieAnimation(context),
          _buildCertificates(context),
          _buildMilestones(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            TPColors.primaryContainer.withValues(alpha: 0.08),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [TPColors.primaryContainer, TPColors.primary],
              ),
              boxShadow: [
                BoxShadow(
                  color: TPColors.primaryContainer.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                internProfile.name.split(' ').map((w) => w[0]).take(2).join(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          )
              .animate()
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                duration: 500.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(duration: 300.ms),
          const SizedBox(height: 16),
          Text(
            internProfile.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: TPColors.onSurface,
                ),
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
          const SizedBox(height: 4),
          Text(
            internProfile.department,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: TPColors.onSurfaceVariant,
                ),
          ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: GlassDecoration.glassTag(
                color: TPColors.secondaryContainer),
            child: Text(
              internProfile.batchId,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: TPColors.secondaryContainer,
                    fontSize: 11,
                  ),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                // Progress ring
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CustomPaint(
                    painter: _ProgressRingPainter(
                      progress: internProfile.completionPercent,
                      trackColor: TPColors.surfaceContainer,
                      fillColor: TPColors.secondaryContainer,
                    ),
                    child: Center(
                      child: Text(
                        '${(internProfile.completionPercent * 100).toInt()}%',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              color: TPColors.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Learning Progress',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontSize: 16,
                              color: TPColors.onSurface,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${internProfile.completedModules} of ${internProfile.totalModules} modules completed',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: TPColors.onSurfaceVariant,
                                ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(9999),
                        child: LinearProgressIndicator(
                          value: internProfile.completionPercent,
                          minHeight: 6,
                          backgroundColor: TPColors.surfaceContainer,
                          valueColor: AlwaysStoppedAnimation(
                              TPColors.secondaryContainer),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 500.ms, delay: 500.ms)
          .slideY(begin: 0.1, end: 0, duration: 500.ms),
    );
  }

  Widget _buildLottieAnimation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Lottie.asset(
                'json/global-delivery.json',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      'Animation failed to load',
                      style: TextStyle(color: TPColors.error),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Global Learning Delivery Active',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TPColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    ).animate()
     .fadeIn(duration: 500.ms, delay: 600.ms)
     .slideY(begin: 0.1, end: 0, duration: 500.ms);
  }

  Widget _buildCertificates(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CERTIFICATES EARNED',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: TPColors.onSurfaceVariant,
                  letterSpacing: 1,
                ),
          ),
          const SizedBox(height: 12),
          ...List.generate(internProfile.certificates.length, (index) {
            final cert = internProfile.certificates[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassCard(
                borderRadius: 12,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: TPColors.tertiaryFixedDim.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(cert.icon,
                          size: 20, color: TPColors.tertiaryFixedDim),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cert.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: TPColors.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            cert.date,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: TPColors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.workspace_premium,
                        size: 20, color: TPColors.tertiaryFixedDim),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(
                      duration: 400.ms, delay: (600 + index * 100).ms)
                  .slideX(begin: 0.1, end: 0, duration: 400.ms),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMilestones(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LEARNING MILESTONES',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: TPColors.onSurfaceVariant,
                  letterSpacing: 1,
                ),
          ),
          const SizedBox(height: 12),
          ...List.generate(internProfile.milestones.length, (index) {
            final milestone = internProfile.milestones[index];
            final isLast = index == internProfile.milestones.length - 1;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline
                  SizedBox(
                    width: 32,
                    child: Column(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: milestone.completed
                                ? TPColors.secondaryContainer
                                : TPColors.outlineVariant.withValues(alpha: 0.3),
                            border: Border.all(
                              color: milestone.completed
                                  ? TPColors.secondaryContainer
                                  : TPColors.outlineVariant,
                              width: 2,
                            ),
                          ),
                          child: milestone.completed
                              ? const Icon(Icons.check,
                                  size: 10, color: Colors.white)
                              : null,
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: milestone.completed
                                  ? TPColors.secondaryContainer
                                      .withValues(alpha: 0.3)
                                  : TPColors.outlineVariant
                                      .withValues(alpha: 0.2),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            milestone.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: milestone.completed
                                      ? TPColors.onSurface
                                      : TPColors.onSurfaceVariant,
                                  fontWeight: milestone.completed
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                ),
                          ),
                          Text(
                            milestone.date,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: TPColors.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: (800 + index * 80).ms),
            );
          }),
        ],
      ),
    );
  }
}

// Custom painter for the circular progress ring
class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color fillColor;

  _ProgressRingPainter({
    required this.progress,
    required this.trackColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 8.0;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Fill
    final fillPaint = Paint()
      ..color = fillColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      fillPaint,
    );

    // Glow at tip
    if (progress > 0) {
      final tipAngle = -pi / 2 + sweepAngle;
      final tipX = center.dx + radius * cos(tipAngle);
      final tipY = center.dy + radius * sin(tipAngle);
      final glowPaint = Paint()
        ..color = fillColor.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(Offset(tipX, tipY), 6, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
