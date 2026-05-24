import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/pss_circuit.dart';
import '../services/pss_circuit_service.dart';
import '../theme.dart';
import '../widgets/glass_card.dart';
import 'pss_web_view_screen.dart';

class PssCircuitsScreen extends StatefulWidget {
  const PssCircuitsScreen({super.key});

  @override
  State<PssCircuitsScreen> createState() => _PssCircuitsScreenState();
}

class _PssCircuitsScreenState extends State<PssCircuitsScreen> {
  late Future<List<PssCircuit>> _future;

  @override
  void initState() {
    super.initState();
    _future = PssCircuitService.fetchActiveCircuits();
  }

  /// Routes based on content_type and open_in_app flag:
  /// - open_in_app == true  → in-app WebView (web) or image dialog (image)
  /// - open_in_app == false → external browser via url_launcher
  void _openContent(BuildContext context, PssCircuit circuit) async {
    if (!circuit.openInApp) {
      // External browser
      final uri = Uri.parse(circuit.contentUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return;
    }

    // In-app routing
    if (circuit.isWebContent) {
      if (!context.mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PssWebViewScreen(circuit: circuit),
        ),
      );
    } else {
      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierColor: Colors.black87,
        builder: (_) => _CircuitDiagramDialog(circuit: circuit),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TPColors.background,
      appBar: AppBar(
        backgroundColor: TPColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: TPColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'PSS CIRCUITS',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: TPColors.primary,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: TPColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      body: FutureBuilder<List<PssCircuit>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(TPColors.primary),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud_off_outlined,
                        size: 56,
                        color: TPColors.onSurfaceVariant.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load PSS Circuits',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: TPColors.onSurface),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 12, color: TPColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => setState(
                          () => _future = PssCircuitService.fetchActiveCircuits()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final circuits = snapshot.data ?? [];

          if (circuits.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.electrical_services_outlined,
                      size: 56,
                      color: TPColors.onSurfaceVariant.withValues(alpha: 0.4)),
                  const SizedBox(height: 16),
                  const Text(
                    'No PSS Circuits found',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: TPColors.onSurface),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Add entries in the Supabase dashboard.',
                    style: TextStyle(
                        fontSize: 12, color: TPColors.onSurfaceVariant),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: TPColors.primary,
            onRefresh: () async {
              setState(
                  () => _future = PssCircuitService.fetchActiveCircuits());
              await _future;
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
              children: [
                // Info card
                GlassCard(
                  borderRadius: 12,
                  padding: const EdgeInsets.all(14),
                  borderColor: TPColors.primary.withValues(alpha: 0.15),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: TPColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.electrical_services,
                            size: 20, color: TPColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CIRCUIT DIAGRAMS',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: TPColors.primary,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${circuits.length} location${circuits.length == 1 ? '' : 's'} • Tap QR to view diagram',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: TPColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 16),

                // Circuit location cards
                ...circuits.asMap().entries.map((entry) {
                  final index = entry.key;
                  final circuit = entry.value;
                  return _PssCircuitCard(
                    circuit: circuit,
                    onQrTap: () => _openContent(context, circuit),
                  )
                      .animate()
                      .fadeIn(
                          duration: 400.ms,
                          delay: (60 * index).clamp(0, 400).ms)
                      .slideY(begin: 0.05, end: 0);
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Individual PSS Circuit Card (yellow label style) ─────────────────────

class _PssCircuitCard extends StatelessWidget {
  final PssCircuit circuit;
  final VoidCallback onQrTap;

  const _PssCircuitCard({required this.circuit, required this.onQrTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TPColors.outlineVariant.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: TPColors.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 100),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Circuit number badge (left dark strip) ──────────────────
              Container(
                width: 48,
                decoration: BoxDecoration(
                  color: TPColors.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    circuit.circuitNumber > 0 ? '${circuit.circuitNumber}' : '—',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // ── Yellow label area ────────────────────────────────────────
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  color: const Color(0xFFFFF176),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // First bold line (heading)
                      Text(
                        circuit.title.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1A1A1A),
                          height: 1.3,
                        ),
                      ),
                      // Second bold line
                      if (circuit.subtitle.isNotEmpty)
                        Text(
                          circuit.subtitle.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1A1A1A),
                            height: 1.3,
                          ),
                        ),
                      // Smaller bus section
                      if (circuit.busSection.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          circuit.busSection.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF444444),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // ── QR tap zone (right) ──────────────────────────────────────
              GestureDetector(
                onTap: onQrTap,
                child: Container(
                  width: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF176),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF1A6EB5),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.qr_code_2_rounded,
                        size: 40,
                        color: Color(0xFF1A6EB5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ─── Image-only fullscreen viewer ─────────────────────────────────────────

class _CircuitDiagramDialog extends StatefulWidget {
  final PssCircuit circuit;
  const _CircuitDiagramDialog({required this.circuit});

  @override
  State<_CircuitDiagramDialog> createState() => _CircuitDiagramDialogState();
}

class _CircuitDiagramDialogState extends State<_CircuitDiagramDialog> {
  final TransformationController _transformController =
      TransformationController();

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Zoomable image
          InteractiveViewer(
            transformationController: _transformController,
            minScale: 0.5,
            maxScale: 5.0,
            child: Center(
              child: Image.network(
                widget.circuit.contentUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                              : null,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white70),
                        ),
                        const SizedBox(height: 16),
                        const Text('Loading circuit diagram…',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 13)),
                      ],
                    ),
                  );
                },
                errorBuilder: (context, error, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.broken_image_outlined,
                          size: 64, color: Colors.white30),
                      const SizedBox(height: 12),
                      const Text('Could not load image',
                          style: TextStyle(
                              color: Colors.white54, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Header overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                right: 8,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.circuit.title.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        if (widget.circuit.subtitle.isNotEmpty)
                          Text(
                            widget.circuit.subtitle.toUpperCase(),
                            style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        if (widget.circuit.busSection.isNotEmpty)
                          Text(
                            widget.circuit.busSection,
                            style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: Colors.white70),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 20),
                    ),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
          ),

          // Pinch hint
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.pinch_outlined,
                        size: 14, color: Colors.white60),
                    SizedBox(width: 6),
                    Text('Pinch to zoom',
                        style: TextStyle(
                            color: Colors.white60, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
