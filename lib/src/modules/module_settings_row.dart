import 'package:flutter/widgets.dart';

abstract final class ModuleSettingsRowPlacement {
  static const contacts = 'contacts';
}

final class ModuleSettingsRow {
  const ModuleSettingsRow({
    required this.id,
    required this.moduleId,
    required this.placement,
    required this.title,
    required this.routeId,
    required this.icon,
    required this.color,
    this.colors,
    this.subtitle = '',
    this.sortOrder = 0,
  });

  final String id;
  final String moduleId;
  final String placement;
  final String title;
  final String subtitle;
  final String routeId;
  final IconData icon;
  final Color color;
  final List<Color>? colors;
  final int sortOrder;
}
