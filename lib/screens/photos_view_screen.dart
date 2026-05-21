import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../models/substation_equipment.dart';
import '../services/substation_data_service.dart';
import '../widgets/glass_card.dart';

class PhotosViewScreen extends StatefulWidget {
  const PhotosViewScreen({super.key});

  @override
  State<PhotosViewScreen> createState() => _PhotosViewScreenState();
}

class _PhotosViewScreenState extends State<PhotosViewScreen> {
  bool _isLoading = true;
  List<SubstationEquipment> _equipmentList = [];
  int _selectedViewMode = 0; // 0 for 2-column grid (rectangles), 1 for single column (original size)

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    final list = await SubstationDataService.loadEquipmentData();
    setState(() {
      _equipmentList = list;
      _isLoading = false;
    });
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
          // Grid option 1: 2-column grid (2 rectangles in each row)
          Tooltip(
            message: '2-Column Grid',
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedViewMode = 0;
                });
              },
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
          // Grid option 2: original size scrolling list
          Tooltip(
            message: 'Original Size List',
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedViewMode = 1;
                });
              },
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
            : _equipmentList.isEmpty
                ? const Center(
                    child: Text(
                      'No photos available',
                      style: TextStyle(color: TPColors.onSurfaceVariant),
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
      itemCount: _equipmentList.length,
      itemBuilder: (context, index) {
        final eq = _equipmentList[index];
        final imagePath = 'subststion_data/pic/${eq.actualImageName}';
        
        return GlassCard(
          borderRadius: 12,
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: TPColors.primaryContainer.withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.image_not_supported_rounded,
                          color: TPColors.primary,
                          size: 32,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eq.name,
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
                    Text(
                      eq.category,
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
        ).animate().fadeIn(duration: 300.ms, delay: (index * 30).clamp(0, 300).ms).scale(
              begin: const Offset(0.96, 0.96),
              end: const Offset(1.0, 1.0),
              curve: Curves.easeOutBack,
            );
      },
    );
  }

  Widget _buildOriginalSizeList({required Key key}) {
    return ListView.builder(
      key: key,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: _equipmentList.length,
      itemBuilder: (context, index) {
        final eq = _equipmentList[index];
        final imagePath = 'subststion_data/pic/${eq.actualImageName}';

        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: GlassCard(
            borderRadius: 16,
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain, // Displays the original size / aspect ratio
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: TPColors.primaryContainer.withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.image_not_supported_rounded,
                          color: TPColors.primary,
                          size: 48,
                        ),
                      );
                    },
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
                        eq.name,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: TPColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        eq.category.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: TPColors.secondary,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        eq.purpose,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: TPColors.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(
                begin: 0.08,
                end: 0,
                curve: Curves.easeOutCubic,
              ),
        );
      },
    );
  }
}
