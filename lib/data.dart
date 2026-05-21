import 'package:flutter/material.dart';

// ─── Stat Card Data ───
class StatData {
  final String label;
  final String value;
  final IconData icon;
  final bool isLive;
  final String? lottieAsset;

  const StatData({
    required this.label,
    required this.value,
    required this.icon,
    this.isLive = false,
    this.lottieAsset,
  });
}

const List<StatData> liveMetrics = [
  StatData(
    label: 'electricity',
    value: '415 V',
    icon: Icons.bolt,
    isLive: true,
    lottieAsset: 'json/electricity.json',
  ),
  StatData(
    label: 'Locations',
    value: '45 Sites',
    icon: Icons.location_on,
    lottieAsset: 'json/Locations.json',
  ),
  StatData(
    label: 'Maintenance',
    value: '12 Tasks',
    icon: Icons.build,
    lottieAsset: 'json/Maintenance.json',
  ),
  StatData(
    label: 'Photos',
    value: '182 Uploads',
    icon: Icons.photo_library,
    lottieAsset: 'json/Photos.json',
  ),
  StatData(
    label: 'SCADA Signal',
    value: 'Online',
    icon: Icons.wifi,
    isLive: true,
    lottieAsset: 'json/SCADA Signal.json',
  ),
  StatData(
    label: 'UPS battery',
    value: '98% Cap',
    icon: Icons.battery_charging_full,
    isLive: true,
    lottieAsset: 'json/UPS battery.json',
  ),
];

// ─── Core System Module Data ───
class SystemModule {
  final String title;
  final String description;
  final IconData icon;

  const SystemModule({
    required this.title,
    required this.description,
    required this.icon,
  });
}

const List<SystemModule> coreSystemModules = [
  SystemModule(
    title: 'Substation',
    description: 'Understand the grid distribution and transformer operations.',
    icon: Icons.electrical_services,
  ),
  SystemModule(
    title: 'Data Centre',
    description: 'Learn about server architecture and SCADA data flow.',
    icon: Icons.dns,
  ),
  SystemModule(
    title: 'Control Room',
    description: 'Explore the central hub for monitoring grid stability.',
    icon: Icons.dashboard_customize,
  ),
];

// ─── Substation Component Data ───
class SubstationComponent {
  final String name;
  final String shortName;
  final String description;
  final IconData icon;
  final String voltageClass;
  final String priority;
  final Color priorityColor;
  final List<String> specs;
  final List<String> features;
  final String detailedDescription;

  const SubstationComponent({
    required this.name,
    required this.shortName,
    required this.description,
    required this.icon,
    required this.voltageClass,
    required this.priority,
    required this.priorityColor,
    required this.specs,
    required this.features,
    required this.detailedDescription,
  });
}

final List<SubstationComponent> substationComponents = [
  SubstationComponent(
    name: 'Remote Terminal Unit (RTU)',
    shortName: 'RTU',
    description:
        'Microprocessor-controlled electronic device that interfaces objects in the physical world to a SCADA system.',
    icon: Icons.router,
    voltageClass: '11kV – 33kV',
    priority: 'CRITICAL',
    priorityColor: const Color(0xFFEEC140),
    specs: [
      'Protocol: IEC 61850 / DNP3',
      'Communication: Fiber / GSM / Radio',
      'Data Points: Up to 5,000 I/O',
      'Response Time: < 4ms',
      'Power Supply: 110V DC / 48V DC',
      'Operating Temp: -20°C to 70°C',
    ],
    features: [
      'Real-time data acquisition from field devices',
      'Automatic switching & load management',
      'Event logging with millisecond timestamps',
      'Self-diagnostic and watchdog capabilities',
      'Remote firmware upgrade support',
    ],
    detailedDescription:
        'The RTU is the critical data bridge between substation equipment and the central SCADA system. It continuously monitors analog values (voltage, current, power) and digital states (breaker positions, alarms) across the 33kV and 11kV network. TPCODL deploys over 430 RTU nodes across Odisha, enabling real-time visibility into grid health. Modern RTUs support IEC 61850 GOOSE messaging for sub-cycle protection coordination.',
  ),
  SubstationComponent(
    name: 'Ring Main Unit (RMU)',
    shortName: 'RMU',
    description:
        'A factory assembled, metal enclosed set of switchgear used at the load connection points of a ring-type distribution network.',
    icon: Icons.switch_access_shortcut,
    voltageClass: '11kV',
    priority: 'HIGH',
    priorityColor: const Color(0xFF006493),
    specs: [
      'Rated Voltage: 12kV / 24kV',
      'Rated Current: 630A',
      'Short-circuit: 25kA (3s)',
      'Insulation: SF₆ Gas / Solid',
      'IP Rating: IP67',
      'Configurations: 2L+1T / 3L+1T',
    ],
    features: [
      'Compact footprint for urban substations',
      'Fully sealed SF₆ gas insulated system',
      'Motorized switching for remote operation',
      'Integrated fault passage indicators',
      'Maintenance-free design for 30+ years',
    ],
    detailedDescription:
        'The RMU is the backbone of TPCODL\'s 11kV ring distribution network across Bhubaneswar and Cuttack. Each RMU provides a connection point where power can flow from two alternate directions, ensuring supply continuity even during maintenance. The compact, sealed design makes them ideal for urban and semi-urban installations. TPCODL operates 856+ active RMUs with real-time monitoring through integrated sensors.',
  ),
  SubstationComponent(
    name: 'Power Transformer',
    shortName: 'Transformer',
    description:
        'Passive electrical device that transfers electrical energy from one circuit to another, stepping voltage up or down for transmission efficiency.',
    icon: Icons.electric_meter,
    voltageClass: '33kV / 11kV',
    priority: 'CORE',
    priorityColor: const Color(0xFFBA1A1A),
    specs: [
      'Capacity: 5 MVA – 50 MVA',
      'Primary: 33kV ± 5% taps',
      'Secondary: 11kV',
      'Cooling: ONAN / ONAF',
      'Vector Group: Dyn11',
      'Impedance: 8% – 12%',
    ],
    features: [
      'On-load tap changer for voltage regulation',
      'Buchholz relay for internal fault detection',
      'Oil temperature & winding temperature indicators',
      'Silica gel breather for moisture prevention',
      'Conservator tank with magnetic oil gauge',
    ],
    detailedDescription:
        'Power transformers are the heart of every TPCODL substation, stepping down 33kV transmission voltage to 11kV distribution voltage. Each transformer is equipped with comprehensive protection systems including Buchholz relay, pressure relief device, and differential protection. The OLTC (On-Load Tap Changer) automatically adjusts voltage taps to maintain ±5% regulation under varying load conditions. TPCODL\'s transformer fleet is continuously monitored for dissolved gas analysis (DGA) to predict incipient faults.',
  ),
  SubstationComponent(
    name: 'Vacuum Circuit Breaker (VCB)',
    shortName: 'VCB',
    description:
        'A type of circuit breaker where the arc quenching takes place in a vacuum. Used for medium voltage power systems.',
    icon: Icons.power,
    voltageClass: '11kV – 33kV',
    priority: 'HIGH',
    priorityColor: const Color(0xFF006493),
    specs: [
      'Rated Voltage: 12kV / 36kV',
      'Breaking Capacity: 25kA / 31.5kA',
      'Making Capacity: 63kA',
      'Operating Mechanism: Spring / Motor',
      'Mechanical Life: 30,000 ops',
      'Electrical Life: 100 ops at rated',
    ],
    features: [
      'Arc quenching in high vacuum (10⁻⁶ mbar)',
      'Extremely fast fault clearing (< 3 cycles)',
      'No fire hazard – zero gas emission',
      'Compact design with withdrawable truck',
      'Anti-pumping and trip-free mechanism',
    ],
    detailedDescription:
        'The VCB is the primary protection device in TPCODL\'s 11kV and 33kV switchgear panels. When a fault occurs, the VCB contacts separate inside a vacuum interrupter, and the arc is extinguished almost instantly due to the high dielectric strength of vacuum. This makes VCBs exceptionally fast and safe. TPCODL uses both indoor (panel-mounted) and outdoor VCBs with spring-charged operating mechanisms for reliable auto-reclosure operations.',
  ),
  SubstationComponent(
    name: 'Control & Relay Panel',
    shortName: 'C&R Panel',
    description:
        'Houses numerical relays, meters, and control switches to protect and operate substation equipment safely.',
    icon: Icons.settings_system_daydream,
    voltageClass: 'Low Voltage',
    priority: 'CRITICAL',
    priorityColor: const Color(0xFFEEC140),
    specs: [
      'Relays: Numerical / Microprocessor',
      'Protection: O/C, E/F, Diff, Distance',
      'Metering: CT/PT accuracy class 0.2',
      'Communication: IEC 61850 MMS',
      'Annunciation: 40+ alarm windows',
      'Power Supply: 110V DC battery backed',
    ],
    features: [
      'Integrated numerical relays with event recording',
      'Supervisory control via SCADA interface',
      'Auto-reclosure and check-synchronization',
      'Disturbance recording for fault analysis',
      'Cybersecurity-compliant communication',
    ],
    detailedDescription:
        'The Control & Relay Panel is the nerve center of substation protection and control. It houses numerical relays that continuously monitor current, voltage, and frequency to detect faults within milliseconds. TPCODL\'s C&R panels are equipped with IEC 61850-compliant relays enabling peer-to-peer GOOSE messaging for ultra-fast protection coordination. Each panel includes disturbance recorders that capture high-resolution waveforms during fault events for post-event analysis.',
  ),
];

// ─── Systems Page Data ───
class SystemInfo {
  final String title;
  final String description;
  final IconData icon;
  final String detailText;
  final List<String> keyPoints;

  const SystemInfo({
    required this.title,
    required this.description,
    required this.icon,
    required this.detailText,
    required this.keyPoints,
  });
}

const List<SystemInfo> systemsData = [
  SystemInfo(
    title: 'Data Centre',
    description:
        'Central hub for SCADA data processing, server architecture, and network operations.',
    icon: Icons.dns,
    detailText:
        'TPCODL\'s Data Centre processes millions of data points per second from across the distribution network. It hosts the SCADA servers, historian database, and analytics engines.',
    keyPoints: [
      'Tier-III certified infrastructure',
      'Redundant power and cooling systems',
      '99.99% uptime SLA',
      'Real-time data from 1,200+ feeders',
      'Disaster recovery at alternate site',
    ],
  ),
  SystemInfo(
    title: 'PSCC (Power System Control Centre)',
    description:
        'The nerve center for real-time grid monitoring and dispatch operations.',
    icon: Icons.monitor_heart,
    detailText:
        'The PSCC operates 24/7 with trained operators monitoring the entire TPCODL distribution network through large video walls and operator workstations.',
    keyPoints: [
      '24/7 manned operations',
      'Video wall with live SLD (Single Line Diagram)',
      'Automated load management',
      'Storm and outage coordination',
      'Integration with SLDC for grid stability',
    ],
  ),
  SystemInfo(
    title: 'Control Room',
    description:
        'Local substation control and monitoring for regional grid management.',
    icon: Icons.dashboard_customize,
    detailText:
        'Each major substation has a local control room that serves as the first line of monitoring and response. Operators here handle routine switching and emergency operations.',
    keyPoints: [
      'Local SCADA HMI for real-time monitoring',
      'Bay-level control switches and indicators',
      'Event and alarm management',
      'Communication with PSCC via fiber/radio',
      'Emergency diesel generator backup',
    ],
  ),
];

// ─── Profile Data ───
class InternProfile {
  final String name;
  final String department;
  final String batchId;
  final double completionPercent;
  final int totalModules;
  final int completedModules;
  final List<Certificate> certificates;
  final List<Milestone> milestones;

  const InternProfile({
    required this.name,
    required this.department,
    required this.batchId,
    required this.completionPercent,
    required this.totalModules,
    required this.completedModules,
    required this.certificates,
    required this.milestones,
  });
}

class Certificate {
  final String title;
  final String date;
  final IconData icon;

  const Certificate({
    required this.title,
    required this.date,
    required this.icon,
  });
}

class Milestone {
  final String title;
  final String date;
  final bool completed;

  const Milestone({
    required this.title,
    required this.date,
    required this.completed,
  });
}

const internProfile = InternProfile(
  name: 'Abinash Mohanty',
  department: 'Computer Science and engineering',
  batchId: 'TPCODL-INT-2026-B3',
  completionPercent: 0.68,
  totalModules: 12,
  completedModules: 8,
  certificates: [
    Certificate(
      title: 'Substation Safety Fundamentals',
      date: 'May 5, 2026',
      icon: Icons.verified,
    ),
    Certificate(
      title: 'SCADA Operations Level-1',
      date: 'May 12, 2026',
      icon: Icons.verified,
    ),
    Certificate(
      title: 'HT Switchgear Basics',
      date: 'May 18, 2026',
      icon: Icons.verified,
    ),
  ],
  milestones: [
    Milestone(title: 'Orientation Completed', date: 'May 1', completed: true),
    Milestone(
      title: 'Substation Visit – Mancheswar',
      date: 'May 4',
      completed: true,
    ),
    Milestone(title: 'SCADA Lab Training', date: 'May 8', completed: true),
    Milestone(title: 'RMU Field Inspection', date: 'May 12', completed: true),
    Milestone(title: 'Control Room Shadowing', date: 'May 16', completed: true),
    Milestone(
      title: 'Transformer Testing Lab',
      date: 'May 20',
      completed: true,
    ),
    Milestone(
      title: 'Protection Relay Programming',
      date: 'May 24',
      completed: false,
    ),
    Milestone(title: 'Final Assessment', date: 'May 30', completed: false),
  ],
);
