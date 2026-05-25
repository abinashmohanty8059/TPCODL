import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme.dart';
import '../models/pss_component_category.dart';
import '../models/pss_component.dart';
import '../services/pss_component_service.dart';
import 'pss_component_detail_screen.dart';

/// Lists individual components within a PSS category
class PssComponentsListScreen extends StatefulWidget {
  final PssComponentCategory category;

  const PssComponentsListScreen({super.key, required this.category});

  @override
  State<PssComponentsListScreen> createState() => _PssComponentsListScreenState();
}

class _PssComponentsListScreenState extends State<PssComponentsListScreen> {
  bool _isLoading = true;
  List<PssComponent> _components = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final comps = await PssComponentService.fetchComponents(widget.category.id);
    if (mounted) setState(() { _components = comps; _isLoading = false; });
  }

  IconData _categoryIcon() {
    switch (widget.category.iconName) {
      case 'electric_meter': return Icons.electric_meter;
      case 'router': return Icons.router;
      case 'settings_system_daydream': return Icons.settings_system_daydream;
      case 'bolt': return Icons.bolt;
      case 'settings_ethernet': return Icons.settings_ethernet;
      case 'power': return Icons.power;
      case 'toggle_on': return Icons.toggle_on;
      case 'switch_access_shortcut': return Icons.switch_access_shortcut;
      case 'dns': return Icons.dns;
      default: return Icons.electrical_services;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: TPColors.lightBlueGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 220,
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
                    widget.category.coverImageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: widget.category.coverImageUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (ctx, url, err) => Container(
                              color: TPColors.primaryContainer,
                              child: Center(child: Icon(_categoryIcon(), size: 72, color: Colors.white24)),
                            ),
                          )
                        : Container(
                            color: TPColors.primaryContainer,
                            child: Center(child: Icon(_categoryIcon(), size: 72, color: Colors.white24)),
                          ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.25),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.65),
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade800,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.blue.shade300.withValues(alpha: 0.5)),
                            ),
                            child: Text(
                              (widget.category.voltageClass ?? widget.category.priority).toUpperCase(),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.category.name,
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
                  : _components.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_categoryIcon(), size: 56, color: TPColors.outline.withValues(alpha: 0.4)),
                                const SizedBox(height: 16),
                                const Text(
                                  'No components yet.',
                                  style: TextStyle(fontSize: 15, color: TPColors.onSurfaceVariant),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Add rows to pss_components in Supabase.',
                                  style: TextStyle(fontSize: 12, color: TPColors.outline),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                          child: Column(
                            children: List.generate(_components.length, (index) {
                              final comp = _components[index];
                              return _ComponentListTile(
                                component: comp,
                                categoryName: widget.category.name,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => PssComponentDetailScreen(
                                      component: comp,
                                      categoryName: widget.category.name,
                                    ),
                                  ),
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 400.ms, delay: (index * 60).clamp(0, 300).ms)
                                  .slideY(begin: 0.06, end: 0);
                            }),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Component List Tile ──────────────────────────────────────────────────────

class _ComponentListTile extends StatelessWidget {
  final PssComponent component;
  final String categoryName;
  final VoidCallback onTap;

  const _ComponentListTile({
    required this.component,
    required this.categoryName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstImage = component.imageUrls.isNotEmpty ? component.imageUrls.first : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: TPColors.outlineVariant.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: TPColors.primaryContainer.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            SizedBox(
              height: 180,
              width: double.infinity,
              child: firstImage != null
                  ? CachedNetworkImage(
                      imageUrl: firstImage,
                      fit: BoxFit.cover,
                      placeholder: (ctx, url) => Container(
                        color: TPColors.primaryContainer.withValues(alpha: 0.1),
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      errorWidget: (ctx, url, err) => Container(
                        color: TPColors.primaryContainer.withValues(alpha: 0.1),
                        child: const Icon(Icons.image_not_supported_rounded, size: 40, color: TPColors.outline),
                      ),
                    )
                  : Container(
                      color: TPColors.primaryContainer.withValues(alpha: 0.1),
                      child: const Icon(Icons.image_not_supported_rounded, size: 40, color: TPColors.outline),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    component.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 17, color: TPColors.onSurface),
                  ),
                  if (component.purpose != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      component.purpose!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: TPColors.onSurfaceVariant,
                            height: 1.4,
                          ),
                    ),
                  ],
                  if (component.imageUrls.length > 1) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.photo_library_rounded, size: 14, color: TPColors.secondary),
                        const SizedBox(width: 4),
                        Text(
                          '${component.imageUrls.length} photos',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: TPColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
