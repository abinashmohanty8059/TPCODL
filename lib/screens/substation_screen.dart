import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../models/substation_equipment.dart';
import '../services/substation_data_service.dart';
import '../widgets/component_card.dart';
import '../widgets/glass_card.dart';
import 'component_detail_screen.dart';
import 'category_detail_screen.dart';
import 'pss_circuits_screen.dart';
import 'pss_components_list_screen.dart';

class SubstationCategory {
  final String name;
  final String description;
  final String coverImage;
  final String voltageClass;
  final String priority;

  const SubstationCategory({
    required this.name,
    required this.description,
    required this.coverImage,
    required this.voltageClass,
    required this.priority,
  });
}

class SubstationScreen extends StatefulWidget {
  const SubstationScreen({super.key});

  @override
  State<SubstationScreen> createState() => _SubstationScreenState();
}

class _SubstationScreenState extends State<SubstationScreen> {
  bool _isLoading = true;
  List<SubstationEquipment> _allEquipment = [];
  List<SubstationEquipment> _filteredEquipment = [];
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  final List<SubstationCategory> _categories = const [
    SubstationCategory(
      name: 'Transformer Systems',
      description: 'Main power conversion systems that step down voltage from 33 kV to 11 kV for local distribution.',
      coverImage: 'subststion_data/pic/transformer.jpg',
      voltageClass: '33kV / 11kV',
      priority: 'CORE',
    ),
    SubstationCategory(
      name: 'RTU Systems',
      description: 'Remote Terminal Units interfacing field equipment to the central SCADA system for telemetry and remote control.',
      coverImage: 'subststion_data/pic/rtubox.jpg',
      voltageClass: 'Low Voltage',
      priority: 'CRITICAL',
    ),
    SubstationCategory(
      name: 'Protection Relays',
      description: 'Numerical and microprocessor-controlled relays executing electrical protection logic and breaker trips.',
      coverImage: 'subststion_data/pic/relaymodule.jpg',
      voltageClass: 'Low Voltage',
      priority: 'CRITICAL',
    ),
    SubstationCategory(
      name: 'Smart Metering',
      description: 'Advanced energy measurement meters with optical and remote telemetry communication ports.',
      coverImage: 'subststion_data/pic/smart meters.jpg',
      voltageClass: 'Low Voltage',
      priority: 'HIGH',
    ),
    SubstationCategory(
      name: 'Communication Network',
      description: 'Substation ethernet backbone, MOXA managed switches, and patching for reliable SCADA data routing.',
      coverImage: 'subststion_data/pic/patch Pannel and switch.jpg',
      voltageClass: 'Low Voltage',
      priority: 'HIGH',
    ),
    SubstationCategory(
      name: 'ACDB Panels',
      description: 'AC distribution boards supplying auxiliary AC power to critical RTU systems, chargers, and substation lighting.',
      coverImage: 'subststion_data/pic/acbd pannel.jpg',
      voltageClass: '415V AC',
      priority: 'HIGH',
    ),
    SubstationCategory(
      name: 'Control Systems',
      description: 'Manual and remote operating handles, key selectors, and mimic topology diagrams for grid control.',
      coverImage: 'subststion_data/pic/manualto remote lever.jpg',
      voltageClass: 'Low Voltage',
      priority: 'HIGH',
    ),
    SubstationCategory(
      name: 'Switchgear',
      description: 'SF6 gas insulated switchgear, ring main units, and gas pressure gauges for circuit isolation.',
      coverImage: 'subststion_data/pic/RMU.jpg',
      voltageClass: '11kV / 22kV',
      priority: 'HIGH',
    ),
    SubstationCategory(
      name: 'SCADA Infrastructure',
      description: 'Substation automation systems coordinating real-time telemetry, alarm handling, and command processing.',
      coverImage: 'subststion_data/pic/PSS.jpg',
      voltageClass: 'System-Wide',
      priority: 'CRITICAL',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await SubstationDataService.loadEquipmentData();
    setState(() {
      _allEquipment = data;
      _filteredEquipment = data;
      _isLoading = false;
    });
  }

  void _filterData() {
    setState(() {
      final query = _searchQuery.toLowerCase();
      _filteredEquipment = _allEquipment.where((eq) {
        return eq.name.toLowerCase().contains(query) ||
            eq.category.toLowerCase().contains(query) ||
            eq.purpose.toLowerCase().contains(query) ||
            eq.visibleDetails.any((detail) => detail.toLowerCase().contains(query));
      }).toList();
    });
  }

  int _getCategoryCount(String categoryName) {
    return _allEquipment.where((eq) => eq.category == categoryName).length;
  }

  List<SubstationEquipment> _getCategoryItems(String categoryName) {
    return _allEquipment.where((eq) => eq.category == categoryName).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(TPColors.primary),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              color: TPColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    _buildSearchSection(),
                    _buildContentSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F4C97), // Sleek blue box
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF25B2FE).withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F4C97).withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'SUBSTATION',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
            ],
          ),
          const SizedBox(height: 8),
          // Animated pulse line
          const _PulseLine().animate().fadeIn(duration: 600.ms, delay: 200.ms),
          const SizedBox(height: 12),
          Text(
            'Explore the critical hardware that powers the modern grid. High-fidelity utility components engineered for precision and reliability.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: TPColors.onSurfaceVariant,
                  fontSize: 12,
                  height: 1.45,
                ),
          ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
          const SizedBox(height: 16),
          
          // SCADA operations telemetry dashboard
          GlassCard(
            borderRadius: 16,
            padding: const EdgeInsets.all(16),
            borderColor: TPColors.primary.withValues(alpha: 0.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.dashboard_customize, size: 18, color: TPColors.primary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'SYSTEM OPERATIONS TELEMETRY',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: TPColors.primary,
                          letterSpacing: 1.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final double itemWidth = width > 400 ? (width - 36) / 4 : (width - 12) / 2;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: itemWidth,
                          child: _buildSCADAMetric('33 / 11 kV', 'SYSTEM RATING', Icons.bolt),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: _buildSCADAMetric('49.98 Hz', 'FREQUENCY', Icons.waves),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: _buildSCADAMetric('1.00', 'POWER FACTOR', Icons.speed),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: _buildSCADAMetric('30 Nodes', 'ACTIVE I/O', Icons.settings_input_component),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 400.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSCADAMetric(String value, String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: TPColors.onSurfaceVariant.withValues(alpha: 0.7)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: TPColors.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: TPColors.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: TPColors.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) {
            setState(() {
              _searchQuery = val;
              _filterData();
            });
          },
          decoration: InputDecoration(
            hintText: 'Search substation equipment directly...',
            hintStyle: const TextStyle(fontSize: 13, color: TPColors.onSurfaceVariant),
            prefixIcon: const Icon(Icons.search, size: 18, color: TPColors.onSurfaceVariant),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 16),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                        _filterData();
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }

  Widget _buildContentSection() {
    if (_searchQuery.isNotEmpty) {
      // Show list of matching items
      if (_filteredEquipment.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off, size: 48, color: TPColors.onSurfaceVariant.withValues(alpha: 0.5)),
                const SizedBox(height: 12),
                const Text(
                  'No matching equipment found',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: TPColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Try refining your query.',
                  style: TextStyle(fontSize: 12, color: TPColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _filteredEquipment.length,
        itemBuilder: (context, index) {
          final eq = _filteredEquipment[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ComponentCard(
              equipment: eq,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ComponentDetailScreen(equipment: eq),
                  ),
                );
              },
            ),
          );
        },
      );
    } else {
      // Show list of Categories (with PSS Circuits + PSS Components banners at top)
      return Column(
        children: [
          _buildPSSCircuitsBlock(),
          _buildPSSComponentsBlock(),
          ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final itemCount = _getCategoryCount(category.name);
          return CategoryCard(
            category: category,
            itemCount: itemCount,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CategoryDetailScreen(
                    categoryName: category.name,
                    description: category.description,
                    coverImage: 'subststion_data/pic/${category.coverImage.split('/').last}',
                    voltageClass: category.voltageClass,
                    priority: category.priority,
                    equipmentItems: _getCategoryItems(category.name),
                  ),
                ),
              );
            },
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: (index * 60).clamp(0, 350).ms)
              .slideY(begin: 0.05, end: 0);
        },
      ),
        ],
      );
    }
  }

  Widget _buildPSSCircuitsBlock() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const PssCircuitsScreen(),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF003571),
                Color(0xFF0F4C97),
                Color(0xFF006493),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF003571).withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.electrical_services_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PSS CIRCUITS',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'View circuit diagrams by location',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white70,
                size: 28,
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),
      ),
    );
  }

  Widget _buildPSSComponentsBlock() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PssComponentsListScreen()),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF00695C),
                Color(0xFF00897B),
                Color(0xFF00ACC1),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00695C).withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.developer_board_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PSS COMPONENTS',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Browse equipment by category with detailed specs',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white70,
                size: 28,
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 80.ms).slideY(begin: 0.05, end: 0),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final SubstationCategory category;
  final int itemCount;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.itemCount,
    required this.onTap,
  });

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'Transformer Systems':
        return Icons.electric_meter;
      case 'RTU Systems':
        return Icons.router;
      case 'Protection Relays':
        return Icons.settings_system_daydream;
      case 'Smart Metering':
        return Icons.bolt;
      case 'Communication Network':
        return Icons.settings_ethernet;
      case 'ACDB Panels':
        return Icons.power;
      case 'Control Systems':
        return Icons.toggle_on;
      case 'Switchgear':
        return Icons.switch_access_shortcut;
      case 'SCADA Infrastructure':
        return Icons.dns;
      default:
        return Icons.electrical_services;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'CRITICAL':
        return Colors.red.shade600;
      case 'HIGH':
        return Colors.amber.shade700;
      case 'CORE':
        return Colors.green.shade600;
      default:
        return TPColors.primary;
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: TPColors.outlineVariant.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: TPColors.primaryContainer.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image with overlays
            Stack(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  color: TPColors.surfaceContainerLow.withValues(alpha: 0.5),
                  child: Image.asset(
                    'subststion_data/pic/${category.coverImage.split('/').last}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          _getCategoryIcon(category.name),
                          size: 64,
                          color: TPColors.primaryContainer.withValues(alpha: 0.3),
                        ),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                // Circular icon badge top right
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: TPColors.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      _getCategoryIcon(category.name),
                      size: 20,
                      color: TPColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
            // Body info
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
                  const SizedBox(height: 6),
                  Text(
                    category.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: TPColors.onSurfaceVariant,
                          height: 1.4,
                        ),
                  ),
                  const SizedBox(height: 12),
                  // Tags at the bottom (using Wrap to prevent overflows)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTag(
                        context,
                        category.voltageClass.toUpperCase(),
                        TPColors.secondaryContainer,
                      ),
                      _buildTag(
                        context,
                        category.priority.toUpperCase(),
                        _getPriorityColor(category.priority),
                      ),
                      _buildTag(
                        context,
                        '$itemCount DEVICES',
                        TPColors.primary,
                      ),
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

  Widget _buildTag(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: GlassDecoration.glassTag(color: color),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}

// Animated pulse line widget matching the Stitch design
class _PulseLine extends StatefulWidget {
  const _PulseLine();

  @override
  State<_PulseLine> createState() => _PulseLineState();
}

class _PulseLineState extends State<_PulseLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          height: 2,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                TPColors.secondaryContainer,
                Colors.transparent,
              ],
              stops: [
                (_controller.value - 0.3).clamp(0.0, 1.0),
                _controller.value,
                (_controller.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
