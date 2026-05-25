import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme.dart';
import '../models/gallery_item.dart';
import '../services/gallery_service.dart';
import '../widgets/glass_card.dart';

class PhotosViewScreen extends StatefulWidget {
  const PhotosViewScreen({super.key});

  @override
  State<PhotosViewScreen> createState() => _PhotosViewScreenState();
}

class _PhotosViewScreenState extends State<PhotosViewScreen> {
  bool _isLoading = true;
  List<GalleryItem> _galleryItems = [];
  int _selectedViewMode = 0; // 0 = 2-col grid, 1 = single column list
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadGallery();
  }

  Future<void> _loadGallery() async {
    try {
      final items = await GalleryService.fetchDisplayedItems();
      if (mounted) {
        setState(() {
          _galleryItems = items;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load gallery. Please check your connection.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'SUBSTATION GALLERY',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: TPColors.primary,
          ),
        ),
        backgroundColor: Colors.white.withValues(alpha: 0.75),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: TPColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Refresh button
          Tooltip(
            message: 'Refresh Gallery',
            child: GestureDetector(
              onTap: () {
                setState(() => _isLoading = true);
                _loadGallery();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.refresh_rounded,
                  size: 20,
                  color: TPColors.outline,
                ),
              ),
            ),
          ),
          // Grid option 1: 2-column grid
          Tooltip(
            message: '2-Column Grid',
            child: GestureDetector(
              onTap: () => setState(() => _selectedViewMode = 0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _selectedViewMode == 0
                      ? TPColors.primaryContainer.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _selectedViewMode == 0
                        ? TPColors.primaryContainer.withValues(alpha: 0.3)
                        : Colors.transparent,
                  ),
                ),
                child: Icon(
                  Icons.grid_view_rounded,
                  size: 20,
                  color: _selectedViewMode == 0 ? TPColors.primary : TPColors.outline,
                ),
              ),
            ),
          ),
          // Grid option 2: single-column list
          Tooltip(
            message: 'Original Size List',
            child: GestureDetector(
              onTap: () => setState(() => _selectedViewMode = 1),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _selectedViewMode == 1
                      ? TPColors.primaryContainer.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _selectedViewMode == 1
                        ? TPColors.primaryContainer.withValues(alpha: 0.3)
                        : Colors.transparent,
                  ),
                ),
                child: Icon(
                  Icons.view_stream_rounded,
                  size: 20,
                  color: _selectedViewMode == 1 ? TPColors.primary : TPColors.outline,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: TPColors.lightBlueGradient,
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(TPColors.primary),
                ),
              )
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_off_rounded,
                          size: 56,
                          color: TPColors.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: TPColors.onSurfaceVariant),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() => _isLoading = true);
                            _loadGallery();
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _galleryItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.photo_library_outlined,
                              size: 64,
                              color: TPColors.outline,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No photos in the gallery yet.',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                color: TPColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Add records to the gallery_items table\nin Supabase to see them here.',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: TPColors.outline,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : SafeArea(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.0, 0.05),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: _selectedViewMode == 0
                              ? _buildTwoColumnGrid(key: const ValueKey('grid_view'))
                              : _buildOriginalSizeList(key: const ValueKey('list_view')),
                        ),
                      ),
      ),
    );
  }

  // ─── 2-Column Grid ───────────────────────────────────────────────────────────

  Widget _buildTwoColumnGrid({required Key key}) {
    return GridView.builder(
      key: key,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: _galleryItems.length,
      itemBuilder: (context, index) {
        final item = _galleryItems[index];

        return GestureDetector(
          onTap: () => _openDetail(item),
          child: GlassCard(
            borderRadius: 12,
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: _networkImage(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorIconSize: 32,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: TPColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      if (item.subtitle != null || item.category != null)
                        Text(
                          (item.subtitle ?? item.category)!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: TPColors.secondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 300.ms, delay: (index * 30).clamp(0, 300).ms).scale(
              begin: const Offset(0.96, 0.96),
              end: const Offset(1.0, 1.0),
              curve: Curves.easeOutBack,
            );
      },
    );
  }

  // ─── Single-Column List ──────────────────────────────────────────────────────

  Widget _buildOriginalSizeList({required Key key}) {
    return ListView.builder(
      key: key,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: _galleryItems.length,
      itemBuilder: (context, index) {
        final item = _galleryItems[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: GestureDetector(
            onTap: () => _openDetail(item),
            child: GlassCard(
              borderRadius: 16,
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: _networkImage(
                      item.imageUrl,
                      fit: BoxFit.contain,
                      errorIconSize: 48,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: TPColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (item.subtitle != null || item.category != null)
                          Text(
                            ((item.subtitle ?? item.category)!).toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: TPColors.secondary,
                              letterSpacing: 1,
                            ),
                          ),
                        if (item.description != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            item.description!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: TPColors.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(
              begin: 0.08,
              end: 0,
              curve: Curves.easeOutCubic,
            );
      },
    );
  }

  // ─── Full-Screen Detail ──────────────────────────────────────────────────────

  void _openDetail(GalleryItem item) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _GalleryDetailPage(item: item),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  // ─── Shared Network Image Helper ─────────────────────────────────────────────

  Widget _networkImage(String url, {required BoxFit fit, required double errorIconSize}) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (context, url) => Container(
        color: TPColors.primaryContainer.withValues(alpha: 0.1),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(TPColors.primary),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: TPColors.primaryContainer.withValues(alpha: 0.1),
        child: Icon(
          Icons.image_not_supported_rounded,
          color: TPColors.primary,
          size: errorIconSize,
        ),
      ),
    );
  }
}

// ─── Detail Page ─────────────────────────────────────────────────────────────

class _GalleryDetailPage extends StatelessWidget {
  final GalleryItem item;

  const _GalleryDetailPage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          ),
        ),
      ),
      body: Column(
        children: [
          // Full-width image
          Expanded(
            child: InteractiveViewer(
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.image_not_supported_rounded,
                    color: Colors.white54,
                    size: 64,
                  ),
                ),
              ),
            ),
          ),
          // Info panel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.85),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                if (item.subtitle != null || item.category != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    ((item.subtitle ?? item.category)!).toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: TPColors.secondary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
                if (item.description != null && item.description!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    item.description!,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.75),
                      height: 1.5,
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (item.location != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 14, color: TPColors.secondary),
                      const SizedBox(width: 4),
                      Text(
                        item.location!,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: TPColors.secondary,
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
    );
  }
}
