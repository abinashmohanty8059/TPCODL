import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme.dart';
import '../models/pss_component.dart';
import '../models/pss_component_detail.dart';
import '../services/pss_component_service.dart';
import '../widgets/glass_card.dart';

class PssComponentDetailScreen extends StatefulWidget {
  final PssComponent component;
  final String categoryName;

  const PssComponentDetailScreen({
    super.key,
    required this.component,
    required this.categoryName,
  });

  @override
  State<PssComponentDetailScreen> createState() => _PssComponentDetailScreenState();
}

class _PssComponentDetailScreenState extends State<PssComponentDetailScreen> {
  bool _isLoading = true;
  List<PssComponentDetail> _details = [];
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadDetails() async {
    final details = await PssComponentService.fetchDetails(widget.component.id);
    if (mounted) {
      setState(() {
        _details = details;
        _isLoading = false;
      });
    }
  }

  List<PssComponentDetail> _section(String key) =>
      _details.where((d) => d.section == key).toList();

  void _openFullscreenImage(int startIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _FullscreenGallery(
          imageUrls: widget.component.imageUrls,
          initialIndex: startIndex,
          title: widget.component.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.component.imageUrls;

    return Container(
      decoration: const BoxDecoration(gradient: TPColors.lightBlueGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            // ── Image Slideshow AppBar ──────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 300,
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
                  onPressed: () => _openFullscreenImage(_currentImageIndex),
                ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // ── Slideshow ─────────────────────────────────────────────
                    images.isEmpty
                        ? Container(
                            color: TPColors.primaryContainer,
                            child: const Center(
                              child: Icon(Icons.image_not_supported_rounded,
                                  size: 80, color: Colors.white24),
                            ),
                          )
                        : PageView.builder(
                            controller: _pageController,
                            itemCount: images.length,
                            onPageChanged: (i) => setState(() => _currentImageIndex = i),
                            itemBuilder: (context, i) => GestureDetector(
                              onTap: () => _openFullscreenImage(i),
                              child: CachedNetworkImage(
                                imageUrl: images[i],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: TPColors.primaryContainer,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                ),
                                errorWidget: (ctx, url, err) => Container(
                                  color: TPColors.primaryContainer,
                                  child: const Icon(Icons.broken_image, size: 56, color: Colors.white24),
                                ),
                              ),
                            ),
                          ),

                    // gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.75),
                            ],
                            stops: const [0.0, 0.4, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // ── Dot indicators ────────────────────────────────────────
                    if (images.length > 1)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_currentImageIndex + 1} / ${images.length}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                    // ── Header labels ─────────────────────────────────────────
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
                                  widget.categoryName.toUpperCase(),
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
                                  widget.component.nodeLabel,
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
                            widget.component.name,
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
                          // Slideshow dot indicators
                          if (images.length > 1) ...[
                            const SizedBox(height: 10),
                            Row(
                              children: List.generate(images.length, (i) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.only(right: 6),
                                  width: _currentImageIndex == i ? 18 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: _currentImageIndex == i
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Body Content ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(TPColors.primary),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Equipment Purpose
                          if (widget.component.purpose != null &&
                              widget.component.purpose!.isNotEmpty) ...[
                            _sectionHeader('EQUIPMENT PURPOSE'),
                            const SizedBox(height: 10),
                            GlassCard(
                              borderRadius: 12,
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                widget.component.purpose!,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: TPColors.onSurface,
                                      height: 1.55,
                                      fontSize: 13.5,
                                    ),
                              ),
                            ).animate().fadeIn(duration: 400.ms),
                            const SizedBox(height: 28),
                          ],

                          // Visible Details
                          _buildPointsSection(
                            context,
                            'VISIBLE DETAILS & SYSTEM ASSETS',
                            _section('visible_details'),
                            icon: Icons.visibility,
                            iconColor: Colors.blue.shade600,
                            delayBase: 100,
                          ),

                          // Technical Specifications
                          _buildTechSpecsSection(
                            context,
                            _section('tech_specs'),
                          ),

                          // Functional Notes
                          _buildFunctionalNotesSection(
                            context,
                            _section('functional_notes'),
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

  // ── Section header ────────────────────────────────────────────────────────────

  Widget _sectionHeader(String text) {
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
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: TPColors.onSurfaceVariant,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  // ── Visible details bullet points ─────────────────────────────────────────────

  Widget _buildPointsSection(
    BuildContext context,
    String title,
    List<PssComponentDetail> points, {
    required IconData icon,
    required Color iconColor,
    int delayBase = 0,
  }) {
    if (points.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(title),
        const SizedBox(height: 10),
        GlassCard(
          borderRadius: 12,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: List.generate(points.length, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: index < points.length - 1 ? 12 : 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, size: 16, color: iconColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        points[index].content,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: TPColors.onSurface,
                              height: 1.35,
                            ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ).animate().fadeIn(duration: 400.ms, delay: delayBase.ms),
        const SizedBox(height: 28),
      ],
    );
  }

  // ── Technical specs — point list (not a table) ────────────────────────────────

  Widget _buildTechSpecsSection(BuildContext context, List<PssComponentDetail> points) {
    if (points.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('TECHNICAL SPECIFICATIONS'),
        const SizedBox(height: 10),
        GlassCard(
          borderRadius: 12,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: List.generate(points.length, (index) {
              final point = points[index];
              // split on first ':' if present for a key:value layout, else show as bullet
              final colonIdx = point.content.indexOf(':');
              final hasColon = colonIdx > 0 && colonIdx < point.content.length - 1;
              final key = hasColon ? point.content.substring(0, colonIdx).trim() : null;
              final value = hasColon ? point.content.substring(colonIdx + 1).trim() : point.content;

              return Padding(
                padding: EdgeInsets.only(bottom: index < points.length - 1 ? 0 : 0),
                child: Column(
                  children: [
                    if (index > 0) Divider(color: TPColors.outlineVariant.withValues(alpha: 0.3), height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: hasColon
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    key!,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: TPColors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: TPColors.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.arrow_right_rounded, size: 18, color: TPColors.secondary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: TPColors.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
        const SizedBox(height: 28),
      ],
    );
  }

  // ── Functional notes ──────────────────────────────────────────────────────────

  Widget _buildFunctionalNotesSection(BuildContext context, List<PssComponentDetail> notes) {
    if (notes.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('OPERATIONAL & FUNCTIONAL NOTES'),
        const SizedBox(height: 10),
        ...List.generate(notes.length, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.shade50.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green.shade200.withValues(alpha: 0.5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.green.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    notes[index].content,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.green.shade900,
                      fontSize: 12.5,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: (300 + index * 60).ms)
              .slideX(begin: 0.05, end: 0, duration: 300.ms);
        }),
        const SizedBox(height: 40),
      ],
    );
  }
}

// ─── Fullscreen gallery viewer ────────────────────────────────────────────────

class _FullscreenGallery extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final String title;

  const _FullscreenGallery({
    required this.imageUrls,
    required this.initialIndex,
    required this.title,
  });

  @override
  State<_FullscreenGallery> createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<_FullscreenGallery> {
  late int _current;
  late PageController _pc;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _pc = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.imageUrls.length > 1
              ? '${widget.title} (${_current + 1}/${widget.imageUrls.length})'
              : widget.title,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: PageView.builder(
        controller: _pc,
        itemCount: widget.imageUrls.length,
        onPageChanged: (i) => setState(() => _current = i),
        itemBuilder: (context, i) => InteractiveViewer(
          child: Center(
            child: CachedNetworkImage(
              imageUrl: widget.imageUrls[i],
              fit: BoxFit.contain,
              placeholder: (ctx, url) => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              errorWidget: (ctx, url, err) => const Icon(
                Icons.broken_image,
                color: Colors.white38,
                size: 72,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
