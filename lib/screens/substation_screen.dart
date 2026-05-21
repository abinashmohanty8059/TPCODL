import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';
import '../models/substation_equipment.dart';
import '../services/substation_data_service.dart';
import '../widgets/component_card.dart';
import '../widgets/glass_card.dart';
import 'component_detail_screen.dart';
import 'category_detail_screen.dart';

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
                    _buildSCADADashboardHeader(),
                    _buildSearchSection(),
                    _buildContentSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSCADADashboardHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Substation Monitor',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: TPColors.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
              ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05, end: 0),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PulsingLed(color: Color(0xFF00C853)),
                    SizedBox(width: 6),
                    Text(
                      'GRID HEALTHY',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF00C853),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
            ],
          ),
          const SizedBox(height: 12),

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
                    Text(
                      'SYSTEM OPERATIONS TELEMETRY',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: TPColors.primary,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSCADAMetric('33 / 11 kV', 'SYSTEM RATING', Icons.bolt),
                    _buildSCADAMetric('49.98 Hz', 'FREQUENCY', Icons.waves),
                    _buildSCADAMetric('1.00', 'POWER FACTOR', Icons.speed),
                    _buildSCADAMetric('30 Nodes', 'ACTIVE I/O', Icons.settings_input_component),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildQuickStatCard(
                  'Monitored Types',
                  '${_categories.length} Categories',
                  Icons.developer_board,
                  Colors.blue.shade600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickStatCard(
                  'Comm Status',
                  '100% ONLINE',
                  Icons.wifi,
                  Colors.green.shade600,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
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
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: TPColors.onSurface,
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
        ),
      ],
    );
  }

  Widget _buildQuickStatCard(String title, String value, IconData icon, Color color) {
    return GlassCard(
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: TPColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
      // Show list of Categories
      return ListView.builder(
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
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: TPColors.primaryContainer.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: TPColors.primaryContainer.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 6),
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
                  color: TPColors.surfaceContainerLow,
                  child: Image.asset(
                    'subststion_data/pic/${category.coverImage.split('/').last}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.electrical_services, size: 48, color: Colors.grey),
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
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                ),
                // Priority Badge top right
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      category.priority,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: category.priority == 'CRITICAL' ? Colors.red.shade400 : Colors.amber.shade400,
                      ),
                    ),
                  ),
                ),
                // Items Count badge bottom left
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.cyan.shade900,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.cyan.shade300.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      '$itemCount DEVICES',
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
            // Body info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: TPColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    category.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: TPColors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
