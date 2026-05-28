import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme.dart';
import '../models/pss_component.dart';
import '../services/pss_component_service.dart';
import 'pss_component_detail_screen.dart';

/// Lists individual components within PSS. Allows searching and filtering by category.
class PssComponentsListScreen extends StatefulWidget {
  const PssComponentsListScreen({super.key});

  @override
  State<PssComponentsListScreen> createState() => _PssComponentsListScreenState();
}

class _PssComponentsListScreenState extends State<PssComponentsListScreen> {
  bool _isLoading = true;
  List<PssComponent> _allComponents = [];
  List<PssComponent> _filteredComponents = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final comps = await PssComponentService.fetchAllComponents();
    
    // Extract unique categories
    final uniqueCats = comps.map((c) => c.category).toSet().toList();
    uniqueCats.sort();
    
    if (mounted) {
      setState(() {
        _allComponents = comps;
        _categories = ['All', ...uniqueCats];
        _isLoading = false;
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredComponents = _allComponents.where((comp) {
        final matchesCategory = _selectedCategory == 'All' || comp.category == _selectedCategory;
        final matchesSearch = comp.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (comp.purpose != null && comp.purpose!.toLowerCase().contains(_searchQuery.toLowerCase())) ||
            comp.category.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  IconData _iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'transformer systems':
        return Icons.electric_meter;
      case 'rtu systems':
        return Icons.router;
      case 'battery charger':
      case 'dc systems':
        return Icons.battery_charging_full;
      case 'switchgear':
      case 'breaker systems':
        return Icons.switch_access_shortcut;
      default:
        return Icons.electrical_services;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: TPColors.lightBlueGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          onRefresh: _load,
          color: TPColors.primary,
          child: CustomScrollView(
            slivers: [
              // ── Header Banner ───────────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 200,
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
                      CachedNetworkImage(
                        imageUrl: 'https://ik.imagekit.io/tm5te9cjl/TPCODL/Gallary/transformer.jpg',
                        fit: BoxFit.cover,
                        errorWidget: (ctx, url, err) => Container(
                          color: TPColors.primaryContainer,
                          child: const Center(
                            child: Icon(Icons.developer_board, size: 72, color: Colors.white24),
                          ),
                        ),
                      ),
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
                                color: Colors.teal.shade800,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.teal.shade300.withValues(alpha: 0.5)),
                              ),
                              child: const Text(
                                'SYSTEM EQUIPMENT',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'PSS Components',
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

              // ── Search & Filter Panel ──────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Input Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                              _applyFilters();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search component name, spec or category...',
                            hintStyle: const TextStyle(fontSize: 13, color: TPColors.outline),
                            prefixIcon: const Icon(Icons.search_rounded, color: TPColors.primary, size: 20),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, color: TPColors.outline, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                        _applyFilters();
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Horizontal Categories List
                      if (!_isLoading && _categories.length > 1)
                        SizedBox(
                          height: 38,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categories.length,
                            itemBuilder: (context, index) {
                              final cat = _categories[index];
                              final isSelected = _selectedCategory == cat;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = cat;
                                    _applyFilters();
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? TPColors.primary
                                        : Colors.white.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected
                                          ? TPColors.primary
                                          : TPColors.outlineVariant.withValues(alpha: 0.4),
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: TPColors.primary.withValues(alpha: 0.2),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (cat != 'All') ...[
                                        Icon(
                                          _iconForCategory(cat),
                                          size: 14,
                                          color: isSelected ? Colors.white : TPColors.primary,
                                        ),
                                        const SizedBox(width: 6),
                                      ],
                                      Text(
                                        cat,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                          color: isSelected ? Colors.white : TPColors.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // ── Component List Items ────────────────────────────────────────
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
                    : _filteredComponents.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _searchQuery.isNotEmpty ? Icons.search_off_rounded : Icons.developer_board_off_rounded,
                                    size: 56,
                                    color: TPColors.outline.withValues(alpha: 0.4),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _searchQuery.isNotEmpty ? 'No components match your search.' : 'No components found.',
                                    style: const TextStyle(fontSize: 15, color: TPColors.onSurfaceVariant),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _searchQuery.isNotEmpty
                                        ? 'Try clearing the search query or selecting "All" categories.'
                                        : 'Add rows to pss_components in Supabase.',
                                    style: const TextStyle(fontSize: 12, color: TPColors.outline),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                            child: Column(
                              children: List.generate(_filteredComponents.length, (index) {
                                final comp = _filteredComponents[index];
                                return _ComponentListTile(
                                  component: comp,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => PssComponentDetailScreen(
                                        component: comp,
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
      ),
    );
  }
}

// ─── Component List Tile ──────────────────────────────────────────────────────

class _ComponentListTile extends StatelessWidget {
  final PssComponent component;
  final VoidCallback onTap;

  const _ComponentListTile({
    required this.component,
    required this.onTap,
  });

  Color _priorityColor() {
    switch (component.priority.toUpperCase()) {
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
            // Cover Image with details
            Stack(
              children: [
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
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.35)],
                      ),
                    ),
                  ),
                ),
                // Priority / Category badges overlay
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      component.category.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _priorityColor(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      component.priority,
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          component.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 17,
                                color: TPColors.onSurface,
                              ),
                        ),
                      ),
                      if (component.voltageClass != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: TPColors.secondaryContainer.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: TPColors.secondaryContainer.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            component.voltageClass!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: TPColors.secondary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (component.purpose != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      component.purpose!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: TPColors.onSurfaceVariant,
                            height: 1.45,
                            fontSize: 12,
                          ),
                    ),
                  ],
                  if (component.imageUrls.length > 1) ...[
                    const SizedBox(height: 12),
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
