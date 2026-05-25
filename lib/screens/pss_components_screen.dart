import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme.dart';
import '../models/pss_component_category.dart';
import '../services/pss_component_service.dart';
import 'pss_components_list_screen.dart';

/// PSS Components entry page — shows category cards (e.g. Transformer Systems, RTU Systems)
class PssComponentsScreen extends StatefulWidget {
  const PssComponentsScreen({super.key});

  @override
  State<PssComponentsScreen> createState() => _PssComponentsScreenState();
}

class _PssComponentsScreenState extends State<PssComponentsScreen> {
  bool _isLoading = true;
  List<PssComponentCategory> _categories = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final cats = await PssComponentService.fetchCategories();
    if (mounted) {
      setState(() {
        _categories = cats;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: TPColors.lightBlueGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white.withValues(alpha: 0.8),
          elevation: 0,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TPColors.primaryContainer.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: const Icon(Icons.arrow_back, color: TPColors.primary, size: 20),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'PSS COMPONENTS',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: TPColors.primary,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: TPColors.outline),
              onPressed: _load,
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(TPColors.primary),
                ),
              )
            : _error != null
                ? _buildError()
                : _categories.isEmpty
                    ? _buildEmpty()
                    : RefreshIndicator(
                        onRefresh: _load,
                        color: TPColors.primary,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final cat = _categories[index];
                            return _CategoryCard(
                              category: cat,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => PssComponentsListScreen(category: cat),
                                  ),
                                );
                              },
                            )
                                .animate()
                                .fadeIn(duration: 400.ms, delay: (index * 60).clamp(0, 350).ms)
                                .slideY(begin: 0.06, end: 0);
                          },
                        ),
                      ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 52, color: TPColors.outline),
          const SizedBox(height: 12),
          Text(_error!, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.electrical_services_rounded, size: 56, color: TPColors.outline),
          const SizedBox(height: 16),
          const Text(
            'No component categories yet.',
            style: TextStyle(fontFamily: 'Inter', fontSize: 15, color: TPColors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add rows to pss_component_categories in Supabase.',
            style: TextStyle(fontSize: 12, color: TPColors.outline),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Category Card ────────────────────────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final PssComponentCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  IconData _icon() {
    switch (category.iconName) {
      case 'electric_meter':
        return Icons.electric_meter;
      case 'router':
        return Icons.router;
      case 'settings_system_daydream':
        return Icons.settings_system_daydream;
      case 'bolt':
        return Icons.bolt;
      case 'settings_ethernet':
        return Icons.settings_ethernet;
      case 'power':
        return Icons.power;
      case 'toggle_on':
        return Icons.toggle_on;
      case 'switch_access_shortcut':
        return Icons.switch_access_shortcut;
      case 'dns':
        return Icons.dns;
      default:
        return Icons.electrical_services;
    }
  }

  Color _priorityColor() {
    switch (category.priority) {
      case 'CRITICAL':
        return Colors.red.shade600;
      case 'CORE':
        return Colors.green.shade600;
      default:
        return Colors.amber.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: TPColors.outlineVariant.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: TPColors.primaryContainer.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: category.coverImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: category.coverImageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: TPColors.primaryContainer.withValues(alpha: 0.1),
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: TPColors.primaryContainer.withValues(alpha: 0.1),
                            child: Center(
                              child: Icon(_icon(), size: 56, color: TPColors.outline.withValues(alpha: 0.4)),
                            ),
                          ),
                        )
                      : Container(
                          color: TPColors.primaryContainer.withValues(alpha: 0.1),
                          child: Center(
                            child: Icon(_icon(), size: 56, color: TPColors.outline.withValues(alpha: 0.4)),
                          ),
                        ),
                ),
                // gradient
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.white.withValues(alpha: 0.6)],
                      ),
                    ),
                  ),
                ),
                // icon badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
                    ),
                    child: Icon(_icon(), size: 20, color: TPColors.secondary),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 18,
                          color: TPColors.onSurface,
                        ),
                  ),
                  if (category.description != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      category.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: TPColors.onSurfaceVariant,
                            height: 1.4,
                          ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      if (category.voltageClass != null)
                        _tag(context, category.voltageClass!.toUpperCase(), TPColors.secondaryContainer),
                      _tag(context, category.priority, _priorityColor()),
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

  Widget _tag(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
