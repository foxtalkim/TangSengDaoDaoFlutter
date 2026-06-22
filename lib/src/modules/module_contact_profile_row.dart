final class ModuleContactProfileRow {
  const ModuleContactProfileRow({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.routeId,
    this.sortOrder = 0,
  });

  final String id;
  final String moduleId;
  final String title;
  final String routeId;
  final int sortOrder;
}
